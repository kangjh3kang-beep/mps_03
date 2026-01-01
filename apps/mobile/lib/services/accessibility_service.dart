import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum AccessibilityMode {
  none,
  senior,    // 시니어 (고대비, 대형 텍스트)
  blind,     // 맹인 (음성 가이드 강화)
  deaf       // 농아인 (수어/시각화 강화)
}

@singleton
class AccessibilityService {
  AccessibilityMode _currentMode = AccessibilityMode.none;
  
  void setMode(AccessibilityMode mode) {
    _currentMode = mode;
  }
  
  AccessibilityMode get currentMode => _currentMode;
  
  // 모드별 테마 데이터 제공
  ThemeData getThemeData(BuildContext context) {
    switch (_currentMode) {
      case AccessibilityMode.senior:
        return ThemeData.light().copyWith(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.blue),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, contrastLevel: 1.0),
        );
      case AccessibilityMode.blind:
        // 맹인 모드: 고대비 및 음성 피드백 최적화 테마
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.yellow,
        );
      case AccessibilityMode.deaf:
        // 농아인 모드: 시각적 알림 강화 테마
        return ThemeData.dark().copyWith(
          primaryColor: Colors.greenAccent,
        );
      default:
        return ThemeData.dark(); // 기본 Medical Futurism
    }
  }

  bool get isSeniorMode => _currentMode == AccessibilityMode.senior;
}
