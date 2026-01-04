import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/measurement_entities.dart';
import '../../domain/repositories/measurement_repository.dart';

// ============ Events ============
abstract class MeasurementProcessEvent extends Equatable {
  const MeasurementProcessEvent();

  @override
  List<Object?> get props => [];
}

class StartMeasurementProcess extends MeasurementProcessEvent {
  final String cartridgeType;
  final String readerDeviceId;

  const StartMeasurementProcess({
    required this.cartridgeType,
    required this.readerDeviceId,
  });

  @override
  List<Object?> get props => [cartridgeType, readerDeviceId];
}

class CartridgeDetected extends MeasurementProcessEvent {
  const CartridgeDetected();

  @override
  List<Object?> get props => [];
}

class CalibrationLoaded extends MeasurementProcessEvent {
  const CalibrationLoaded();
}

class ProceedToNextStep extends MeasurementProcessEvent {
  const ProceedToNextStep();
}

class SamplePreparationCompleted extends MeasurementProcessEvent {
  const SamplePreparationCompleted();
}

class StartMeasuring extends MeasurementProcessEvent {
  const StartMeasuring();
}

class WaveformDataReceived extends MeasurementProcessEvent {
  final List<WaveformPoint> points;

  const WaveformDataReceived({required this.points});

  @override
  List<Object?> get props => [points];
}

class PhaseUpdated extends MeasurementProcessEvent {
  final MeasurementPhase phase;

  const PhaseUpdated({required this.phase});

  @override
  List<Object?> get props => [phase];
}

class MeasurementCompleted extends MeasurementProcessEvent {
  const MeasurementCompleted();

  @override
  List<Object?> get props => [];
}

class RetryMeasurement extends MeasurementProcessEvent {
  const RetryMeasurement();
}

class CancelMeasurement extends MeasurementProcessEvent {
  const CancelMeasurement();
}

class FollowUpActionTriggered extends MeasurementProcessEvent {
  final String actionType; // remeasure, consult, coaching
  final String actionPayload;

  const FollowUpActionTriggered({
    required this.actionType,
    required this.actionPayload,
  });

  @override
  List<Object?> get props => [actionType, actionPayload];
}

// ============ States ============
abstract class MeasurementProcessState extends Equatable {
  const MeasurementProcessState();

  @override
  List<Object?> get props => [];
}

class MeasurementInitial extends MeasurementProcessState {
  const MeasurementInitial();
}

class MeasurementLoading extends MeasurementProcessState {
  const MeasurementLoading();
}

class CartridgeInsertionStep extends MeasurementProcessState {
  final MeasurementSession session;
  final bool cartridgeDetected;
  final bool calibrationLoaded;

  const CartridgeInsertionStep({
    required this.session,
    required this.cartridgeDetected,
    required this.calibrationLoaded,
  });

  @override
  List<Object?> get props => [session, cartridgeDetected, calibrationLoaded];
}

class SamplePreparationStep extends MeasurementProcessState {
  final MeasurementSession session;
  final List<String> instructions;
  final bool arGuideEnabled;

  const SamplePreparationStep({
    required this.session,
    required this.instructions,
    required this.arGuideEnabled,
  });

  @override
  List<Object?> get props => [session, instructions, arGuideEnabled];
}

class MeasuringStep extends MeasurementProcessState {
  final MeasurementSession session;
  final List<WaveformPoint> waveformData;
  final MeasurementPhase currentPhase;
  final double progress;
  final Duration estimatedTimeRemaining;

  const MeasuringStep({
    required this.session,
    required this.waveformData,
    required this.currentPhase,
    required this.progress,
    required this.estimatedTimeRemaining,
  });

  @override
  List<Object?> get props => [session, waveformData, currentPhase, progress, estimatedTimeRemaining];
}

class ResultStep extends MeasurementProcessState {
  final Map<String, dynamic> result;

  const ResultStep({required this.result});

  @override
  List<Object?> get props => [result];
}

class FollowUpStep extends MeasurementProcessState {
  final Map<String, dynamic> result;

  const FollowUpStep({required this.result});

  @override
  List<Object?> get props => [result];
}

class MeasurementError extends MeasurementProcessState {
  final String message;
  final String errorCode;
  final bool allowRetry;

  const MeasurementError({
    required this.message,
    required this.errorCode,
    required this.allowRetry,
  });

  @override
  List<Object?> get props => [message, errorCode, allowRetry];
}

// ============ BLoC ============
class MeasurementProcessBloc extends Bloc<MeasurementProcessEvent, MeasurementProcessState> {
  final MeasurementRepository _repository;

