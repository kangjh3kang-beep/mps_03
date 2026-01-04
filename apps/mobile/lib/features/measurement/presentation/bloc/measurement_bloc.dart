import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============ 이벤트 ============
abstract class MeasurementEvent extends Equatable {
  const MeasurementEvent();
  @override
  List<Object?> get props => [];
}

class StartMeasurementProcess extends MeasurementEvent {
  final String measurementType;
  const StartMeasurementProcess(this.measurementType);
  @override
  List<Object?> get props => [measurementType];
}

class CartridgeDetected extends MeasurementEvent {
  const CartridgeDetected();
}

class CalibrationLoaded extends MeasurementEvent {
  const CalibrationLoaded();
}

class SamplePreparationCompleted extends MeasurementEvent {
  const SamplePreparationCompleted();
}

class StartMeasuring extends MeasurementEvent {
  const StartMeasuring();
}

class MeasurementProgressUpdated extends MeasurementEvent {
  final double progress;
  final String phase;
  const MeasurementProgressUpdated({required this.progress, required this.phase});
  @override
  List<Object?> get props => [progress, phase];
}

class MeasurementCompleted extends MeasurementEvent {
  final Map<String, dynamic> result;
  const MeasurementCompleted(this.result);
  @override
  List<Object?> get props => [result];
}

class CancelMeasurement extends MeasurementEvent {
  const CancelMeasurement();
}

class RetryMeasurement extends MeasurementEvent {
  const RetryMeasurement();
}

class ProceedToNextStep extends MeasurementEvent {
  const ProceedToNextStep();
}

// ============ 상태 ============
abstract class MeasurementState extends Equatable {
  const MeasurementState();
  @override
  List<Object?> get props => [];
}

class MeasurementInitial extends MeasurementState {}

// 측정 프로세스 상태 (5단계용)
abstract class MeasurementProcessState extends MeasurementState {
  final String measurementType;
  const MeasurementProcessState({required this.measurementType});
  @override
  List<Object?> get props => [measurementType];
}

class CartridgeInsertionStep extends MeasurementProcessState {
  final bool cartridgeDetected;
  final bool calibrationLoaded;

  const CartridgeInsertionStep({
    required super.measurementType,
    this.cartridgeDetected = false,
    this.calibrationLoaded = false,
  });

  @override
  List<Object?> get props => [measurementType, cartridgeDetected, calibrationLoaded];

  CartridgeInsertionStep copyWith({
    bool? cartridgeDetected,
    bool? calibrationLoaded,
  }) {
    return CartridgeInsertionStep(
      measurementType: measurementType,
      cartridgeDetected: cartridgeDetected ?? this.cartridgeDetected,
      calibrationLoaded: calibrationLoaded ?? this.calibrationLoaded,
    );
  }
}

class SamplePreparationStep extends MeasurementProcessState {
  final List<String> instructions;
  final Set<int> completedSteps;

  const SamplePreparationStep({
    required super.measurementType,
    required this.instructions,
    this.completedSteps = const {},
  });

  @override
  List<Object?> get props => [measurementType, instructions, completedSteps];
}

class MeasuringStep extends MeasurementProcessState {
  final double progress;
  final String currentPhase;
  final List<double> waveformData;
  final Duration estimatedTimeRemaining;

  const MeasuringStep({
    required super.measurementType,
    this.progress = 0,
    this.currentPhase = '초기화',
    this.waveformData = const [],
    this.estimatedTimeRemaining = const Duration(minutes: 2),
  });

  @override
  List<Object?> get props => [measurementType, progress, currentPhase, waveformData, estimatedTimeRemaining];
}

class ResultStep extends MeasurementProcessState {
  final Map<String, dynamic> result;

  const ResultStep({
    required super.measurementType,
    required this.result,
  });

  @override
  List<Object?> get props => [measurementType, result];
}

class FollowUpStep extends MeasurementProcessState {
  final Map<String, dynamic> result;
  final List<Map<String, dynamic>> recommendations;

  const FollowUpStep({
    required super.measurementType,
    required this.result,
    this.recommendations = const [],
  });

  @override
  List<Object?> get props => [measurementType, result, recommendations];
}

class MeasurementCancelled extends MeasurementState {}

class MeasurementError extends MeasurementState {
  final String message;
  const MeasurementError(this.message);
  @override
  List<Object?> get props => [message];
}

// ============ BLoC ============
class MeasurementBloc extends Bloc<MeasurementEvent, MeasurementState> {
  String _currentMeasurementType = 'glucose';

  MeasurementBloc() : super(MeasurementInitial()) {
    on<StartMeasurementProcess>(_onStartMeasurementProcess);
    on<CartridgeDetected>(_onCartridgeDetected);
    on<CalibrationLoaded>(_onCalibrationLoaded);
    on<SamplePreparationCompleted>(_onSamplePreparationCompleted);
    on<StartMeasuring>(_onStartMeasuring);
    on<MeasurementProgressUpdated>(_onMeasurementProgressUpdated);
    on<MeasurementCompleted>(_onMeasurementCompleted);
    on<CancelMeasurement>(_onCancelMeasurement);
    on<RetryMeasurement>(_onRetryMeasurement);
    on<ProceedToNextStep>(_onProceedToNextStep);
  }

