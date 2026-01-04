import 'package:flutter/material.dart';

/// 다국어 지원 서비스 - 8개 언어
/// 기획안: ko, en, ja, zh, es, fr, de, vi
class LocalizationService {
  static const List<LocaleInfo> supportedLocales = [
    LocaleInfo(
      locale: Locale('ko', 'KR'),
      name: '한국어',
      nativeName: '한국어',
      flag: '🇰🇷',
    ),
    LocaleInfo(
      locale: Locale('en', 'US'),
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    LocaleInfo(
      locale: Locale('ja', 'JP'),
      name: 'Japanese',
      nativeName: '日本語',
      flag: '🇯🇵',
    ),
    LocaleInfo(
      locale: Locale('zh', 'CN'),
      name: 'Chinese (Simplified)',
      nativeName: '简体中文',
      flag: '🇨🇳',
    ),
    LocaleInfo(
      locale: Locale('zh', 'TW'),
      name: 'Chinese (Traditional)',
      nativeName: '繁體中文',
      flag: '🇹🇼',
    ),
    LocaleInfo(
      locale: Locale('es', 'ES'),
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
    ),
    LocaleInfo(
      locale: Locale('fr', 'FR'),
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
    ),
    LocaleInfo(
      locale: Locale('de', 'DE'),
      name: 'German',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
    ),
    LocaleInfo(
      locale: Locale('vi', 'VN'),
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      flag: '🇻🇳',
    ),
  ];

  /// 현재 로케일 가져오기
  static Locale getCurrentLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }

  /// 로케일 정보 가져오기
  static LocaleInfo? getLocaleInfo(Locale locale) {
    try {
      return supportedLocales.firstWhere(
        (l) => l.locale.languageCode == locale.languageCode,
      );
    } catch (e) {
      return supportedLocales.first; // 기본 한국어
    }
  }

  /// 지원 언어 목록 가져오기
  static List<Locale> getSupportedLocales() {
    return supportedLocales.map((l) => l.locale).toList();
  }
}

class LocaleInfo {
  final Locale locale;
  final String name;
  final String nativeName;
  final String flag;