  MeasurementProcessBloc({required MeasurementRepository repository})
      : _repository = repository,
        super(const MeasurementInitial()) {
    on<StartMeasurementProcess>(_onStartMeasurementProcess);
    on<CartridgeDetected>(_onCartridgeDetected);
    on<CalibrationLoaded>(_onCalibrationLoaded);
    on<ProceedToNextStep>(_onProceedToNextStep);
    on<SamplePreparationCompleted>(_onSamplePreparationCompleted);
    on<StartMeasuring>(_onStartMeasuring);
    on<WaveformDataReceived>(_onWaveformDataReceived);
    on<PhaseUpdated>(_onPhaseUpdated);
    on<MeasurementCompleted>(_onMeasurementCompleted);
    on<RetryMeasurement>(_onRetryMeasurement);
    on<CancelMeasurement>(_onCancelMeasurement);
    on<FollowUpActionTriggered>(_onFollowUpActionTriggered);
  }



  Future<void> _onStartMeasurementProcess(
    StartMeasurementProcess event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    emit(MeasurementLoading());
    await Future.delayed(const Duration(milliseconds: 500));

    // Use repository to create session
    final session = await _repository.createSession(event.cartridgeType, event.readerDeviceId);

    emit(CartridgeInsertionStep(
      session: session,
      cartridgeDetected: false,
      calibrationLoaded: false,
    ));
  }

  Future<void> _onCartridgeDetected(
    CartridgeDetected event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    if (state is CartridgeInsertionStep) {
      final currentState = state as CartridgeInsertionStep;
      emit(CartridgeInsertionStep(
        session: currentState.session,
        cartridgeDetected: true,
        calibrationLoaded: currentState.calibrationLoaded,
      ));
    }
  }

  Future<void> _onCalibrationLoaded(
    CalibrationLoaded event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    if (state is CartridgeInsertionStep) {
      final currentState = state as CartridgeInsertionStep;
      emit(CartridgeInsertionStep(
        session: currentState.session,
        cartridgeDetected: currentState.cartridgeDetected,
        calibrationLoaded: true,
      ));

      // 2초 후 자동으로 다음 단계로
      await Future.delayed(const Duration(seconds: 2));
      if (currentState.cartridgeDetected && currentState.calibrationLoaded) {
        _proceedToSamplePreparation(currentState.session, emit);
      }
    }
  }

  Future<void> _onProceedToNextStep(
    ProceedToNextStep event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    if (state is SamplePreparationStep) {
      final currentState = state as SamplePreparationStep;
      emit(MeasuringStep(
        session: currentState.session,
        waveformData: [],
        currentPhase: MeasurementPhase(
          stepNumber: 3,
          phaseName: '초기화 중...',
          description: '기기 초기화 중',
          progress: 0.0,
          startTime: DateTime.now(),
        ),
        estimatedTimeRemaining: _getEstimatedDuration(currentState.session.cartridgeType),
      ));
    }
  }

  void _proceedToSamplePreparation(MeasurementSession session, Emitter<MeasurementProcessState> emit) {
    final instructions = _getInstructions(session.cartridgeType);
    emit(SamplePreparationStep(
      session: session,
      instructions: instructions,
      arGuideEnabled: false,
    ));
  }

  Future<void> _onSamplePreparationCompleted(
    SamplePreparationCompleted event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    if (state is SamplePreparationStep) {
      final currentState = state as SamplePreparationStep;
      emit(MeasuringStep(
        session: currentState.session,
        waveformData: [],
        currentPhase: MeasurementPhase(
          stepNumber: 3,
          phaseName: '초기화 중...',
          description: '기기 초기화 중',
          progress: 0.0,
          startTime: DateTime.now(),
        ),
        estimatedTimeRemaining: _getEstimatedDuration(currentState.session.cartridgeType),
      ));

      // 시뮬레이션: 실시간 파형 데이터
      _simulateMeasurement(currentState.session, emit);
    }
  }

  Future<void> _onStartMeasuring(
    StartMeasuring event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    // 측정 시작 이벤트 처리
  }

