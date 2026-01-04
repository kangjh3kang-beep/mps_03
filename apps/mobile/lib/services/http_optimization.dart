import 'package:dio/dio.dart';
import '../config/mvp_config.dart';

/// HTTP 캐싱 인터셉터 - API 응답 < 200ms 목표 달성
class CachingInterceptor extends Interceptor {
  final Map<String, CachedResponse> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // GET 요청만 캐싱
    if (options.method == 'GET' && PerformanceConfig.httpCacheConfig['enabled'] == true) {
      final cachedData = _getFromCache(options.uri.toString());
      if (cachedData != null) {
        // 캐시에서 즉시 반환 (< 1ms)
        return handler.resolve(cachedData);
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 성공한 GET 응답 캐싱
    if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
      _saveToCache(response);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 오류 발생 시 오래된 캐시 사용 (stale-while-revalidate)
    if (err.requestOptions.method == 'GET') {
      final stale = _getStaleFromCache(err.requestOptions.uri.toString());
      if (stale != null) {
        return handler.resolve(stale);
      }
    }

    handler.next(err);
  }

  // ===== 캐시 관리 메서드 =====

  CachedResponse? _getFromCache(String url) {
    final cached = _cache[url];
    if (cached == null) return null;

    final timestamp = _cacheTimestamps[url];
    if (timestamp == null) return null;

    final maxAge = PerformanceConfig.httpCacheConfig['maxAge'] as Duration;
    final isExpired = DateTime.now().difference(timestamp) > maxAge;

    if (!isExpired) {
      return cached; // 신선한 캐시
    }
    return null; // 만료된 캐시는 null 반환
  }

  CachedResponse? _getStaleFromCache(String url) {
    final cached = _cache[url];
    if (cached == null) return null;

    final timestamp = _cacheTimestamps[url];
    if (timestamp == null) return null;

    final maxStale = PerformanceConfig.httpCacheConfig['maxStale'] as Duration;
    final isStale = DateTime.now().difference(timestamp) > maxStale;

    if (!isStale) {
      return cached; // 아직 사용 가능한 stale 캐시
    }

    // maxStale을 초과했으면 캐시 삭제
    _cache.remove(url);
    _cacheTimestamps.remove(url);
    return null;
  }

  void _saveToCache(Response response) {
    final url = response.requestOptions.uri.toString();
    _cache[url] = response as CachedResponse;
    _cacheTimestamps[url] = DateTime.now();

    // 메모리 사용량 제한 (최대 100개 항목)
    if (_cache.length > 100) {
      final oldestUrl = _cacheTimestamps.entries
          .reduce((a, b) => a.value.isBefore(b.value) ? a : b)
          .key;
      _cache.remove(oldestUrl);
      _cacheTimestamps.remove(oldestUrl);
    }
  }

  /// 특정 패턴의 캐시 무효화 (예: '/measurement/*')
  void invalidatePattern(String pattern) {
    final regex = RegExp(pattern.replaceAll('*', '.*'));
    _cache.removeWhere((url, _) => regex.hasMatch(url));
    _cacheTimestamps.removeWhere((url, _) => regex.hasMatch(url));
  }

  /// 모든 캐시 초기화
  void clearAll() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  /// 캐시 통계
  Map<String, dynamic> getCacheStats() {
    return {
      'totalCached': _cache.length,
      'totalSize': _cache.values.fold<int>(
        0,
        (sum, response) => sum + (response.data.toString().length),
      ),
      'oldestEntry': _cacheTimestamps.isEmpty
          ? null
          : _cacheTimestamps.values
              .reduce((a, b) => a.isBefore(b) ? a : b),
      'newestEntry': _cacheTimestamps.isEmpty
          ? null
          : _cacheTimestamps.values
              .reduce((a, b) => a.isAfter(b) ? a : b),
    };
  }
}

/// 응답 시간 모니터링 인터셉터 (< 200ms 목표)
class PerformanceMonitorInterceptor extends Interceptor {
  final List<ApiMetric> _metrics = [];
  static const targetResponseTime = Duration(milliseconds: 200);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      final metric = ApiMetric(
        url: response.requestOptions.uri.toString(),
        method: response.requestOptions.method,
        statusCode: response.statusCode,
        duration: duration,
        timestamp: DateTime.now(),
      );

      _metrics.add(metric);
      _handleSlowResponse(metric);

      // 메트릭 로깅 (개발 환경에서만)
      print(
        '[API Performance] ${metric.method} ${metric.url} '
        '${metric.statusCode} (${metric.duration.inMilliseconds}ms)',
      );
    }

    handler.next(response);
  }

  void _handleSlowResponse(ApiMetric metric) {
    if (metric.duration > targetResponseTime) {
      print(
        '[WARNING] Slow API: ${metric.url} took ${metric.duration.inMilliseconds}ms '
        '(target: ${targetResponseTime.inMilliseconds}ms)',
      );
      // 여기서 Firebase Crashlytics에 로깅 가능
    }
  }

  /// 성능 통계 조회
  Map<String, dynamic> getPerformanceStats() {
    if (_metrics.isEmpty) {
      return {
        'totalRequests': 0,
        'averageResponseTime': 0,
        'slowRequests': 0,
        'fastestRequest': 0,
        'slowestRequest': 0,
      };
    }

    final durations = _metrics.map((m) => m.duration.inMilliseconds).toList();
    final slowCount = _metrics
        .where((m) => m.duration > targetResponseTime)
        .length;

    return {
      'totalRequests': _metrics.length,
      'averageResponseTime':
          (durations.reduce((a, b) => a + b) / durations.length).toStringAsFixed(2),
      'slowRequests': slowCount,
      'slowPercentage': ((slowCount / _metrics.length) * 100).toStringAsFixed(1),
      'fastestRequest': durations.reduce((a, b) => a < b ? a : b),
      'slowestRequest': durations.reduce((a, b) => a > b ? a : b),
      'p95ResponseTime': _calculatePercentile(durations, 0.95),
      'p99ResponseTime': _calculatePercentile(durations, 0.99),
    };
  }

  int _calculatePercentile(List<int> values, double percentile) {
    final sorted = List<int>.from(values)..sort();
    final index = ((sorted.length - 1) * percentile).round();
    return sorted[index];
  }

  /// 최근 N개 요청의 상세 정보
  List<Map<String, dynamic>> getRecentMetrics(int count) {
    return _metrics
        .skip((_metrics.length - count).clamp(0, _metrics.length))
        .map((m) => {
          'url': m.url,
          'method': m.method,
          'statusCode': m.statusCode,
          'duration': '${m.duration.inMilliseconds}ms',
          'timestamp': m.timestamp.toIso8601String(),
          'isSlow': m.duration > targetResponseTime,
        })
        .toList();
  }
}

class ApiMetric {
  final String url;
  final String method;
  final int? statusCode;
  final Duration duration;
  final DateTime timestamp;

  ApiMetric({
    required this.url,
    required this.method,
    required this.statusCode,
    required this.duration,
    required this.timestamp,
  });
}

/// Dio 확장 메서드 - 인터셉터 자동 추가
extension DioInterceptorExtension on Dio {
  void enableCaching() {
    interceptors.add(CachingInterceptor());
  }

  void enablePerformanceMonitoring() {
    interceptors.add(PerformanceMonitorInterceptor());
  }

  void enableOptimizations() {
    enableCaching();
    enablePerformanceMonitoring();
  }
}
