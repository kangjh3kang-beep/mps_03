import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import '../config/mvp_config.dart';
import '../config/api_config.dart';
import '../services/offline_mode_manager.dart';
import '../services/http_optimization.dart';
import '../services/http_client_service.dart';
import '../services/analytics_manager.dart';
import '../repositories/data_repositories.dart';
import '../features/measurement/domain/repositories/measurement_repository.dart' as domain;
import '../features/measurement/data/repositories/measurement_repository_impl.dart';
import '../features/measurement/presentation/bloc/measurement_process_bloc.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/home/domain/repositories/home_repository.dart' as home_domain;
import '../features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

/// 의존성 주입 설정
Future<void> setupDependencies() async {
  // 1. Hive 초기화
  await Hive.initFlutter();

  // 2. HTTP 클라이언트 설정
  final dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: Duration(milliseconds: ApiConfig.connectionTimeoutMs),
    receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeoutMs),
    headers: ApiConfig.getDefaultHeaders(),
  ));

  // 캐싱 및 성능 모니터링 활성화
  if (MVPConfig.enablePerformanceOptimization) {
    dio.enableOptimizations();
  }

  getIt.registerSingleton<Dio>(dio);

  // 3. HTTP 클라이언트 서비스
  final httpClient = HttpClientService(dio);
  getIt.registerSingleton<HttpClientService>(httpClient);

  // 4. 오프라인 모드 매니저
  final offlineManager = OfflineModeManager();
  await offlineManager.init();
  getIt.registerSingleton<OfflineModeManager>(offlineManager);

  // 5. Analytics 매니저
  final analyticsManager = AnalyticsManager();
  await analyticsManager.init();
  getIt.registerSingleton<AnalyticsManager>(analyticsManager);

  // 6. Repository 계층
  if (MVPConfig.enabledFeatures.measurement) {
    // Register the domain repository implementation
    getIt.registerSingleton<domain.MeasurementRepository>(
      MeasurementRepositoryImpl(getIt<HttpClientService>()),
    );

    // Register the data repository (renamed or kept as is, but we need to handle the conflict)
    // Since we imported the new one as 'domain', the old one is 'MeasurementRepository' from data_repositories.dart
    getIt.registerSingleton<MeasurementRepository>(
      MeasurementRepository(
        offlineManager: offlineManager,
        httpClient: httpClient,
      ),
    );

    // Register MeasurementProcessBloc
    getIt.registerFactory<MeasurementProcessBloc>(
      () => MeasurementProcessBloc(
        repository: getIt<domain.MeasurementRepository>(),
      ),
    );
  }

  if (MVPConfig.enabledFeatures.home) {
    // Register domain repository
    getIt.registerSingleton<home_domain.HomeRepository>(
      HomeRepositoryImpl(getIt<HttpClientService>()),
    );

    // Keep legacy repository if needed, or remove if replaced
    final homeRepo = HomeRepository(
      offlineManager: offlineManager,
      httpClient: httpClient,
    );
    await homeRepo.init();
    getIt.registerSingleton<HomeRepository>(homeRepo);
  }

  if (MVPConfig.enabledFeatures.dataHub) {
    getIt.registerSingleton<DataHubRepository>(
      DataHubRepository(
        offlineManager: offlineManager,
        httpClient: httpClient,
      ),
    );
  if (MVPConfig.enabledFeatures.dataHub) {
    getIt.registerSingleton<DataHubRepository>(
      DataHubRepository(
        offlineManager: offlineManager,
        httpClient: httpClient,
      ),
    );
  }

  // Auth Feature Dependencies
  // Register Remote Datasource
  getIt.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(getIt<HttpClientService>()),
  );

  // Register Local Datasource
  final secureStorage = const FlutterSecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();
  
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(
      getIt<FlutterSecureStorage>(),
      getIt<SharedPreferences>(),
    ),
  );

  // Register Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDatasource>(),
      getIt<AuthLocalDatasource>(),
    ),
  );

  // 7. 성능 모니터링 초기화
  if (MVPConfig.enablePerformanceOptimization) {
    final perfMonitor = PerformanceMonitor();
    getIt.registerSingleton<PerformanceMonitor>(perfMonitor);
  }

  // 8. 에러 추적 초기화
  final errorTracker = ErrorTracker();
  getIt.registerSingleton<ErrorTracker>(errorTracker);

  print('[DI] 모든 의존성 주입 완료');
}

/// 의존성 주입 정리
Future<void> cleanupDependencies() async {
  final offlineManager = getIt<OfflineModeManager>();
  await offlineManager.close();

  await Hive.close();
  print('[DI] 의존성 주입 정리 완료');
}

/// HTTP 클라이언트 서비스
class HttpClientService {
  final Dio _dio;

  HttpClientService(this._dio);

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(path, e);
      rethrow;
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(path, e);
      rethrow;
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(path, e);
      rethrow;
    }
  }

  Future<dynamic> delete(
    String path, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(path, e);
      rethrow;
    }
  }

  void _handleError(String path, DioException error) {
    final errorTracker = getIt<ErrorTracker>();
    errorTracker.logApiError(
      endpoint: path,
      statusCode: error.response?.statusCode ?? 0,
      errorMessage: error.message ?? 'Unknown error',
    );
  }
}
