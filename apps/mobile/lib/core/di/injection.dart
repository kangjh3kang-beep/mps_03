import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/measurement/presentation/bloc/measurement_bloc.dart';
import '../../features/ai_coach/presentation/bloc/ai_chat_bloc.dart';
import '../../app/themes/app_theme.dart';

final getIt = GetIt.instance;

/// 의존성 주입 설정
Future<void> setupDependencies() async {
  // ============ BLoC ============
  
  // Auth BLoC
  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc());
  
  // Theme BLoC
  getIt.registerLazySingleton<ThemeBloc>(() => ThemeBloc());
  
  // Locale BLoC
  getIt.registerLazySingleton<LocaleBloc>(() => LocaleBloc());
  
  // Home BLoC
  getIt.registerFactory<HomeBloc>(() => HomeBloc());
  
  // Measurement BLoC
  getIt.registerFactory<MeasurementBloc>(() => MeasurementBloc());
  
  // AI Chat BLoC
  getIt.registerFactory<AIChatBloc>(() => AIChatBloc());
}

/// BLoC 옵저버 (디버깅용)
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}