  void _onStartMeasurementProcess(
    StartMeasurementProcess event,
    Emitter<MeasurementState> emit,
  ) {
    _currentMeasurementType = event.measurementType;
    emit(CartridgeInsertionStep(
      measurementType: event.measurementType,
    ));
  }

  void _onCartridgeDetected(
    CartridgeDetected event,
    Emitter<MeasurementState> emit,
  ) {
    final currentState = state;
    if (currentState is CartridgeInsertionStep) {
      emit(currentState.copyWith(cartridgeDetected: true));
    }
  }

  void _onCalibrationLoaded(
    CalibrationLoaded event,
    Emitter<MeasurementState> emit,
  ) {
    final currentState = state;
    if (currentState is CartridgeInsertionStep) {
      final updated = currentState.copyWith(calibrationLoaded: true);
      emit(updated);
      
      // 자동으로 다음 단계로 이동
      if (updated.cartridgeDetected && updated.calibrationLoaded) {
        Future.delayed(const Duration(milliseconds: 500), () {
          add(const SamplePreparationCompleted());
        });
      }
    }
  }

  void _onSamplePreparationCompleted(
    SamplePreparationCompleted event,
    Emitter<MeasurementState> emit,
  ) {
    emit(SamplePreparationStep(
      measurementType: _currentMeasurementType,
      instructions: _getInstructionsForType(_currentMeasurementType),
    ));
  }

  void _onStartMeasuring(
    StartMeasuring event,
    Emitter<MeasurementState> emit,
  ) async {
    emit(MeasuringStep(
      measurementType: _currentMeasurementType,
      progress: 0,
      currentPhase: '초기화',
    ));

    // 측정 시뮬레이션
    final phases = ['초기화', '기저선', '전압인가', '신호측정', '분석'];
    for (int i = 0; i < phases.length; i++) {
      for (int j = 0; j < 20; j++) {
        await Future.delayed(const Duration(milliseconds: 100));
        final progress = (i * 20 + j + 1).toDouble();
        add(MeasurementProgressUpdated(
          progress: progress,
          phase: phases[i],
        ));
      }
    }

    // 측정 완료
    add(MeasurementCompleted({
      'value': 108,
      'unit': 'mg/dL',
      'status': 'normal',
      'uncertainty': '±5',
      'aiInterpretation': '정상 범위입니다. 현재 혈당 수치가 안정적입니다.',
      'confidence': 95,
    }));
  }

  void _onMeasurementProgressUpdated(
    MeasurementProgressUpdated event,
    Emitter<MeasurementState> emit,
  ) {
    emit(MeasuringStep(
      measurementType: _currentMeasurementType,
      progress: event.progress,
      currentPhase: event.phase,
      estimatedTimeRemaining: Duration(
        seconds: ((100 - event.progress) * 1.2).round(),
      ),
    ));
  }

  void _onMeasurementCompleted(
    MeasurementCompleted event,
    Emitter<MeasurementState> emit,
  ) {
    emit(ResultStep(
      measurementType: _currentMeasurementType,
      result: event.result,
    ));
  }

  void _onCancelMeasurement(
    CancelMeasurement event,
    Emitter<MeasurementState> emit,
  ) {
    emit(MeasurementCancelled());
  }

  void _onRetryMeasurement(
    RetryMeasurement event,
    Emitter<MeasurementState> emit,
  ) {
    emit(CartridgeInsertionStep(measurementType: _currentMeasurementType));
  }

  void _onProceedToNextStep(
    ProceedToNextStep event,
    Emitter<MeasurementState> emit,
  ) {
    final currentState = state;
    if (currentState is ResultStep) {
      emit(FollowUpStep(
        measurementType: _currentMeasurementType,
        result: {
          ...currentState.result,
          'needsRemeasurement': false,
          'recommendations': [
            {'title': '다음 측정', 'description': '내일 아침 공복 상태에서 측정하세요.'},
            {'title': '식단', 'description': '저녁 식사에 섬유질을 충분히 섭취하세요.'},
          ],
        },
      ));
    }
  }

  List<String> _getInstructionsForType(String type) {
    switch (type.toLowerCase()) {
      case 'glucose':
        return [
          '손가락 끝을 따뜻한 물로 씻으세요',
          '소독용 알코올로 소독하고 말리세요',
          '랜싯으로 손가락 끝을 찔러 혈액을 채취하세요',
          '채취한 혈액을 카트리지에 바르세요',
        ];
      case 'radon':
        return [
          '측정 위치를 선택하세요 (침실, 거실 등)',
          '카트리지를 선택 위치에서 2m 이상 떨어진 곳에 놓으세요',
          '기울임 센서가 수평이 되도록 조정하세요',
        ];
      default:
        return [
          '준비 단계 1',
          '준비 단계 2',
          '준비 단계 3',
        ];
    }
  }
}

// MeasurementProcessBloc 별칭 (호환성)
typedef MeasurementProcessBloc = MeasurementBloc;
