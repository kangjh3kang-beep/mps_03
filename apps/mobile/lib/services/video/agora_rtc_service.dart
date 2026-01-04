import 'dart:async';

/// Agora RTC 서비스
/// 화상진료를 위한 WebRTC 기반 영상통화 서비스
/// 
/// 의존성 필요:
/// - agora_rtc_engine: ^6.3.0
/// - permission_handler: ^11.0.0
class AgoraRTCService {
  static const String _appId = 'YOUR_AGORA_APP_ID'; // 실제 App ID로 교체 필요

  // Agora 엔진 인스턴스 (실제 구현에서는 RtcEngine 타입)
  dynamic _engine;
  
  // 상태 관리
  bool _isInitialized = false;
  bool _isInCall = false;
  String? _currentChannel;
  int? _localUid;
  final Set<int> _remoteUids = {};

  // 스트림 컨트롤러
  final StreamController<AgoraEvent> _eventController = StreamController.broadcast();
  Stream<AgoraEvent> get events => _eventController.stream;

  // 싱글톤
  static final AgoraRTCService _instance = AgoraRTCService._internal();
  factory AgoraRTCService() => _instance;
  AgoraRTCService._internal();

  /// Agora 엔진 초기화
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // 권한 요청 (실제 구현)
      // await _requestPermissions();

      // 엔진 생성 (실제 구현)
      // _engine = createAgoraRtcEngine();
      // await _engine.initialize(RtcEngineContext(
      //   appId: _appId,
      //   channelProfile: ChannelProfileType.channelProfileCommunication,
      // ));

      // 이벤트 핸들러 등록
      // _registerEventHandlers();

      // 비디오 설정
      // await _engine.enableVideo();
      // await _engine.startPreview();

      _isInitialized = true;
      _emitEvent(AgoraEventType.initialized, {});
      
      print('[AgoraRTC] 초기화 완료');
      return true;
    } catch (e) {
      print('[AgoraRTC] 초기화 실패: $e');
      _emitEvent(AgoraEventType.error, {'message': '초기화 실패: $e'});
      return false;
    }
  }

  /// 채널 참가 (화상통화 시작)
  Future<bool> joinChannel({
    required String channelName,
    required String token,
    required int uid,
    bool isHost = true,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isInCall) {
      print('[AgoraRTC] 이미 통화 중입니다');
      return false;
    }

    try {
      // 채널 옵션 설정 (실제 구현)
      // final options = ChannelMediaOptions(
      //   clientRoleType: isHost 
      //     ? ClientRoleType.clientRoleBroadcaster 
      //     : ClientRoleType.clientRoleAudience,
      //   channelProfile: ChannelProfileType.channelProfileCommunication,
      // );

      // 채널 참가 (실제 구현)
      // await _engine.joinChannel(
      //   token: token,
      //   channelId: channelName,
      //   uid: uid,
      //   options: options,
      // );

      _currentChannel = channelName;
      _localUid = uid;
      _isInCall = true;
      
      _emitEvent(AgoraEventType.joinedChannel, {
        'channel': channelName,
        'uid': uid,
      });

      print('[AgoraRTC] 채널 참가: $channelName');
      return true;
    } catch (e) {
      print('[AgoraRTC] 채널 참가 실패: $e');
      _emitEvent(AgoraEventType.error, {'message': '채널 참가 실패: $e'});
      return false;
    }
  }

  /// 채널 나가기 (화상통화 종료)
  Future<void> leaveChannel() async {
    if (!_isInCall) return;

    try {
      // 채널 나가기 (실제 구현)
      // await _engine.leaveChannel();

      _emitEvent(AgoraEventType.leftChannel, {
        'channel': _currentChannel,
      });

      _isInCall = false;
      _currentChannel = null;
      _remoteUids.clear();

      print('[AgoraRTC] 채널 나감');
    } catch (e) {
      print('[AgoraRTC] 채널 나가기 실패: $e');
    }
  }

  /// 로컬 비디오 활성화/비활성화
  Future<void> enableLocalVideo(bool enabled) async {
    try {
      // await _engine.enableLocalVideo(enabled);
      _emitEvent(AgoraEventType.localVideoStateChanged, {
        'enabled': enabled,
      });
      print('[AgoraRTC] 로컬 비디오: $enabled');
    } catch (e) {
      print('[AgoraRTC] 로컬 비디오 설정 실패: $e');
    }
  }

  /// 로컬 오디오 활성화/비활성화 (음소거)
  Future<void> enableLocalAudio(bool enabled) async {
    try {
      // await _engine.enableLocalAudio(enabled);
      _emitEvent(AgoraEventType.localAudioStateChanged, {
        'enabled': enabled,
      });
      print('[AgoraRTC] 로컬 오디오: $enabled');
    } catch (e) {
      print('[AgoraRTC] 로컬 오디오 설정 실패: $e');
    }
  }

  /// 카메라 전환 (전면/후면)
  Future<void> switchCamera() async {
    try {
      // await _engine.switchCamera();
      _emitEvent(AgoraEventType.cameraSwitched, {});
      print('[AgoraRTC] 카메라 전환');
    } catch (e) {
      print('[AgoraRTC] 카메라 전환 실패: $e');
    }
  }

  /// 화면 공유 시작
  Future<void> startScreenShare() async {
    try {
      // await _engine.startScreenCapture(
      //   ScreenCaptureParameters2(
      //     captureVideo: true,
      //     captureAudio: true,
      //   ),
      // );
      _emitEvent(AgoraEventType.screenShareStarted, {});
      print('[AgoraRTC] 화면 공유 시작');
    } catch (e) {
      print('[AgoraRTC] 화면 공유 시작 실패: $e');
    }
  }

  /// 화면 공유 중지
  Future<void> stopScreenShare() async {
    try {
      // await _engine.stopScreenCapture();
      _emitEvent(AgoraEventType.screenShareStopped, {});
      print('[AgoraRTC] 화면 공유 중지');
    } catch (e) {
      print('[AgoraRTC] 화면 공유 중지 실패: $e');
    }
  }

  /// 통화 품질 정보 가져오기
  CallQualityInfo getCallQuality() {
    // 실제 구현에서는 Agora SDK에서 제공하는 품질 정보 사용
    return CallQualityInfo(
      localVideoQuality: VideoQuality.excellent,
      remoteVideoQuality: VideoQuality.good,
      networkQuality: NetworkQuality.good,
      latency: 45,
      packetLoss: 0.5,
      bitrate: 1500,
    );
  }

  /// 이벤트 발행
  void _emitEvent(AgoraEventType type, Map<String, dynamic> data) {
    _eventController.add(AgoraEvent(type: type, data: data));
  }

  /// 리소스 정리
  Future<void> dispose() async {
    if (_isInCall) {
      await leaveChannel();
    }

    // await _engine?.release();
    _engine = null;
    _isInitialized = false;

    await _eventController.close();
    print('[AgoraRTC] 리소스 정리 완료');
  }

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isInCall => _isInCall;
  String? get currentChannel => _currentChannel;
  int? get localUid => _localUid;
  Set<int> get remoteUids => Set.unmodifiable(_remoteUids);
}

