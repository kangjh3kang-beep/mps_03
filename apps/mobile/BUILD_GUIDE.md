# Manpasik Mobile Build Guide

## 📋 Prerequisites

### 1. Flutter SDK 설치
```bash
# Windows
# Flutter SDK 다운로드: https://docs.flutter.dev/get-started/install/windows
# 또는 Chocolatey 사용:
choco install flutter

# MacOS
brew install flutter

# Linux
sudo snap install flutter --classic
```

### 2. Flutter 경로 설정
```bash
# Windows PowerShell (관리자 권한)
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\flutter\bin", "User")

# 또는 사용자 환경 변수에 추가:
# C:\flutter\bin
```

### 3. Flutter Doctor 확인
```bash
flutter doctor
```

### 4. Android Studio 설치 (Android 빌드용)
- https://developer.android.com/studio 에서 다운로드
- SDK Manager에서 Android SDK 설치
- AVD Manager에서 에뮬레이터 생성

### 5. Xcode 설치 (iOS 빌드용, macOS만 해당)
```bash
sudo xcode-select --install
sudo xcodebuild -license accept
```

## 🚀 빌드 및 실행

### 프로젝트 의존성 설치
```bash
cd apps/mobile
flutter pub get
```

### 코드 생성 (Freezed, JSON Serializable)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 개발 모드 실행
```bash
# 연결된 기기 확인
flutter devices

# 디버그 모드 실행
flutter run

# 특정 기기에서 실행
flutter run -d <device_id>
```

### 릴리스 빌드

#### Android APK
```bash
flutter build apk --release
# 출력: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle (Play Store용)
```bash
flutter build appbundle --release
# 출력: build/app/outputs/bundle/release/app-release.aab
```

#### iOS (macOS만 해당)
```bash
flutter build ios --release
```

## 🧪 테스트 실행

### 단위 테스트
```bash
flutter test
```

### 특정 테스트 파일 실행
```bash
flutter test test/bloc_test.dart
flutter test test/services_test.dart
flutter test test/widget_test.dart
```

### 통합 테스트
```bash
flutter test integration_test/
```

### 테스트 커버리지
```bash
flutter test --coverage
# 커버리지 리포트: coverage/lcov.info
```

## 📱 환경별 빌드

### 개발 환경
```bash
flutter run --flavor development -t lib/main_dev.dart
```

### 스테이징 환경
```bash
flutter run --flavor staging -t lib/main_staging.dart
```

### 프로덕션 환경
```bash
flutter run --flavor production -t lib/main.dart
```

## 🔧 문제 해결

### 빌드 캐시 정리
```bash
flutter clean
flutter pub get
```

### Gradle 캐시 정리 (Android)
```bash
cd android
./gradlew clean
```

### iOS 캐시 정리
```bash
cd ios
pod deintegrate
pod install
```

### 의존성 충돌 해결
```bash
flutter pub upgrade --major-versions
flutter pub get
```

## 📝 환경 변수 설정

### .env 파일 생성
```
# .env.development
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
AGORA_APP_ID=your-agora-app-id
AI_SERVICE_URL=http://localhost:8000
```

### 빌드 시 환경 변수 적용
```bash
flutter run --dart-define=ENV=development
```

## 🔐 서명 설정 (릴리스 빌드)

### Android Keystore 생성
```bash
keytool -genkey -v -keystore ~/manpasik-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias manpasik
```

### android/key.properties 생성
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=manpasik
storeFile=<path-to-keystore>
```

## 📊 빌드 크기 분석
```bash
flutter build apk --analyze-size
```

## 🔄 CI/CD 설정

### GitHub Actions 워크플로우
`.github/workflows/flutter.yml` 참조

### 자동 배포
- Android: Firebase App Distribution 또는 Google Play Console API
- iOS: App Store Connect API
