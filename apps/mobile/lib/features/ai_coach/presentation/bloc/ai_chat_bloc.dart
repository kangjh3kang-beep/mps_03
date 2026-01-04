import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============ 이벤트 ============
abstract class AIChatEvent extends Equatable {
  const AIChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadChatHistory extends AIChatEvent {
  const LoadChatHistory();
}

class SendMessage extends AIChatEvent {
  final String message;
  const SendMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class ClearChatHistory extends AIChatEvent {
  const ClearChatHistory();
}

class VoiceInputStart extends AIChatEvent {
  const VoiceInputStart();
}

class VoiceInputStop extends AIChatEvent {
  const VoiceInputStop();
}

// ============ 상태 ============
abstract class AIChatState extends Equatable {
  const AIChatState();
  @override
  List<Object?> get props => [];
}

class AIChatInitial extends AIChatState {}

class AIChatLoading extends AIChatState {}

class AIChatLoaded extends AIChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  const AIChatLoaded({
    required this.messages,
    this.isTyping = false,
  });

  @override
  List<Object?> get props => [messages, isTyping];

  AIChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
  }) {
    return AIChatLoaded(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class AIChatError extends AIChatState {
  final String message;
  const AIChatError(this.message);
  @override
  List<Object?> get props => [message];
}

// ============ 메시지 타입 ============
enum MessageType {
  text,
  measurementResult,
  coachingCard,
  productRecommendation,
  appointmentSuggestion,
  chart,
}

class ChatMessage extends Equatable {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final Map<String, dynamic>? data;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.data,
  });

  @override
  List<Object?> get props => [id, content, isUser, timestamp, type, data];
}

// ============ BLoC ============
class AIChatBloc extends Bloc<AIChatEvent, AIChatState> {
  AIChatBloc() : super(AIChatInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<ClearChatHistory>(_onClearChatHistory);
    on<VoiceInputStart>(_onVoiceInputStart);
  }

  Future<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<AIChatState> emit,
  ) async {
    emit(AIChatLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    emit(const AIChatLoaded(messages: []));
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<AIChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AIChatLoaded) return;

    // 사용자 메시지 추가
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...currentState.messages, userMessage];
    emit(AIChatLoaded(messages: updatedMessages, isTyping: true));

    // AI 응답 시뮬레이션
    await Future.delayed(const Duration(seconds: 1));

    // 메시지 내용에 따라 다른 타입의 응답 생성
    final aiResponse = _generateAIResponse(event.message);

    emit(AIChatLoaded(
      messages: [...updatedMessages, aiResponse],
      isTyping: false,
    ));
  }

  ChatMessage _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // 건강 상태 관련
    if (lowerMessage.contains('건강') || lowerMessage.contains('상태')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '오늘 건강 상태를 분석해드릴게요.',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.measurementResult,
        data: {
          'measurementType': '혈당',
          'value': 95,
          'unit': 'mg/dL',
          'status': 'normal',
          'statusText': '정상 범위',
          'id': '1',
        },
      );
    }

    // 식단 관련
    if (lowerMessage.contains('식단') || lowerMessage.contains('음식')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.coachingCard,
        data: {
          'title': '오늘의 식단 추천',
          'description': '현재 혈당 수치를 고려하여 저GI 식품 위주의 식단을 추천드립니다. 통곡물, 채소, 단백질을 균형있게 섭취하세요.',
          'actions': [
            {'label': '아침 식단 보기'},
            {'label': '점심 식단 보기'},
          ],
        },
      );
    }

    // 운동 관련
    if (lowerMessage.contains('운동')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.coachingCard,
        data: {
          'title': '오늘의 운동 추천',
          'description': '식후 30분 후 가벼운 걷기를 추천드립니다. 혈당 조절에 효과적이에요!',
          'actions': [
            {'label': '운동 시작하기'},
            {'label': '다른 운동 보기'},
          ],
        },
      );
    }

    // 수면 관련
    if (lowerMessage.contains('수면') || lowerMessage.contains('잠')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '지난 7일간 수면 패턴을 분석한 결과입니다.\n\n평균 수면 시간: 6.5시간\n수면 품질: 양호\n\n💡 팁: 취침 1시간 전 스마트폰 사용을 줄이면 수면 품질이 향상됩니다.',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }

    // 혈당 관련
    if (lowerMessage.contains('혈당')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '혈당 관리를 위한 팁을 알려드릴게요:\n\n1️⃣ 식사 후 30분 내 가벼운 운동\n2️⃣ 정제 탄수화물 섭취 제한\n3️⃣ 충분한 수분 섭취\n4️⃣ 규칙적인 측정 습관\n\n추가 궁금한 점이 있으시면 말씀해주세요!',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }

    // 스트레스 관련
    if (lowerMessage.contains('스트레스')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.coachingCard,
        data: {
          'title': '스트레스 관리',
          'description': '호흡 명상을 통해 스트레스를 줄여보세요. 하루 5분만 투자해도 효과가 있어요.',
          'actions': [
            {'label': '명상 시작하기'},
            {'label': '스트레스 트래킹'},
          ],
        },
      );
    }

    // 상담/의사 관련
    if (lowerMessage.contains('상담') || lowerMessage.contains('의사')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '전문가 상담을 원하시는군요. 추천 전문의를 안내해드릴게요.',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.appointmentSuggestion,
        data: {
          'doctorId': '1',
          'doctorName': '김건강 전문의',
          'specialty': '내분비내과',
          'availableSlots': ['오늘 14:00', '내일 10:00', '내일 15:00'],
        },
      );
    }

    // 카트리지/구매 관련
    if (lowerMessage.contains('카트리지') || lowerMessage.contains('구매')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '카트리지 재고가 부족해 보이네요. 추천 상품을 안내해드릴게요.',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.productRecommendation,
        data: {
          'productId': '1',
          'productName': '혈당 측정 카트리지 (30개입)',
          'price': '24,000',
        },
      );
    }

    // 기본 응답
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '네, 말씀해주신 내용을 확인했어요. 더 자세한 분석이 필요하시면 "오늘 건강 상태"를 물어봐 주세요.\n\n다른 궁금한 점이 있으시면 편하게 물어보세요! 😊',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  Future<void> _onClearChatHistory(
    ClearChatHistory event,
    Emitter<AIChatState> emit,
  ) async {
    emit(const AIChatLoaded(messages: []));
  }

  Future<void> _onVoiceInputStart(
    VoiceInputStart event,
    Emitter<AIChatState> emit,
  ) async {
    // 음성 입력 시작 로직
    // 실제 구현에서는 speech_to_text 패키지 사용
  }
}
