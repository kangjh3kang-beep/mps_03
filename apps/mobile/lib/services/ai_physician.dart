import 'package:injectable/injectable.dart';

class CoachingResponse {
  final String message;
  final List<String> citations;
  final double empathyScore;

  CoachingResponse({
    required this.message,
    required this.citations,
    required this.empathyScore,
  });
}

@singleton
class AIPrimaryCarePhysician {
  // 다정다감한 전문 주치의 페르소나 기반 코칭
  Future<CoachingResponse> getCoaching(String userQuery, Map<String, dynamic> healthData) async {
    // 실제 구현 시에는 Vertex AI 등 LLM에 페르소나 프롬프트를 주입하여 호출
    
    // 시뮬레이션된 고도화 응답
    if (userQuery.contains('혈당') || healthData['type'] == 'Glucose') {
      return CoachingResponse(
        message: "사용자님, 오늘 혈당 수치가 115mg/dL로 측정되었네요. 평소보다 조금 높지만, "
                 "어제 저녁 식사가 조금 늦으셨던 게 영향을 준 것 같아요. 너무 걱정 마세요! "
                 "최근 'Nature Medicine(2025)'에 발표된 논문에 따르면, 일시적인 혈당 상승은 "
                 "가벼운 산책만으로도 20% 이상 빠르게 안정화될 수 있다고 합니다. "
                 "지금 저와 함께 15분만 가볍게 걸어보시는 건 어떨까요? 제가 옆에서 응원할게요!",
        citations: [
          "Nature Medicine (2025): Postprandial Glucose Regulation via Light Physical Activity",
          "Journal of Clinical Endocrinology: Impact of Late-night Meals on Fasting Glucose"
        ],
        empathyScore: 0.98,
      );
    }

    return CoachingResponse(
      message: "안녕하세요, 사용자님! 오늘도 건강 관리를 위해 노력하시는 모습이 정말 보기 좋습니다. "
               "측정하신 데이터는 제가 꼼꼼히 분석해서 최적의 가이드를 드릴게요. "
               "궁금한 점이 있으시면 언제든 편하게 말씀해 주세요. 다정하게 설명해 드릴게요!",
      citations: ["MPS Health Guidelines v2.1"],
      empathyScore: 0.95,
    );
  }
  
  int calculateRewardPoints(bool goalAchieved) {
    return goalAchieved ? 100 : 20;
  }
}
