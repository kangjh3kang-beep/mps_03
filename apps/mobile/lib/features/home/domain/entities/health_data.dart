import 'package:equatable/equatable.dart';

class HealthScore extends Equatable {
  final int score;
  final String status; // 'Good', 'Average', 'Poor'
  final DateTime lastUpdated;

  const HealthScore({
    required this.score,
    required this.status,
    required this.lastUpdated,
  });

  factory HealthScore.fromJson(Map<String, dynamic> json) {
    return HealthScore(
      score: json['score'] ?? 0,
      status: json['status'] ?? 'Unknown',
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'score': score,
        'status': status,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  @override
  List<Object?> get props => [score, status, lastUpdated];
}

class EnvironmentData extends Equatable {
  final double value;
  final String unit;
  final String status;
  final String location;

  const EnvironmentData({
    required this.value,
    required this.unit,
    required this.status,
    required this.location,
  });

  factory EnvironmentData.fromJson(Map<String, dynamic> json) {
    return EnvironmentData(
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      status: json['status'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'unit': unit,
        'status': status,
        'location': location,
      };

  @override
  List<Object?> get props => [value, unit, status, location];
}

class TrendData extends Equatable {
  final DateTime date;
  final double value;

  const TrendData({
    required this.date,
    required this.value,
  });

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      value: (json['value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'value': value,
      };

  @override
  List<Object?> get props => [date, value];
}

class AIInsight extends Equatable {
  final String title;
  final String description;
  final String recommendation;
  final String severity; // 'Low', 'Medium', 'High'

  const AIInsight({
    required this.title,
    required this.description,
    required this.recommendation,
    required this.severity,
  });

  factory AIInsight.fromJson(Map<String, dynamic> json) {
    return AIInsight(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      recommendation: json['recommendation'] ?? '',
      severity: json['severity'] ?? 'Low',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'recommendation': recommendation,
        'severity': severity,
      };

  @override
  List<Object?> get props => [title, description, recommendation, severity];
}
