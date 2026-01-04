import 'package:dio/dio.dart';
import 'dart:async';
import '../config/api_config.dart';

class HttpClientService {
  final Dio _dio;

  HttpClientService(this._dio) {
    _initializeInterceptors();
  }

  Dio get dio => _dio;

  void _initializeInterceptors() {
    if (ApiConfig.currentEnvironment == ApiConfig.Environment.development) {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Mock Adapter Logic
          await Future.delayed(const Duration(milliseconds: 800)); // Simulate network latency

          if (options.path.contains('/auth/login')) {
            return handler.resolve(Response(
              requestOptions: options,
              data: {
                'token': 'mock_jwt_token_12345',
                'user': {
                  'id': 'user_001',
                  'email': 'test@manpasik.com',
                  'name': '홍길동',
                }
              },
              statusCode: 200,
            ));
          }

          if (options.path.contains('/measurements/session')) {
             return handler.resolve(Response(
              requestOptions: options,
              data: {
                'sessionId': 'session_${DateTime.now().millisecondsSinceEpoch}',
                'status': 'created',
              },
              statusCode: 201,
            ));
          }
          
          return handler.next(options);
        },
      ));
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data is Map<String, dynamic>
          ? response.data
          : {'data': response.data};
    } else {
      throw HttpException(
        statusCode: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
        response: response.data,
      );
    }
  }

  Exception _handleException(DioException e) {
    if (e.response != null) {
      return HttpException(
        statusCode: e.response!.statusCode ?? 0,
        message: e.response!.statusMessage ?? 'HTTP Error',
        response: e.response!.data,
      );
    }
    return HttpException(
      statusCode: -1,
      message: e.message ?? 'Network Error',
      response: null,
    );
  }
}

class HttpException implements Exception {
  final int statusCode;
  final String message;
  final dynamic response;

  HttpException({
    required this.statusCode,
    required this.message,
    this.response,
  });

  @override
  String toString() => 'HttpException(statusCode: $statusCode, message: $message)';
}
