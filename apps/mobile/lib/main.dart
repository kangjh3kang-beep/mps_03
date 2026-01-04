import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'config/service_locator.dart';
import 'config/mvp_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // MVP 모드 로그
  print('[Main] MVP Mode: ${MVPConfig.enableMVPMode}');
  print('[Main] Enabled Features: ${MVPConfig.enabledFeatures}');

  // 의존성 주입 설정
  await setupDependencies();

  // BLoC 옵저버 설정
  Bloc.observer = AppBlocObserver();

  runApp(const ManpasikApp());
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('${bloc.runtimeType} $error');
  }
}
