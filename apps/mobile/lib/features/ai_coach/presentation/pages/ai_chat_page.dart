import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/ai_chat_bloc.dart';

/// AI 코치 채팅 페이지
/// 기획안: /ai-coach/chat
class AIChatPage extends StatefulWidget {
  const AIChatPage({Key? key}) : super(key: key);

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<AIChatBloc>().add(const LoadChatHistory());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<AIChatBloc>().add(SendMessage(text));
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AIChatBloc, AIChatState>(
              builder: (context, state) {
                if (state is AIChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AIChatLoaded) {
                  return _buildChatContent(state);
                }
                return _buildEmptyState();
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan[400]!, Colors.blue[600]!],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('만파', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('AI 건강 코치', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<AIChatBloc>().add(const ClearChatHistory());
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showOptionsSheet(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan[400]!, Colors.blue[600]!],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 24),
          const Text(
            '안녕하세요! 만파입니다 👋',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            '건강에 관한 질문이 있으시면 편하게 물어보세요.\n측정 결과 분석, 식단 조언, 운동 추천 등을 도와드립니다.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _buildQuickActionChips(),
        ],
      ),
    );
  }

  Widget _buildQuickActionChips() {
    final quickActions = [
      {'label': '오늘 건강 상태', 'icon': Icons.favorite, 'message': '오늘 내 건강 상태를 분석해줘'},
      {'label': '식단 추천', 'icon': Icons.restaurant, 'message': '오늘 식단을 추천해줘'},
      {'label': '운동 추천', 'icon': Icons.fitness_center, 'message': '오늘 할 운동을 추천해줘'},
      {'label': '수면 분석', 'icon': Icons.bedtime, 'message': '수면 패턴을 분석해줘'},
      {'label': '혈당 관리', 'icon': Icons.bloodtype, 'message': '혈당 관리 팁을 알려줘'},
      {'label': '스트레스 관리', 'icon': Icons.self_improvement, 'message': '스트레스 관리법을 알려줘'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: quickActions.map((action) {
        return ActionChip(
          avatar: Icon(action['icon'] as IconData, size: 18),
          label: Text(action['label'] as String),
          onPressed: () {
            context.read<AIChatBloc>().add(SendMessage(action['message'] as String));
          },
        );
      }).toList(),
    );
  }

  Widget _buildChatContent(AIChatLoaded state) {
    if (state.messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.messages.length + (state.isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.messages.length && state.isTyping) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(state.messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan[400]!, Colors.blue[600]!],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: _buildMessageContent(message, isUser),
          ),
          if (isUser) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message, bool isUser) {
    // 메시지 타입에 따른 렌더링
    switch (message.type) {
      case MessageType.text:
        return _buildTextBubble(message.content, isUser);
      case MessageType.measurementResult:
        return _buildMeasurementCard(message.data);
      case MessageType.coachingCard:
        return _buildCoachingCard(message.data);
      case MessageType.productRecommendation:
        return _buildProductCard(message.data);
      case MessageType.appointmentSuggestion:
        return _buildAppointmentCard(message.data);
      case MessageType.chart:
        return _buildChartCard(message.data);
      default:
        return _buildTextBubble(message.content, isUser);
    }
  }

  Widget _buildTextBubble(String content, bool isUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue : Colors.grey[100],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 16),
        ),
      ),
      child: Text(
        content,
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black87,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildMeasurementCard(Map<String, dynamic>? data) {
    if (data == null) return const SizedBox();

    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.monitor_heart, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                data['measurementType'] ?? '측정 결과',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${data['value'] ?? '--'}',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(data['status'] ?? 'normal'),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                data['unit'] ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(data['status'] ?? 'normal').withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              data['statusText'] ?? '정상',
              style: TextStyle(
                color: _getStatusColor(data['status'] ?? 'normal'),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/measurement/result/${data['id'] ?? '1'}'),
              child: const Text('상세 보기'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachingCard(Map<String, dynamic>? data) {
    if (data == null) return const SizedBox();

    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[50]!, Colors.amber[50]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.orange[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data['title'] ?? '코칭 추천',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data['description'] ?? '',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: (data['actions'] as List<dynamic>? ?? []).map((action) {
              return ActionChip(
                label: Text(action['label'] ?? ''),
                onPressed: () {
                  // Handle action
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic>? data) {
    if (data == null) return const SizedBox();

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Icon(Icons.shopping_bag, size: 48, color: Colors.grey[400]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['productName'] ?? '상품',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '₩${data['price'] ?? 0}',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/marketplace/product/${data['productId']}'),
                    child: const Text('상품 보기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic>? data) {
    if (data == null) return const SizedBox();

    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Icon(Icons.person, color: Colors.green[600]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['doctorName'] ?? '전문의',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['specialty'] ?? '전문 분야',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '가능한 시간',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: (data['availableSlots'] as List<dynamic>? ?? []).take(3).map((slot) {
              return Chip(
                label: Text(slot.toString(), style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.green[50],
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/telemedicine/book-appointment'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('예약하기'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(Map<String, dynamic>? data) {
    if (data == null) return const SizedBox();

    return Container(
      width: 280,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'] ?? '차트',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Expanded(
            child: Center(
              child: Text('차트 시각화 영역', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan[400]!, Colors.blue[600]!],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
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
            // 음성 입력 버튼
            IconButton(
              icon: const Icon(Icons.mic),
              color: Colors.grey[600],
              onPressed: () {
                context.read<AIChatBloc>().add(const VoiceInputStart());
              },
            ),
            // 텍스트 입력
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: '만파에게 물어보세요...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            // 전송 버튼
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan[400]!, Colors.blue[600]!],
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'good':
        return Colors.green;
      case 'warning':
      case 'elevated':
        return Colors.orange;
      case 'critical':
      case 'high':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _showOptionsSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('대화 히스토리'),
              onTap: () {
                Navigator.pop(context);
                context.go('/ai-coach/learning-history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('AI 설정'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('도움말'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
