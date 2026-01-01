import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final _client = Supabase.instance.client;

  // Authentication
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      return await _client.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      throw Exception('로그인 실패: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.manpasik://login-callback',
      );
    } catch (e) {
      throw Exception('구글 로그인 실패: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      print('로그아웃 오류: $e');
    }
  }

  // Data Sync: Measurements
  Future<void> uploadMeasurement(Map<String, dynamic> data, String hash, double trustScore) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client.from('measurements').insert({
      'user_id': userId,
      'cartridge_type': data['cartridge_type'] ?? 'UNKNOWN',
      'raw_data': data,
      'integrity_hash': hash,
      'trust_score': trustScore,
    });
  }

  // Real-time Subscription
  Stream<List<Map<String, dynamic>>> getMeasurementStream() {
    final userId = _client.auth.currentUser?.id;
    return _client
        .from('measurements')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId ?? '')
        .order('created_at');
  }

  // System Logs
  Future<void> logSystemAction(String action, String status, String severity) async {
    await _client.from('system_logs').insert({
      'action': action,
      'status': status,
      'severity': severity,
    });
  }
}
