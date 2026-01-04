import 'dart:async';

/// Supabase 서비스 - 데이터 연동
/// 
/// 의존성 필요:
/// - supabase_flutter: ^2.3.0
class SupabaseService {
  // Supabase 설정 (실제 값으로 교체 필요)
  static const String _supabaseUrl = 'https://your-project.supabase.co';
  static const String _supabaseAnonKey = 'your-anon-key';

  // 싱글톤
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Supabase 클라이언트 (실제 구현에서는 SupabaseClient 타입)
  dynamic _client;
  bool _isInitialized = false;

  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 실제 구현:
      // await Supabase.initialize(
      //   url: _supabaseUrl,
      //   anonKey: _supabaseAnonKey,
      // );
      // _client = Supabase.instance.client;

      _isInitialized = true;
      print('[Supabase] 초기화 완료');
    } catch (e) {
      print('[Supabase] 초기화 실패: $e');
      rethrow;
    }
  }

  // ============================================
  // 인증 (Auth)
  // ============================================

  /// 이메일 회원가입
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // 실제 구현:
      // final response = await _client.auth.signUp(
      //   email: email,
      //   password: password,
      //   data: {'name': name},
      // );
      
      // MVP 시뮬레이션
      await Future.delayed(const Duration(milliseconds: 500));
      
      return AuthResult(
        success: true,
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: '회원가입 실패: $e',
      );
    }
  }

  /// 이메일 로그인
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // 실제 구현:
      // final response = await _client.auth.signInWithPassword(
      //   email: email,
      //   password: password,
      // );

      // MVP 시뮬레이션
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (email.contains('@') && password.length >= 6) {
        return AuthResult(
          success: true,
          userId: 'user_123',
          email: email,
        );
      } else {
        return AuthResult(
          success: false,
          error: '이메일 또는 비밀번호가 올바르지 않습니다.',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        error: '로그인 실패: $e',
      );
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      // 실제 구현:
      // await _client.auth.signOut();
      
      print('[Supabase] 로그아웃 완료');
    } catch (e) {
      print('[Supabase] 로그아웃 실패: $e');
    }
  }

  /// 현재 사용자 가져오기
  UserProfile? getCurrentUser() {
    // 실제 구현:
    // final user = _client.auth.currentUser;
    // if (user == null) return null;
    // return UserProfile.fromSupabase(user);

    // MVP 시뮬레이션
    return UserProfile(
      id: 'user_123',
      email: 'test@example.com',
      name: '테스트 사용자',
      createdAt: DateTime.now(),
    );
  }

  // ============================================
  // 측정 데이터 (Measurements)
  // ============================================

  /// 측정 결과 저장
  Future<bool> saveMeasurement(MeasurementRecord measurement) async {
    try {
      // 실제 구현:
      // await _client.from('measurements').insert({
      //   'user_id': measurement.userId,
      //   'measurement_type': measurement.type,
      //   'value': measurement.value,
      //   'unit': measurement.unit,
      //   'status': measurement.status,
      //   'metadata': measurement.metadata,
      //   'measured_at': measurement.measuredAt.toIso8601String(),
      // });

      print('[Supabase] 측정 데이터 저장: ${measurement.type}');
      return true;
    } catch (e) {
      print('[Supabase] 측정 데이터 저장 실패: $e');
      return false;
    }
  }

  /// 측정 기록 조회
  Future<List<MeasurementRecord>> getMeasurements({
    required String userId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  }) async {
    try {
      // 실제 구현:
      // var query = _client
      //   .from('measurements')
      //   .select()
      //   .eq('user_id', userId)
      //   .order('measured_at', ascending: false)
      //   .limit(limit);
      //
      // if (type != null) {
      //   query = query.eq('measurement_type', type);
      // }
      // if (startDate != null) {
      //   query = query.gte('measured_at', startDate.toIso8601String());
      // }
      // if (endDate != null) {
      //   query = query.lte('measured_at', endDate.toIso8601String());
      // }
      //
      // final response = await query;
      // return response.map((r) => MeasurementRecord.fromJson(r)).toList();

      // MVP 시뮬레이션
      return [
        MeasurementRecord(
          id: '1',
          userId: userId,
          type: 'blood_glucose',
          value: 108,
          unit: 'mg/dL',
          status: 'normal',
          measuredAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        MeasurementRecord(
          id: '2',
          userId: userId,
          type: 'blood_pressure',
          value: '128/82',
          unit: 'mmHg',
          status: 'elevated',
          measuredAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        MeasurementRecord(
          id: '3',
          userId: userId,
          type: 'heart_rate',
          value: 72,
          unit: 'bpm',
          status: 'normal',
          measuredAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
    } catch (e) {
      print('[Supabase] 측정 데이터 조회 실패: $e');
      return [];
    }
  }

  /// 최근 측정 통계
  Future<MeasurementStats> getMeasurementStats({
    required String userId,
    required String type,
    int days = 30,
  }) async {
    try {
      final measurements = await getMeasurements(
        userId: userId,
        type: type,
        startDate: DateTime.now().subtract(Duration(days: days)),
      );

      if (measurements.isEmpty) {
        return MeasurementStats(
          type: type,
          count: 0,
          average: 0,
          min: 0,
          max: 0,
        );
      }

      final values = measurements
          .where((m) => m.value is num)
          .map((m) => (m.value as num).toDouble())
          .toList();

      if (values.isEmpty) {
        return MeasurementStats(
          type: type,
          count: measurements.length,
          average: 0,
          min: 0,
          max: 0,
        );
      }

      values.sort();
      final sum = values.reduce((a, b) => a + b);

      return MeasurementStats(
        type: type,
        count: measurements.length,
        average: sum / values.length,
        min: values.first,
        max: values.last,
      );
    } catch (e) {
      print('[Supabase] 통계 조회 실패: $e');
      return MeasurementStats(type: type, count: 0, average: 0, min: 0, max: 0);
    }
  }

  // ============================================
  // 건강 점수 (Health Score)
  // ============================================

  /// 건강 점수 조회
  Future<HealthScore> getHealthScore(String userId) async {
    try {
      // 실제 구현:
      // final response = await _client
      //   .from('health_scores')
      //   .select()
      //   .eq('user_id', userId)
      //   .order('calculated_at', ascending: false)
      //   .limit(1)
      //   .single();

      // MVP 시뮬레이션
      return HealthScore(
        userId: userId,
        score: 85,
        status: 'good',
        breakdown: {
          'glucose': 90,
          'blood_pressure': 80,
          'heart_rate': 88,
          'activity': 82,
        },
        trend: 5,
        calculatedAt: DateTime.now(),
      );
    } catch (e) {
      print('[Supabase] 건강 점수 조회 실패: $e');
      return HealthScore(
        userId: userId,
        score: 0,
        status: 'unknown',
        breakdown: {},
        trend: 0,
        calculatedAt: DateTime.now(),
      );
    }
  }

  // ============================================
  // AI 코칭 (AI Coaching)
  // ============================================

  /// AI 코칭 히스토리 저장
  Future<bool> saveCoachingSession(CoachingSession session) async {
    try {
      // 실제 구현:
      // await _client.from('coaching_sessions').insert({
      //   'user_id': session.userId,
      //   'messages': session.messages,
      //   'insights': session.insights,
      //   'recommendations': session.recommendations,
      //   'session_at': session.sessionAt.toIso8601String(),
      // });

      print('[Supabase] 코칭 세션 저장');
      return true;
    } catch (e) {
      print('[Supabase] 코칭 세션 저장 실패: $e');
      return false;
    }
  }

  /// AI 코칭 히스토리 조회
  Future<List<CoachingSession>> getCoachingHistory({
    required String userId,
    int limit = 20,
  }) async {
    try {
      // 실제 구현:
      // final response = await _client
      //   .from('coaching_sessions')
      //   .select()
      //   .eq('user_id', userId)
      //   .order('session_at', ascending: false)
      //   .limit(limit);

      // MVP 시뮬레이션
      return [];
    } catch (e) {
      print('[Supabase] 코칭 히스토리 조회 실패: $e');
      return [];
    }
  }

  // ============================================
  // 예약 (Appointments)
  // ============================================

  /// 진료 예약 생성
  Future<AppointmentResult> createAppointment({
    required String patientId,
    required String doctorId,
    required DateTime scheduledAt,
    required String consultationType,
    String? reason,
  }) async {
    try {
      // 실제 구현:
      // final response = await _client.from('appointments').insert({
      //   'patient_id': patientId,
      //   'doctor_id': doctorId,
      //   'scheduled_at': scheduledAt.toIso8601String(),
      //   'consultation_type': consultationType,
      //   'reason': reason,
      //   'status': 'pending',
      // }).select().single();

      // MVP 시뮬레이션
      final appointmentId = 'apt_${DateTime.now().millisecondsSinceEpoch}';
      
      return AppointmentResult(
        success: true,
        appointmentId: appointmentId,
        scheduledAt: scheduledAt,
      );
    } catch (e) {
      return AppointmentResult(
        success: false,
        error: '예약 생성 실패: $e',
      );
    }
  }

  /// 예약 목록 조회
  Future<List<AppointmentInfo>> getAppointments({
    required String userId,
    bool upcoming = true,
  }) async {
    try {
      // 실제 구현:
      // var query = _client
      //   .from('appointments')
      //   .select('*, doctors(*)')
      //   .eq('patient_id', userId);
      //
      // if (upcoming) {
      //   query = query.gte('scheduled_at', DateTime.now().toIso8601String());
      // }
      //
      // final response = await query.order('scheduled_at');

      // MVP 시뮬레이션
      return [
        AppointmentInfo(
          id: 'apt_1',
          doctorId: 'doc_1',
          doctorName: '김건강 전문의',
          specialty: '내분비내과',
          scheduledAt: DateTime.now().add(const Duration(hours: 2)),
          consultationType: 'video',
          status: 'confirmed',
        ),
      ];
    } catch (e) {
      print('[Supabase] 예약 조회 실패: $e');
      return [];
    }
  }

  // ============================================
  // 주문 (Orders)
  // ============================================

  /// 주문 생성
  Future<OrderResult> createOrder({
    required String userId,
    required List<OrderItem> items,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      // 실제 구현:
      // final orderId = 'ord_${DateTime.now().millisecondsSinceEpoch}';
      // await _client.from('orders').insert({
      //   'id': orderId,
      //   'user_id': userId,
      //   'items': items.map((i) => i.toJson()).toList(),
      //   'shipping_address': shippingAddress,
      //   'payment_method': paymentMethod,
      //   'status': 'pending',
      //   'total_amount': items.fold(0, (sum, item) => sum + item.totalPrice),
      // });

      final orderId = 'ord_${DateTime.now().millisecondsSinceEpoch}';
      final totalAmount = items.fold<int>(0, (sum, item) => sum + item.totalPrice);

      return OrderResult(
        success: true,
        orderId: orderId,
        totalAmount: totalAmount,
      );
    } catch (e) {
      return OrderResult(
        success: false,
        error: '주문 생성 실패: $e',
      );
    }
  }

  /// 주문 내역 조회
  Future<List<OrderInfo>> getOrders({
    required String userId,
    int limit = 20,
  }) async {
    try {
      // MVP 시뮬레이션
      return [];
    } catch (e) {
      print('[Supabase] 주문 조회 실패: $e');
      return [];
    }
  }

  // ============================================
  // 실시간 구독 (Realtime)
  // ============================================

  /// 측정 데이터 실시간 구독
  StreamSubscription? subscribeMeasurements({
    required String userId,
    required void Function(MeasurementRecord) onData,
  }) {
    // 실제 구현:
    // return _client
    //   .from('measurements')
    //   .stream(primaryKey: ['id'])
    //   .eq('user_id', userId)
    //   .listen((data) {
    //     for (final record in data) {
    //       onData(MeasurementRecord.fromJson(record));
    //     }
    //   });

    return null;
  }

  /// 알림 실시간 구독
  StreamSubscription? subscribeNotifications({
    required String userId,
    required void Function(NotificationData) onData,
  }) {
    // 실제 구현:
    // return _client
    //   .from('notifications')
    //   .stream(primaryKey: ['id'])
    //   .eq('user_id', userId)
    //   .eq('read', false)
    //   .listen((data) {
    //     for (final notification in data) {
    //       onData(NotificationData.fromJson(notification));
    //     }
    //   });

    return null;
  }
}

// ============================================
// 데이터 모델
// ============================================

class AuthResult {
  final bool success;
  final String? userId;
  final String? email;
  final String? error;

  AuthResult({
    required this.success,
    this.userId,
    this.email,
    this.error,
  });
}

class UserProfile {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.createdAt,
  });
}

class MeasurementRecord {
  final String id;
  final String userId;
  final String type;
  final dynamic value;
  final String unit;
  final String status;
  final Map<String, dynamic>? metadata;
  final DateTime measuredAt;

  MeasurementRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.unit,
    required this.status,
    this.metadata,
    required this.measuredAt,
  });

  factory MeasurementRecord.fromJson(Map<String, dynamic> json) {
    return MeasurementRecord(
      id: json['id'],
      userId: json['user_id'],
      type: json['measurement_type'],
      value: json['value'],
      unit: json['unit'],
      status: json['status'],
      metadata: json['metadata'],
      measuredAt: DateTime.parse(json['measured_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'measurement_type': type,
    'value': value,
    'unit': unit,
    'status': status,
    'metadata': metadata,
    'measured_at': measuredAt.toIso8601String(),
  };
}

class MeasurementStats {
  final String type;
  final int count;
  final double average;
  final double min;
  final double max;

  MeasurementStats({
    required this.type,
    required this.count,
    required this.average,
    required this.min,
    required this.max,
  });
}

class HealthScore {
  final String userId;
  final int score;
  final String status;
  final Map<String, int> breakdown;
  final int trend;
  final DateTime calculatedAt;

  HealthScore({
    required this.userId,
    required this.score,
    required this.status,
    required this.breakdown,
    required this.trend,
    required this.calculatedAt,
  });
}

class CoachingSession {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> messages;
  final List<String> insights;
  final List<Map<String, dynamic>> recommendations;
  final DateTime sessionAt;

  CoachingSession({
    required this.id,
    required this.userId,
    required this.messages,
    required this.insights,
    required this.recommendations,
    required this.sessionAt,
  });
}

class AppointmentResult {
  final bool success;
  final String? appointmentId;
  final DateTime? scheduledAt;
  final String? error;

  AppointmentResult({
    required this.success,
    this.appointmentId,
    this.scheduledAt,
    this.error,
  });
}

class AppointmentInfo {
  final String id;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final DateTime scheduledAt;
  final String consultationType;
  final String status;

  AppointmentInfo({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.scheduledAt,
    required this.consultationType,
    required this.status,
  });
}

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final int unitPrice;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  int get totalPrice => quantity * unitPrice;

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'name': name,
    'quantity': quantity,
    'unit_price': unitPrice,
  };
}

class OrderResult {
  final bool success;
  final String? orderId;
  final int? totalAmount;
  final String? error;

  OrderResult({
    required this.success,
    this.orderId,
    this.totalAmount,
    this.error,
  });
}

class OrderInfo {
  final String id;
  final List<OrderItem> items;
  final int totalAmount;
  final String status;
  final DateTime createdAt;

  OrderInfo({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });
}

class NotificationData {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final bool read;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    required this.createdAt,
    required this.read,
  });
}
