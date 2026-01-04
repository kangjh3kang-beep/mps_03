class MeasurementData {
  final String id;
  final String userId;
  final String type;
  final double value;
  final String unit;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  MeasurementData({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.metadata = const {},
  });

  factory MeasurementData.fromJson(Map<String, dynamic> json) {
    return MeasurementData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type,
        'value': value,
        'unit': unit,
        'timestamp': timestamp.toIso8601String(),
        'metadata': metadata,
      };
}
