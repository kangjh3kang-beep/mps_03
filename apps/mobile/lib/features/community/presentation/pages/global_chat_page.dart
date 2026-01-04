import 'package:flutter/material.dart';
import 'dart:async';

/// 글로벌 채팅 페이지
/// 기획안: /more/video-services/global-chat
class GlobalChatPage extends StatefulWidget {
  const GlobalChatPage({Key? key}) : super(key: key);

  @override
  State<GlobalChatPage> createState() => _GlobalChatPageState();
}

class _GlobalChatPageState extends State<GlobalChatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글로벌 채팅'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageSelector(),
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () => _showOnlineUsers(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '전체'),
            Tab(text: '혈당'),
            Tab(text: '건강'),
            Tab(text: '질문'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 활성 사용자 배너
          _buildActiveUsersBanner(),

          // 채팅 영역
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChatRoom('general'),
                _buildChatRoom('glucose'),
                _buildChatRoom('wellness'),
                _buildChatRoom('questions'),
              ],
            ),
          ),

          // 입력창
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildActiveUsersBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blue[50],
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text('1,247명 온라인', style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          // 활성 사용자 아바타
          SizedBox(
            width: 100,
            height: 30,
            child: Stack(
              children: List.generate(4, (index) {
                return Positioned(
                  left: index * 20.0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: [
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                    ][index],
                    child: Text(
                      ['US', 'JP', 'KR', '+'][index],
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatRoom(String roomId) {
    final messages = _getMessagesForRoom(roomId);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        return _ChatMessage(message: message);
      },
    );
  }

  List<GlobalChatMessage> _getMessagesForRoom(String roomId) {
    // 시뮬레이션 데이터
    return [
      GlobalChatMessage(
        id: '1',
        userId: 'user1',
        userName: 'HealthyJohn',
        userCountry: 'US',
        content: 'Just checked my blood sugar - 95 mg/dL! 🎉',
        originalLanguage: 'en',
        translatedContent: '방금 혈당 체크했어요 - 95 mg/dL! 🎉',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isTranslated: true,
      ),
      GlobalChatMessage(
        id: '2',
        userId: 'user2',
        userName: '田中健太',
        userCountry: 'JP',
        content: '素晴らしいですね！私も今日は安定しています。',
        originalLanguage: 'ja',
        translatedContent: '대단해요! 저도 오늘 안정적이에요.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        isTranslated: true,
      ),
      GlobalChatMessage(
        id: '3',
        userId: 'me',
        userName: '나',
        userCountry: 'KR',
        content: '오늘 아침 먹고 2시간 후에 측정했는데 110이었어요',
        originalLanguage: 'ko',
        translatedContent: null,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        isTranslated: false,
        isMe: true,
      ),
      GlobalChatMessage(
        id: '4',
        userId: 'user3',
        userName: 'MariaHealth',
        userCountry: 'ES',
        content: '¡Eso es genial! ¿Qué desayunaste?',
        originalLanguage: 'es',
        translatedContent: '좋아요! 아침에 뭘 드셨어요?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isTranslated: true,
      ),
      GlobalChatMessage(
        id: '5',
        userId: 'user4',
        userName: 'NutritionExpert',
        userCountry: 'DE',
        content: 'Remember to consider the glycemic index of your breakfast foods!',
        originalLanguage: 'en',
        translatedContent: '아침 식사 음식의 혈당 지수를 고려하세요!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isTranslated: true,
        isExpert: true,
      ),
    ];
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 이모지
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined),
              onPressed: () {},
            ),
            // 측정 결과 공유
            IconButton(
              icon: const Icon(Icons.monitor_heart),
              onPressed: () => _showShareMeasurementDialog(),
            ),
            // 입력창
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '메시지를 입력하세요...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 번역 토글
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.translate, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 8),
            // 전송
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('메시지가 전송되었습니다 (자동 번역됨)'),
        duration: Duration(seconds: 1),
      ),
    );
    _messageController.clear();
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '번역 언어 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('받는 메시지를 이 언어로 번역합니다:'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _LanguageChip(flag: '🇰🇷', name: '한국어', isSelected: true),
                _LanguageChip(flag: '🇺🇸', name: 'English'),
                _LanguageChip(flag: '🇯🇵', name: '日本語'),
                _LanguageChip(flag: '🇨🇳', name: '中文'),
                _LanguageChip(flag: '🇪🇸', name: 'Español'),
                _LanguageChip(flag: '🇫🇷', name: 'Français'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOnlineUsers() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                '온라인 사용자',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: [
                        Colors.blue,
                        Colors.green,
                        Colors.orange,
                        Colors.purple,
                        Colors.red,
                      ][index % 5],
                      child: Text(
                        ['US', 'JP', 'KR', 'DE', 'FR'][index % 5],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    title: Text('User ${index + 1}'),
                    subtitle: Text(['미국', '일본', '한국', '독일', '프랑스'][index % 5]),
                    trailing: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareMeasurementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('측정 결과 공유'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bloodtype, color: Colors.red),
              title: const Text('혈당'),
              subtitle: const Text('108 mg/dL - 2시간 전'),
              onTap: () {
                Navigator.pop(context);
                _messageController.text = '방금 측정한 혈당: 108 mg/dL 🩸';
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.pink),
              title: const Text('혈압'),
              subtitle: const Text('128/82 mmHg - 어제'),
              onTap: () {
                Navigator.pop(context);
                _messageController.text = '혈압 측정: 128/82 mmHg ❤️';
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============ 모델 ============
class GlobalChatMessage {
  final String id;
  final String userId;
  final String userName;
  final String userCountry;
  final String content;
  final String originalLanguage;
  final String? translatedContent;
  final DateTime timestamp;
  final bool isTranslated;
  final bool isMe;
  final bool isExpert;

  GlobalChatMessage({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userCountry,
    required this.content,
    required this.originalLanguage,
    this.translatedContent,
    required this.timestamp,
    required this.isTranslated,
    this.isMe = false,
    this.isExpert = false,
  });
}

// ============ 위젯 ============
class _ChatMessage extends StatefulWidget {
  final GlobalChatMessage message;

  const _ChatMessage({required this.message});

  @override
  State<_ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<_ChatMessage> {
  bool _showOriginal = false;

  @override
  Widget build(BuildContext context) {
    final message = widget.message;

    if (message.isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: const TextStyle(color: Colors.white60, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아바타
          CircleAvatar(
            radius: 18,
            backgroundColor: _getCountryColor(message.userCountry),
            child: Text(
              message.userCountry,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(width: 8),
          // 메시지
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    if (message.isExpert) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '전문가',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _showOriginal
                            ? message.content
                            : (message.translatedContent ?? message.content),
                      ),
                      if (message.isTranslated) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => setState(() => _showOriginal = !_showOriginal),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.translate, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                _showOriginal ? '번역 보기' : '원문 보기',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Color _getCountryColor(String country) {
    switch (country) {
      case 'US':
        return Colors.blue;
      case 'JP':
        return Colors.red;
      case 'KR':
        return Colors.indigo;
      case 'ES':
        return Colors.orange;
      case 'DE':
        return Colors.black;
      case 'FR':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _LanguageChip extends StatelessWidget {
  final String flag;
  final String name;
  final bool isSelected;

  const _LanguageChip({
    required this.flag,
    required this.name,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: isSelected,
      onSelected: (_) {},
      avatar: Text(flag),
      label: Text(name),
    );
  }
}