// ============ 이벤트 모델 ============

enum AgoraEventType {
  initialized,
  joinedChannel,
  leftChannel,
  userJoined,
  userLeft,
  localVideoStateChanged,
  remoteVideoStateChanged,
  localAudioStateChanged,
  remoteAudioStateChanged,
  cameraSwitched,
  screenShareStarted,
  screenShareStopped,
  networkQualityChanged,
  error,
}

class AgoraEvent {
  final AgoraEventType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  AgoraEvent({
    required this.type,
    required this.data,
  }) : timestamp = DateTime.now();
}

// ============ 품질 모델 ============

enum VideoQuality { excellent, good, fair, poor, veryPoor }
enum NetworkQuality { excellent, good, fair, poor, veryPoor, disconnected }

class CallQualityInfo {
  final VideoQuality localVideoQuality;
  final VideoQuality remoteVideoQuality;
  final NetworkQuality networkQuality;
  final int latency; // ms
  final double packetLoss; // %
  final int bitrate; // kbps

  CallQualityInfo({
    required this.localVideoQuality,
    required this.remoteVideoQuality,
    required this.networkQuality,
    required this.latency,
    required this.packetLoss,
    required this.bitrate,
  });

  String get qualityDescription {
    switch (networkQuality) {
      case NetworkQuality.excellent:
        return '매우 좋음';
      case NetworkQuality.good:
        return '좋음';
      case NetworkQuality.fair:
        return '보통';
      case NetworkQuality.poor:
        return '나쁨';
      case NetworkQuality.veryPoor:
        return '매우 나쁨';
      case NetworkQuality.disconnected:
        return '연결 끊김';
    }
  }
}

// ============ 토큰 생성 서비스 (서버사이드) ============

class AgoraTokenService {
  static const String _baseUrl = 'YOUR_TOKEN_SERVER_URL';

  /// 화상통화용 토큰 생성 요청
  static Future<String?> generateToken({
    required String channelName,
    required int uid,
    required int expirationSeconds,
  }) async {
    try {
      // 실제 구현에서는 서버에 토큰 요청
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/generate-token'),
      //   body: {
      //     'channelName': channelName,
      //     'uid': uid.toString(),
      //     'expirationSeconds': expirationSeconds.toString(),
      //   },
      // );
      // 
      // if (response.statusCode == 200) {
      //   return jsonDecode(response.body)['token'];
      // }

      // MVP: 임시 토큰 (실제 환경에서는 서버에서 생성)
      return 'TEMP_TOKEN_${channelName}_$uid';
    } catch (e) {
      print('[AgoraToken] 토큰 생성 실패: $e');
      return null;
    }
  }
}

