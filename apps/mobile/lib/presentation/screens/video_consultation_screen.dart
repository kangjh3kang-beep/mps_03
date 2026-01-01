import 'package:flutter/material.dart';
import '../../services/translation_service.dart';

class VideoConsultationScreen extends StatefulWidget {
  const VideoConsultationScreen({super.key});

  @override
  State<VideoConsultationScreen> createState() => _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen> {
  final List<Map<String, String>> _chatMessages = [
    {'sender': 'Doctor', 'text': 'Hello, how are you feeling today?', 'translated': '안녕하세요, 오늘 기분이 어떠신가요?'},
  ];
  String _targetLanguage = 'ko';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('글로벌 화상 상담 (Live)'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          // 메인 화상 (의사)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=800'),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                ),
              ),
            ),
          ),
          // 내 화면 (작게)
          Positioned(
            top: 20,
            right: 20,
            width: 120,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.slate[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyan, width: 2),
              ),
              child: const Icon(Icons.person, color: Colors.white54),
            ),
          ),
          // 실시간 번역 자막 및 채팅
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildTranslationOverlay(),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationOverlay() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
        ),
      ),
      child: Column(
        children: [
          _buildLanguageBadge(),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) => _buildMessageBubble(_chatMessages[index]),
            ),
          ),
          _buildControlBar(),
        ],
      ),
    );
  }

  Widget _buildLanguageBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.cyan.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.translate, size: 14, color: Colors.cyan),
          const SizedBox(width: 6),
          Text('실시간 번역 중: $_targetLanguage', style: const TextStyle(color: Colors.cyan, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(msg['text']!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 2),
          Text(
            msg['translated']!,
            style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _circleButton(Icons.mic, Colors.slate[800]!),
        _circleButton(Icons.videocam, Colors.slate[800]!),
        _circleButton(Icons.call_end, Colors.red),
        _circleButton(Icons.chat, Colors.slate[800]!),
      ],
    );
  }

  Widget _circleButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}
