import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================
// 테마 BLoC
// ============================================

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<ChangeTheme>(_onChangeTheme);
  }

  void _onChangeTheme(ChangeTheme event, Emitter<ThemeState> emit) {
    emit(ThemeState(themeMode: event.themeMode));
  }
}

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object?> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final ThemeMode themeMode;
  const ChangeTheme(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  const ThemeState({required this.themeMode});
  @override
  List<Object?> get props => [themeMode];
}

// ============================================
// 로케일 BLoC
// ============================================

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(locale: Locale('ko', 'KR'))) {
    on<ChangeLocale>(_onChangeLocale);
  }

  void _onChangeLocale(ChangeLocale event, Emitter<LocaleState> emit) {
    emit(LocaleState(locale: event.locale));
  }
}

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();
  @override
  List<Object?> get props => [];
}

class ChangeLocale extends LocaleEvent {
  final Locale locale;
  const ChangeLocale(this.locale);
  @override
  List<Object?> get props => [locale];
}

class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState({required this.locale});
  @override
  List<Object?> get props => [locale];
}

// ============================================
// 앱 테마 정의
// ============================================

import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ============================================
  // Dark Ink (흑묵) Design System
  // ============================================
  
  // Colors
  static const Color inkBlack = Color(0xFF0A0A0A);   // Deepest Black (Background)
  static const Color inkDark = Color(0xFF1A1A1A);    // Dark Gray (Cards)
  static const Color inkMedium = Color(0xFF2A2A2A);  // Medium Gray (Borders)
  static const Color paperWhite = Color(0xFFF5F5F5); // Off-white (Text)
  static const Color accentGold = Color(0xFFD4AF37); // Gold (Active/Highlight)
  static const Color accentRed = Color(0xFFB22222);  // Red (Stamp/Alert)
  
  // Text Styles
  static TextTheme get _textTheme {
    return GoogleFonts.notoSerifKrTextTheme().copyWith(
      displayLarge: GoogleFonts.nanumBrushScript(
        color: paperWhite,
        fontSize: 56,
      ),
      displayMedium: GoogleFonts.nanumBrushScript(
        color: paperWhite,
        fontSize: 42,
      ),
      displaySmall: GoogleFonts.nanumBrushScript(
        color: paperWhite,
        fontSize: 32,
      ),
      headlineLarge: GoogleFonts.notoSerifKr(
        color: paperWhite,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.notoSerifKr(
        color: paperWhite,
      ),
      bodyMedium: GoogleFonts.notoSerifKr(
        color: paperWhite.withOpacity(0.8),
      ),
    );
  }

  // 라이트 테마 (Not used in Dark Ink system, but kept for compatibility)
  static ThemeData get lightTheme {
    return darkTheme; // Force Dark Mode for consistency
  }

  // 다크 테마 (Main Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: inkBlack,
      primaryColor: accentGold,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: accentRed,
        surface: inkDark,
        background: inkBlack,
        onPrimary: inkBlack,
        onSecondary: paperWhite,
        onSurface: paperWhite,
        onBackground: paperWhite,
      ),

      // Typography
      textTheme: _textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: inkBlack,
        foregroundColor: paperWhite,
        titleTextStyle: GoogleFonts.nanumBrushScript(
          fontSize: 28,
          color: paperWhite,
        ),
        iconTheme: const IconThemeData(color: paperWhite),
      ),

      // Card
      cardTheme: CardTheme(
        elevation: 0,
        color: inkDark.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: inkDark,
          foregroundColor: accentGold,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: accentGold),
          ),
          textStyle: GoogleFonts.notoSerifKr(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: paperWhite,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inkDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGold),
        ),
        labelStyle: TextStyle(color: paperWhite.withOpacity(0.6)),
        hintStyle: TextStyle(color: paperWhite.withOpacity(0.4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: inkBlack,
        selectedItemColor: accentGold,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontFamily: 'Noto Serif KR', fontSize: 12),
        unselectedLabelStyle: TextStyle(fontFamily: 'Noto Serif KR', fontSize: 12),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentGold,
        foregroundColor: inkBlack,
      ),
    );
  }
}

// ============================================
// 앱 테마 확장
// ============================================

extension AppThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
