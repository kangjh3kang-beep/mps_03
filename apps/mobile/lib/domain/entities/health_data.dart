import 'package:equatable/equatable.dart';

/// 건강 점수 엔티티
class HealthScore extends Equatable {
  final int score;
  final String level;
  final String description;
  final DateTime calculatedAt;
  final List<HealthCategory> categories;
  final int changeFromLastWeek;

  const HealthScore({
    required this.score,
    required this.level,
    required this.description,
    required this.calculatedAt,
    this.categories = const [],
    this.changeFromLastWeek = 0,
  });

  @override
  List<Object?> get props => [score, level, description, calculatedAt, categories, changeFromLastWeek];

  factory HealthScore.empty() => HealthScore(
    score: 0,
    level: 'N/A',
    description: '데이터 없음',
    calculatedAt: DateTime.now(),
  );
}

/// 건강 카테고리
class HealthCategory extends Equatable {
  final String name;
  final int score;
  final String status;
  final String icon;

  const HealthCategory({
    required this.name,
    required this.score,
    required this.status,
    this.icon = 'favorite',
  });

  @override
  List<Object?> get props => [name, score, status, icon];
}

/// 환경 데이터
class EnvironmentData extends Equatable {
  final double? radonLevel;
  final double? airQualityIndex;
  final double? temperature;
  final double? humidity;
  final String status;
  final DateTime measuredAt;

  const EnvironmentData({
    this.radonLevel,
    this.airQualityIndex,
    this.temperature,
    this.humidity,
    required this.status,
    required this.measuredAt,
  });

  @override
  List<Object?> get props => [radonLevel, airQualityIndex, temperature, humidity, status, measuredAt];

  factory EnvironmentData.empty() => EnvironmentData(
    status: 'N/A',
    measuredAt: DateTime.now(),
  );
}

/// 추세 데이터
class TrendData extends Equatable {
  final String type;
  final List<TrendPoint> points;
  final String trend;
  final double average;
  final double min;
  final double max;

  const TrendData({
    required this.type,
    required this.points,
    required this.trend,
    required this.average,
    required this.min,
    required this.max,
  });

  @override
  List<Object?> get props => [type, points, trend, average, min, max];
}

/// 추세 포인트
class TrendPoint extends Equatable {
  final DateTime date;
  final double value;

  const TrendPoint({
    required this.date,
    required this.value,
  });

  @override
  List<Object?> get props => [date, value];
}

/// AI 인사이트
class AIInsight extends Equatable {
  final String id;
  final String title;
  final String message;
  final InsightType type;
  final InsightPriority priority;
  final DateTime createdAt;
  final String? actionUrl;

  const AIInsight({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.createdAt,
    this.actionUrl,
  });

  @override
  List<Object?> get props => [id, title, message, type, priority, createdAt, actionUrl];
}

/// 인사이트 타입
enum InsightType {
  recommendation,
  warning,
  achievement,
  reminder,
  tip,
}

/// 인사이트 우선순위
enum InsightPriority {
  low,
  medium,
  high,
  urgent,
}

/// 대시보드 데이터
class DashboardData extends Equatable {
  final HealthScore healthScore;
  final EnvironmentData environment;
  final List<TrendData> trends;
  final List<AIInsight> insights;

  const DashboardData({
    required this.healthScore,
    required this.environment,
    this.trends = const [],
    this.insights = const [],
  });

  @override
  List<Object?> get props => [healthScore, environment, trends, insights];

  factory DashboardData.empty() => DashboardData(
    healthScore: HealthScore.empty(),
    environment: EnvironmentData.empty(),
  );
}
