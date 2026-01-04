import 'package:flutter/material.dart';
import 'dart:async';

/// 화상통화 세션 페이지
/// 기획안: /more/video-services/telemedicine/video-call/:id
class VideoCallPage extends StatefulWidget {
  final String appointmentId;

  const VideoCallPage({Key? key, required this.appointmentId}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool _isMicOn = true;
  bool _isCameraOn = true;
  bool _isDataPanelOpen = false;
  bool _isChatOpen = false;
  int _callDuration = 0;
  Timer? _timer;

  final List<MeasurementSnapshot> _recentMeasurements = [
    MeasurementSnapshot(
      type: '혈당',
      value: '108',
      unit: 'mg/dL',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'normal',
    ),
    MeasurementSnapshot(
      type: '혈압',
      value: '128/82',
      unit: 'mmHg',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      status: 'elevated',
    ),
    MeasurementSnapshot(
      type: '심박수',
      value: '72',
      unit: 'bpm',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      status: 'normal',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _callDuration++);
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 원격 비디오 (의사)
          _buildRemoteVideo(),

          // 로컬 비디오 (환자 - 나)
          _buildLocalVideo(),

          // 상단 오버레이
          _buildTopOverlay(),

          // 하단 컨트롤
          _buildBottomControls(),

          // 측정 데이터 패널 (슬라이드)
          if (_isDataPanelOpen) _buildDataPanel(),

          // 채팅 패널 (슬라이드)
          if (_isChatOpen) _buildChatPanel(),
        ],
      ),
    );
  }

  Widget _buildRemoteVideo() {
    // 실제 구현에서는 Agora/WebRTC 비디오 뷰
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 64, color: Colors.blue[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              '김건강 전문의',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '연결됨',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalVideo() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      right: 16,
      child: GestureDetector(
        onPanUpdate: (details) {
          // 드래그 가능
        },
        child: Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: _isCameraOn
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.grey[700],
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white54, size: 48),
                    ),
                  ),
                )
              : const Center(
                  child: Icon(Icons.videocam_off, color: Colors.white54, size: 32),
                ),
        ),
      ),
    );
  }

  Widget _buildTopOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            // 통화 시간
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(_callDuration),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // 측정 데이터 공유 버튼
            IconButton(
              onPressed: () => setState(() => _isDataPanelOpen = !_isDataPanelOpen),
              icon: Icon(
                Icons.monitor_heart,
                color: _isDataPanelOpen ? Colors.blue : Colors.white,
              ),
            ),
            // 채팅 버튼
            IconButton(
              onPressed: () => setState(() => _isChatOpen = !_isChatOpen),
              icon: Icon(
                Icons.chat,
                color: _isChatOpen ? Colors.blue : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 마이크
            _ControlButton(
              icon: _isMicOn ? Icons.mic : Icons.mic_off,
              label: _isMicOn ? '음소거' : '음소거 해제',
              isActive: _isMicOn,
              onPressed: () => setState(() => _isMicOn = !_isMicOn),
            ),
            // 카메라
            _ControlButton(
              icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
              label: _isCameraOn ? '카메라 끄기' : '카메라 켜기',
              isActive: _isCameraOn,
              onPressed: () => setState(() => _isCameraOn = !_isCameraOn),
            ),
            // 화면 공유
            _ControlButton(
              icon: Icons.screen_share,
              label: '화면 공유',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('화면 공유가 시작되었습니다')),
                );
              },
            ),
            // 통화 종료
            _ControlButton(
              icon: Icons.call_end,
              label: '종료',
              backgroundColor: Colors.red,
              onPressed: () => _showEndCallDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataPanel() {
    return Positioned(
      left: 0,
      top: MediaQuery.of(context).padding.top + 60,
      bottom: 100,
      child: Container(
        width: 280,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monitor_heart, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '측정 데이터',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _isDataPanelOpen = false),
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // 데이터 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _recentMeasurements.length,
                itemBuilder: (context, index) {
                  final m = _recentMeasurements[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getStatusColor(m.status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.type,
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                              Text(
                                '${m.value} ${m.unit}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // 공유 버튼
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${m.type} 데이터를 의사에게 공유했습니다')),
                            );
                          },
                          icon: const Icon(Icons.share, size: 18),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // 전체 공유 버튼
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('모든 측정 데이터를 의사에게 공유했습니다')),
                    );
                  },
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('모든 데이터 공유'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatPanel() {
    return Positioned(
      right: 0,
      top: MediaQuery.of(context).padding.top + 60,
      bottom: 100,
      child: Container(
        width: 280,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('채팅', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _isChatOpen = false),
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // 채팅 메시지
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _ChatBubble(
                    message: '안녕하세요, 오늘 상담 시작하겠습니다.',
                    isMe: false,
                    time: '14:00',
                  ),
                  _ChatBubble(
                    message: '네, 감사합니다.',
                    isMe: true,
                    time: '14:01',
                  ),
                  _ChatBubble(
                    message: '최근 측정 데이터를 공유해주실 수 있나요?',
                    isMe: false,
                    time: '14:02',
                  ),
                ],
              ),
            ),
            // 입력창
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '메시지 입력...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'normal':
        return Colors.green;
      case 'elevated':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showEndCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('통화 종료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('통화 시간: ${_formatDuration(_callDuration)}'),
            const SizedBox(height: 16),
            const Text('통화를 종료하시겠습니까?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showRatingDialog();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('종료'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    int _rating = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('상담은 어떠셨나요?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setDialogState(() => _rating = index + 1),
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '추가 의견을 남겨주세요 (선택)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // 통화 화면 종료
              },
              child: const Text('건너뛰기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // 통화 화면 종료
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('피드백 감사합니다!')),
                );
              },
              child: const Text('제출'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ 모델 ============
class MeasurementSnapshot {
  final String type;
  final String value;
  final String unit;
  final DateTime timestamp;
  final String status;

  MeasurementSnapshot({
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.status,
  });
}

// ============ 위젯 ============
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.isActive = true,
    this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor ?? (isActive ? Colors.white.withOpacity(0.2) : Colors.grey[700]),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: backgroundColor != null ? Colors.white : (isActive ? Colors.white : Colors.grey),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const _ChatBubble({
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
