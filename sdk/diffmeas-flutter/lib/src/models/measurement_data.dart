/// 측정 데이터 모델
abstract class MeasurementData {
  String get id;
  DateTime get timestamp;
  String get type;
  String get unit;
  bool get isValid;
  
  Map<String, dynamic> toJson();
}

/// 혈당 측정
class GlucoseMeasurement implements MeasurementData {
  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  String get type => 'glucose';
  @override
  final String unit;
  @override
  final bool isValid;
  
  final double value;
  final MealStatus mealStatus;
  final String? note;
  
  GlucoseMeasurement({
    required this.id,
    required this.timestamp,
    required this.value,
    required this.unit,
    required this.mealStatus,
    required this.isValid,
    this.note,
  });
  
  /// 정상 범위 여부
  bool get isInNormalRange {
    if (mealStatus == MealStatus.fasting) {
      return value >= 70 && value <= 100;
    } else {
      return value >= 70 && value <= 140;
    }
  }
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'value': value,
    'unit': unit,
    'mealStatus': mealStatus.name,
    'isValid': isValid,
    'note': note,
  };
}

/// 혈압 측정
class BloodPressureMeasurement implements MeasurementData {
  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  String get type => 'bloodPressure';
  @override
  final String unit;
  @override
  final bool isValid;
  
  final int systolic;
  final int diastolic;
  final int pulse;
  final String? note;
  
  BloodPressureMeasurement({
    required this.id,
    required this.timestamp,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.unit,
    required this.isValid,
    this.note,
  });
  
  /// 평균 동맥압
  double get meanArterialPressure => (systolic + 2 * diastolic) / 3;
  
  /// 혈압 분류
  BloodPressureCategory get category {
    if (systolic < 120 && diastolic < 80) return BloodPressureCategory.normal;
    if (systolic < 130 && diastolic < 80) return BloodPressureCategory.elevated;
    if (systolic < 140 || diastolic < 90) return BloodPressureCategory.hypertension1;
    if (systolic < 180 || diastolic < 120) return BloodPressureCategory.hypertension2;
    return BloodPressureCategory.crisis;
  }
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'systolic': systolic,
    'diastolic': diastolic,
    'pulse': pulse,
    'unit': unit,
    'isValid': isValid,
    'note': note,
  };
}

/// 심박수 측정
class HeartRateMeasurement implements MeasurementData {
  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  String get type => 'heartRate';
  @override
  final String unit;
  @override
  final bool isValid;
  
  final int value;
  final HeartRhythm rhythm;
  final int? hrv; // Heart Rate Variability
  final String? note;
  
  HeartRateMeasurement({
    required this.id,
    required this.timestamp,
    required this.value,
    required this.unit,
    required this.rhythm,
    required this.isValid,
    this.hrv,
    this.note,
  });
  
  /// 심박수 구간
  HeartRateZone get zone {
    if (value < 60) return HeartRateZone.resting;
    if (value < 100) return HeartRateZone.normal;
    if (value < 120) return HeartRateZone.fatBurn;
    if (value < 150) return HeartRateZone.cardio;
    return HeartRateZone.peak;
  }
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'value': value,
    'unit': unit,
    'rhythm': rhythm.name,
    'hrv': hrv,
    'isValid': isValid,
    'note': note,
  };
}

/// 산소포화도 측정
class OxygenMeasurement implements MeasurementData {
  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  String get type => 'oxygenSaturation';
  @override
  final String unit;
  @override
  final bool isValid;
  
  final double value;
  final double? perfusionIndex;
  final String? note;
  
  OxygenMeasurement({
    required this.id,
    required this.timestamp,
    required this.value,
    required this.unit,
    required this.isValid,
    this.perfusionIndex,
    this.note,
  });
  
  /// 정상 범위 여부
  bool get isInNormalRange => value >= 95;
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'value': value,
    'unit': unit,
    'perfusionIndex': perfusionIndex,
    'isValid': isValid,
    'note': note,
  };
}

/// 체온 측정
class TemperatureMeasurement implements MeasurementData {
  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  String get type => 'temperature';
  @override
  final String unit;
  @override
  final bool isValid;
  
  final double value;
  final TemperatureSite site;
  final String? note;
  
  TemperatureMeasurement({
    required this.id,
    required this.timestamp,
    required this.value,
    required this.unit,
    required this.site,
    required this.isValid,
    this.note,
  });
  
  /// 발열 여부
  bool get hasFever => value >= 37.5;
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'value': value,
    'unit': unit,
    'site': site.name,
    'isValid': isValid,
    'note': note,
  };
}

// Enums
enum MealStatus { fasting, beforeMeal, afterMeal, bedtime }

enum BloodPressureCategory {
  normal,
  elevated,
  hypertension1,
  hypertension2,
  crisis,
}

enum HeartRhythm { normal, irregular, afib }

enum HeartRateZone { resting, normal, fatBurn, cardio, peak }

enum TemperatureSite { oral, forehead, ear, armpit }