// ============ 화상진료 세션 관리자 ============

class TelemedicineSessionManager {
  final AgoraRTCService _agoraService = AgoraRTCService();
  
  String? _appointmentId;
  String? _patientId;
  String? _doctorId;
  DateTime? _sessionStartTime;

  // 세션 상태
  TelemedicineSessionState _state = TelemedicineSessionState.idle;
  TelemedicineSessionState get state => _state;

  // 이벤트 스트림
  final StreamController<TelemedicineSessionEvent> _eventController = 
    StreamController.broadcast();
  Stream<TelemedicineSessionEvent> get events => _eventController.stream;

  /// 화상진료 세션 시작
  Future<bool> startSession({
    required String appointmentId,
    required String patientId,
    required String doctorId,
  }) async {
    if (_state != TelemedicineSessionState.idle) {
      print('[TelemedicineSession] 이미 세션이 진행 중입니다');
      return false;
    }

    try {
      _state = TelemedicineSessionState.connecting;
      _appointmentId = appointmentId;
      _patientId = patientId;
      _doctorId = doctorId;

      // 1. Agora 초기화
      await _agoraService.initialize();

      // 2. 토큰 생성
      final channelName = 'telemedicine_$appointmentId';
      final token = await AgoraTokenService.generateToken(
        channelName: channelName,
        uid: patientId.hashCode,
        expirationSeconds: 3600, // 1시간
      );

      if (token == null) {
        throw Exception('토큰 생성 실패');
      }

      // 3. 채널 참가
      final joined = await _agoraService.joinChannel(
        channelName: channelName,
        token: token,
        uid: patientId.hashCode,
      );

      if (!joined) {
        throw Exception('채널 참가 실패');
      }

      _sessionStartTime = DateTime.now();
      _state = TelemedicineSessionState.connected;
      
      _emitEvent(TelemedicineSessionEventType.sessionStarted, {
        'appointmentId': appointmentId,
        'channelName': channelName,
      });

      print('[TelemedicineSession] 세션 시작됨');
      return true;
    } catch (e) {
      _state = TelemedicineSessionState.error;
      _emitEvent(TelemedicineSessionEventType.error, {
        'message': '세션 시작 실패: $e',
      });
      print('[TelemedicineSession] 세션 시작 실패: $e');
      return false;
    }
  }

  /// 화상진료 세션 종료
  Future<void> endSession({
    String? endReason,
    Map<String, dynamic>? sessionNotes,
  }) async {
    if (_state == TelemedicineSessionState.idle) return;

    try {
      // 통화 종료
      await _agoraService.leaveChannel();

      // 세션 요약 생성
      final duration = _sessionStartTime != null
          ? DateTime.now().difference(_sessionStartTime!)
          : Duration.zero;

      _emitEvent(TelemedicineSessionEventType.sessionEnded, {
        'appointmentId': _appointmentId,
        'duration': duration.inSeconds,
        'endReason': endReason ?? 'normal',
        'sessionNotes': sessionNotes,
      });

      // 상태 초기화
      _state = TelemedicineSessionState.idle;
      _appointmentId = null;
      _patientId = null;
      _doctorId = null;
      _sessionStartTime = null;

      print('[TelemedicineSession] 세션 종료됨');
    } catch (e) {
      print('[TelemedicineSession] 세션 종료 실패: $e');
    }
  }

  /// 측정 데이터 공유
  Future<void> shareMeasurementData(Map<String, dynamic> measurementData) async {
    if (_state != TelemedicineSessionState.connected) {
      print('[TelemedicineSession] 연결되지 않은 상태에서는 데이터를 공유할 수 없습니다');
      return;
    }

    // 실제 구현: RTM 또는 커스텀 시그널링을 통해 데이터 전송
    _emitEvent(TelemedicineSessionEventType.dataSent, {
      'type': 'measurement',
      'data': measurementData,
    });

    print('[TelemedicineSession] 측정 데이터 공유됨');
  }

  void _emitEvent(TelemedicineSessionEventType type, Map<String, dynamic> data) {
    _eventController.add(TelemedicineSessionEvent(type: type, data: data));
  }

  Future<void> dispose() async {
    await endSession(endReason: 'disposed');
    await _eventController.close();
    await _agoraService.dispose();
  }

  // Getters
  Duration? get sessionDuration => _sessionStartTime != null
      ? DateTime.now().difference(_sessionStartTime!)
      : null;
}

enum TelemedicineSessionState {
  idle,
  connecting,
  connected,
  reconnecting,
  error,
}

enum TelemedicineSessionEventType {
  sessionStarted,
  sessionEnded,
  doctorJoined,
  doctorLeft,
  dataSent,
  dataReceived,
  error,
}

class TelemedicineSessionEvent {
  final TelemedicineSessionEventType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  TelemedicineSessionEvent({
    required this.type,
    required this.data,
  }) : timestamp = DateTime.now();
}
