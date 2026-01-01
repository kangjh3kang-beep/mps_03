import 'package:injectable/injectable.dart';

class RewardInfo {
  final int totalPoints;
  final List<String> badges;
  final int dailyStreak;

  RewardInfo({required this.totalPoints, required this.badges, required this.dailyStreak});
}

@singleton
class RewardService {
  int _points = 1250;
  final List<String> _badges = ['초보 측정가', '성실한 관리자'];
  int _streak = 5;

  Future<RewardInfo> getRewardInfo() async {
    return RewardInfo(totalPoints: _points, badges: _badges, dailyStreak: _streak);
  }

  Future<int> addPoints(int amount, String reason) async {
    _points += amount;
    // TODO: 포인트 획득 로그 기록
    return _points;
  }

  Future<void> checkAndAwardBadge(String criteria) async {
    if (criteria == '10_measurements' && !_badges.contains('정밀 분석가')) {
      _badges.add('정밀 분석가');
    }
  }
}
