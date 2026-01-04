import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/measurement/presentation/bloc/measurement_process_bloc.dart';
import '../core/di/injection.dart';

class ManpasikApp extends StatelessWidget {
  const ManpasikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthBloc>()),
        BlocProvider.value(value: getIt<ThemeBloc>()),
        BlocProvider.value(value: getIt<LocaleBloc>()),
        BlocProvider(create: (_) => getIt<MeasurementProcessBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp.router(
                title: '만파식',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                locale: localeState.locale,
                supportedLocales: const [
                  Locale('ko', 'KR'),
                  Locale('en', 'US'),
                  Locale('ja', 'JP'),
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