  void _simulateMeasurement(MeasurementSession session, Emitter<MeasurementProcessState> emit) {
    // Mock 파형 데이터 생성 및 스트리밍
    final duration = _getEstimatedDuration(session.cartridgeType);
    int phaseIndex = 0;
    final phases = ['초기화', '기저선', '전압인가', '신호측정', '분석'];
    int progressCounter = 0;

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 200));

      if (progressCounter < 50) {
        // 파형 데이터 시뮬레이션
        final waveformPoints = List.generate(
          10,
          (i) => WaveformPoint(
            timestamp: DateTime.now().millisecondsSinceEpoch + i * 50,
            value: 50 + (i * 5) + (DateTime.now().millisecond % 10).toDouble(),
          ),
        );

        if (state is MeasuringStep) {
          final currentState = state as MeasuringStep;
          final newWaveform = [...currentState.waveformData, ...waveformPoints];
          final progress = (progressCounter / 50) * 100;
          final phaseIdx = (progress / 20).toInt().clamp(0, 4);

          emit(MeasuringStep(
            session: session,
            waveformData: newWaveform.length > 100 ? newWaveform.sublist(newWaveform.length - 100) : newWaveform,
            currentPhase: phases[phaseIdx],
            progress: progress,
            estimatedTimeRemaining: Duration(seconds: ((100 - progress) / 100 * duration).toInt()),
          ));
        }

        progressCounter++;
        return true;
      }

      return false;
    }).then((_) {
      // 측정 완료
      if (state is MeasuringStep) {
        add(const MeasurementCompleted());
      }
    });
  }

  Future<void> _onWaveformDataReceived(
    WaveformDataReceived event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    if (state is MeasuringStep) {
      final currentState = state as MeasuringStep;
      emit(MeasuringStep(
        session: currentState.session,
        waveformData: [...currentState.waveformData, ...event.points],
        currentPhase: currentState.currentPhase,
        estimatedTimeRemaining: currentState.estimatedTimeRemaining,
      ));
    }
  }

  Future<void> _onPhaseUpdated(
    PhaseUpdated event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    if (state is MeasuringStep) {
      final currentState = state as MeasuringStep;
      emit(MeasuringStep(
        session: currentState.session,
        waveformData: currentState.waveformData,
        currentPhase: event.phase,
        estimatedTimeRemaining: currentState.estimatedTimeRemaining,
      ));
    }
  }

  Future<void> _onMeasurementCompleted(
    MeasurementCompleted event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    emit(ResultStep(
      result: {
        'value': 85.5,
        'unit': _getUnit('glucose'),
        'uncertainty': '±2.5',
        'status': 'normal',
        'aiInterpretation': '정상 범위입니다',
        'confidence': 95,
        'recommendations': [],
        'needsRemeasurement': false,
        'needsConsultation': false,
      },
    ));

    // 2초 후 Follow-up 페이지로
    await Future.delayed(const Duration(seconds: 2));
    emit(FollowUpStep(
      result: {
        'value': 85.5,
        'unit': _getUnit('glucose'),
        'uncertainty': '±2.5',
        'status': 'normal',
        'aiInterpretation': '정상 범위입니다',
        'confidence': 95,
        'recommendations': [
          {'title': '충분한 수분 섭취', 'description': '하루 2리터 이상 마시세요'},
          {'title': '규칙적인 운동', 'description': '매일 30분 운동을 권장합니다'},
        ],
        'needsRemeasurement': false,
        'needsConsultation': false,
      },
    ));
  }

  Future<void> _onRetryMeasurement(
    RetryMeasurement event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    emit(MeasurementLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    // 재측정을 위해 처음으로 돌아갈 수 없으므로, 새로운 세션 생성
    final session = await _repository.createSession('glucose', 'device_001');
    emit(CartridgeInsertionStep(
      session: session,
      cartridgeDetected: false,
      calibrationLoaded: false,
    ));
  }

  Future<void> _onCancelMeasurement(
    CancelMeasurement event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    emit(const MeasurementInitial());
  }

  Future<void> _onFollowUpActionTriggered(
    FollowUpActionTriggered event,
    Emitter<MeasurementProcessState> emit,
  ) async {
    // 후속 액션 처리
  }

  // Helper methods
  List<String> _getInstructions(String cartridgeType) {
    final instructionMap = {
      'glucose': [
        '손가락을 알코올 솜으로 닦아주세요',
        '채혈침으로 손가락 끝을 찔러주세요',
        '혈액 한 방울을 카트리지 시료구에 떨어뜨려주세요',
        '약 30초 정도 기다려주세요',
      ],
      'radon': [
        '리더기를 측정하고자 하는 공간에 놓아주세요',
        '최소 1시간 이상 측정을 권장합니다',
        '창문과 문을 닫은 상태로 유지하세요',
      ],
      'water_ph': [
        '물 시료 5ml를 채취해주세요',
        '시료를 카트리지 시료구에 넣어주세요',
        '뚜껑을 닫고 기다려주세요',
      ],
    };

    return instructionMap[cartridgeType] ?? ['시료를 준비하세요'];
  }

  double _getEstimatedDuration(String cartridgeType) {
    final durationMap = {
      'glucose': 180.0,
      'ketone': 180.0,
      'radon': 3600.0,
      'vocs': 60.0,
      'co2': 30.0,
      'water_ph': 45.0,
    };

    return durationMap[cartridgeType] ?? 180.0;
  }

  String _getUnit(String cartridgeType) {
    final unitMap = {
      'glucose': 'mg/dL',
      'ketone': 'mmol/L',
      'radon': 'Bq/m³',
      'vocs': 'ppb',
      'co2': 'ppm',
      'water_ph': 'pH',
    };

    return unitMap[cartridgeType] ?? 'unit';
  }
}