  const LocaleInfo({
    required this.locale,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

/// 앱 문자열 - 기본 한국어
class AppStrings {
  // ===== 공통 =====
  static const Map<String, Map<String, String>> _strings = {
    // 공통
    'app_name': {
      'ko': '만파식',
      'en': 'Manpasik',
      'ja': 'マンパシク',
      'zh': '万帕式',
      'es': 'Manpasik',
      'fr': 'Manpasik',
      'de': 'Manpasik',
      'vi': 'Manpasik',
    },
    'home': {
      'ko': '홈',
      'en': 'Home',
      'ja': 'ホーム',
      'zh': '首页',
      'es': 'Inicio',
      'fr': 'Accueil',
      'de': 'Startseite',
      'vi': 'Trang chủ',
    },
    'measurement': {
      'ko': '측정',
      'en': 'Measurement',
      'ja': '測定',
      'zh': '测量',
      'es': 'Medición',
      'fr': 'Mesure',
      'de': 'Messung',
      'vi': 'Đo lường',
    },
    'analysis': {
      'ko': '분석',
      'en': 'Analysis',
      'ja': '分析',
      'zh': '分析',
      'es': 'Análisis',
      'fr': 'Analyse',
      'de': 'Analyse',
      'vi': 'Phân tích',
    },
    'ai_coach': {
      'ko': 'AI 코치',
      'en': 'AI Coach',
      'ja': 'AIコーチ',
      'zh': 'AI教练',
      'es': 'Coach IA',
      'fr': 'Coach IA',
      'de': 'KI-Coach',
      'vi': 'Huấn luyện AI',
    },
    'more': {
      'ko': '더보기',
      'en': 'More',
      'ja': 'もっと見る',
      'zh': '更多',
      'es': 'Más',
      'fr': 'Plus',
      'de': 'Mehr',
      'vi': 'Xem thêm',
    },
    'settings': {
      'ko': '설정',
      'en': 'Settings',
      'ja': '設定',
      'zh': '设置',
      'es': 'Configuración',
      'fr': 'Paramètres',
      'de': 'Einstellungen',
      'vi': 'Cài đặt',
    },
    'login': {
      'ko': '로그인',
      'en': 'Login',
      'ja': 'ログイン',
      'zh': '登录',
      'es': 'Iniciar sesión',
      'fr': 'Connexion',
      'de': 'Anmelden',
      'vi': 'Đăng nhập',
    },
    'signup': {
      'ko': '회원가입',
      'en': 'Sign Up',
      'ja': '新規登録',
      'zh': '注册',
      'es': 'Registrarse',
      'fr': 'S\'inscrire',
      'de': 'Registrieren',
      'vi': 'Đăng ký',
    },
    'logout': {
      'ko': '로그아웃',
      'en': 'Logout',
      'ja': 'ログアウト',
      'zh': '退出',
      'es': 'Cerrar sesión',
      'fr': 'Déconnexion',
      'de': 'Abmelden',
      'vi': 'Đăng xuất',
    },
    'cancel': {
      'ko': '취소',
      'en': 'Cancel',
      'ja': 'キャンセル',
      'zh': '取消',
      'es': 'Cancelar',
      'fr': 'Annuler',
      'de': 'Abbrechen',
      'vi': 'Hủy',
    },
    'confirm': {
      'ko': '확인',
      'en': 'Confirm',
      'ja': '確認',
      'zh': '确认',
      'es': 'Confirmar',
      'fr': 'Confirmer',
      'de': 'Bestätigen',
      'vi': 'Xác nhận',
    },
    'save': {
      'ko': '저장',
      'en': 'Save',
      'ja': '保存',
      'zh': '保存',
      'es': 'Guardar',
      'fr': 'Enregistrer',
      'de': 'Speichern',
      'vi': 'Lưu',
    },
    'delete': {
      'ko': '삭제',
      'en': 'Delete',
      'ja': '削除',
      'zh': '删除',
      'es': 'Eliminar',
      'fr': 'Supprimer',
      'de': 'Löschen',
      'vi': 'Xóa',
    },
    'next': {
      'ko': '다음',
      'en': 'Next',
      'ja': '次へ',
      'zh': '下一步',
      'es': 'Siguiente',
      'fr': 'Suivant',
      'de': 'Weiter',
      'vi': 'Tiếp theo',
    },
    'back': {
      'ko': '이전',
      'en': 'Back',
      'ja': '戻る',
      'zh': '返回',
      'es': 'Atrás',
      'fr': 'Retour',
      'de': 'Zurück',
      'vi': 'Quay lại',
    },

    // ===== 측정 관련 =====
    'blood_glucose': {
      'ko': '혈당',
      'en': 'Blood Glucose',
      'ja': '血糖値',
      'zh': '血糖',
      'es': 'Glucosa en sangre',
      'fr': 'Glycémie',
      'de': 'Blutzucker',
      'vi': 'Đường huyết',
    },
    'blood_pressure': {
      'ko': '혈압',
      'en': 'Blood Pressure',
      'ja': '血圧',
      'zh': '血压',
      'es': 'Presión arterial',
      'fr': 'Pression artérielle',
      'de': 'Blutdruck',
      'vi': 'Huyết áp',
    },
    'heart_rate': {
      'ko': '심박수',
      'en': 'Heart Rate',
      'ja': '心拍数',
      'zh': '心率',
      'es': 'Frecuencia cardíaca',
      'fr': 'Fréquence cardiaque',
      'de': 'Herzfrequenz',
      'vi': 'Nhịp tim',
    },
    'oxygen_level': {
      'ko': '산소포화도',
      'en': 'Oxygen Level',
      'ja': '酸素飽和度',
      'zh': '血氧水平',
      'es': 'Nivel de oxígeno',
      'fr': 'Niveau d\'oxygène',
      'de': 'Sauerstoffgehalt',
      'vi': 'Nồng độ oxy',
    },
    'start_measurement': {
      'ko': '측정 시작',
      'en': 'Start Measurement',
      'ja': '測定開始',
      'zh': '开始测量',
      'es': 'Iniciar medición',
      'fr': 'Démarrer la mesure',
      'de': 'Messung starten',
      'vi': 'Bắt đầu đo',
    },
    'insert_cartridge': {
      'ko': '카트리지 삽입',
      'en': 'Insert Cartridge',
      'ja': 'カートリッジを挿入',
      'zh': '插入盒带',
      'es': 'Insertar cartucho',
      'fr': 'Insérer la cartouche',
      'de': 'Patrone einlegen',
      'vi': 'Lắp hộp mực',
    },
    'measuring': {
      'ko': '측정 중...',
      'en': 'Measuring...',
      'ja': '測定中...',
      'zh': '测量中...',
      'es': 'Midiendo...',
      'fr': 'Mesure en cours...',
      'de': 'Messung läuft...',
      'vi': 'Đang đo...',
    },
    'result': {
      'ko': '결과',
      'en': 'Result',
      'ja': '結果',
      'zh': '结果',
      'es': 'Resultado',
      'fr': 'Résultat',
      'de': 'Ergebnis',
      'vi': 'Kết quả',
    },
    'normal': {
      'ko': '정상',
      'en': 'Normal',
      'ja': '正常',
      'zh': '正常',
      'es': 'Normal',
      'fr': 'Normal',
      'de': 'Normal',
      'vi': 'Bình thường',
    },
    'warning': {
      'ko': '주의',
      'en': 'Warning',
      'ja': '注意',
      'zh': '注意',
      'es': 'Advertencia',
      'fr': 'Attention',
      'de': 'Warnung',
      'vi': 'Cảnh báo',
    },
    'critical': {
      'ko': '위험',
      'en': 'Critical',
      'ja': '危険',
      'zh': '危险',
      'es': 'Crítico',
      'fr': 'Critique',
      'de': 'Kritisch',
      'vi': 'Nguy hiểm',
    },

    // ===== AI 코칭 =====
    'ai_insight': {
      'ko': 'AI 인사이트',
      'en': 'AI Insight',
      'ja': 'AIインサイト',
      'zh': 'AI洞察',
      'es': 'Información de IA',
      'fr': 'Aperçu IA',
      'de': 'KI-Einblick',
      'vi': 'Thông tin AI',
    },
    'health_coaching': {
      'ko': '건강 코칭',
      'en': 'Health Coaching',
      'ja': '健康コーチング',
      'zh': '健康指导',
      'es': 'Coaching de salud',
      'fr': 'Coaching santé',
      'de': 'Gesundheitscoaching',
      'vi': 'Huấn luyện sức khỏe',
    },
    'diet_recommendation': {
      'ko': '식단 추천',
      'en': 'Diet Recommendation',
      'ja': '食事の推奨',
      'zh': '饮食建议',
      'es': 'Recomendación de dieta',
      'fr': 'Recommandation alimentaire',
      'de': 'Ernährungsempfehlung',
      'vi': 'Đề xuất chế độ ăn',
    },
    'exercise_recommendation': {
      'ko': '운동 추천',
      'en': 'Exercise Recommendation',
      'ja': '運動の推奨',
      'zh': '运动建议',
      'es': 'Recomendación de ejercicio',
      'fr': 'Recommandation d\'exercice',
      'de': 'Trainingsempfehlung',
      'vi': 'Đề xuất tập luyện',
    },

    // ===== 마켓플레이스 =====
    'marketplace': {
      'ko': '마켓플레이스',
      'en': 'Marketplace',
      'ja': 'マーケットプレイス',
      'zh': '市场',
      'es': 'Mercado',
      'fr': 'Marché',
      'de': 'Marktplatz',
      'vi': 'Chợ',
    },
    'cartridge_mall': {
      'ko': '카트리지몰',
      'en': 'Cartridge Mall',
      'ja': 'カートリッジモール',
      'zh': '盒带商城',
      'es': 'Centro de cartuchos',
      'fr': 'Centre de cartouches',
      'de': 'Patronenzentrum',
      'vi': 'Trung tâm hộp mực',
    },
    'health_mall': {
      'ko': '건강몰',
      'en': 'Health Mall',
      'ja': '健康モール',
      'zh': '健康商城',
      'es': 'Centro de salud',
      'fr': 'Centre santé',
      'de': 'Gesundheitszentrum',
      'vi': 'Trung tâm sức khỏe',
    },
    'subscription': {
      'ko': '구독',
      'en': 'Subscription',
      'ja': 'サブスクリプション',
      'zh': '订阅',
      'es': 'Suscripción',
      'fr': 'Abonnement',
      'de': 'Abonnement',
      'vi': 'Đăng ký',
    },
    'add_to_cart': {
      'ko': '장바구니에 추가',
      'en': 'Add to Cart',
      'ja': 'カートに追加',
      'zh': '加入购物车',
      'es': 'Añadir al carrito',
      'fr': 'Ajouter au panier',
      'de': 'Zum Warenkorb hinzufügen',
      'vi': 'Thêm vào giỏ hàng',
    },
    'checkout': {
      'ko': '결제하기',
      'en': 'Checkout',
      'ja': 'チェックアウト',
      'zh': '结账',
      'es': 'Pagar',
      'fr': 'Passer à la caisse',
      'de': 'Zur Kasse',
      'vi': 'Thanh toán',
    },

    // ===== 화상진료 =====
    'telemedicine': {
      'ko': '화상진료',
      'en': 'Telemedicine',
      'ja': '遠隔医療',
      'zh': '远程医疗',
      'es': 'Telemedicina',
      'fr': 'Télémédecine',
      'de': 'Telemedizin',
      'vi': 'Y tế từ xa',
    },
    'book_appointment': {
      'ko': '예약하기',
      'en': 'Book Appointment',
      'ja': '予約する',
      'zh': '预约',
      'es': 'Reservar cita',
      'fr': 'Prendre rendez-vous',
      'de': 'Termin buchen',
      'vi': 'Đặt lịch hẹn',
    },

    // ===== 긴급 =====
    'emergency': {
      'ko': '긴급 도움',
      'en': 'Emergency',
      'ja': '緊急',
      'zh': '紧急',
      'es': 'Emergencia',
      'fr': 'Urgence',
      'de': 'Notfall',
      'vi': 'Khẩn cấp',
    },
    'emergency_help': {
      'ko': '긴급 도움 요청',
      'en': 'Emergency Help',
      'ja': '緊急ヘルプ',
      'zh': '紧急求助',
      'es': 'Ayuda de emergencia',
      'fr': 'Aide d\'urgence',
      'de': 'Notfallhilfe',
      'vi': 'Trợ giúp khẩn cấp',
    },
  };

  /// 번역된 문자열 가져오기
  static String get(String key, String languageCode) {
    final translations = _strings[key];
    if (translations == null) return key;
    return translations[languageCode] ?? translations['ko'] ?? key;
  }

  /// 현재 로케일에 맞는 문자열 가져오기
  static String tr(BuildContext context, String key) {
    final locale = Localizations.localeOf(context);
    return get(key, locale.languageCode);
  }
}

/// 문자열 확장
extension StringLocalization on String {
  String tr(BuildContext context) => AppStrings.tr(context, this);
}
