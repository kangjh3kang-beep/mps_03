import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/measurement_process_bloc.dart';
import '../../domain/entities/measurement_entities.dart';

// ============ 측정 프로세스 단계별 페이지들 ============

/// 1단계: 카트리지 삽입 (20% 진행)
class CartridgeInsertionPage extends StatefulWidget {
  final String measurementType;
  const CartridgeInsertionPage({
    Key? key,
    required this.measurementType,
  }) : super(key: key);

  @override
  State<CartridgeInsertionPage> createState() => _CartridgeInsertionPageState();
}

class _CartridgeInsertionPageState extends State<CartridgeInsertionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementProcessBloc, MeasurementProcessState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('카트리지 삽입'),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 진행 표시기
                LinearProgressIndicator(value: 0.2),
                SizedBox(height: 40),
                
                // 카트리지 상태 표시
                if (state is CartridgeInsertionStep)
                  _buildCartridgeInsertionContent(context, state)
                else
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartridgeInsertionContent(
    BuildContext context,
    CartridgeInsertionStep state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // NFC 애니메이션 영역
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.nfc,
                    size: 80,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 12),
                  Text(
                    state.cartridgeDetected ? '감지됨' : '기다리는 중...',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          
          // 상태 체크리스트
          _StatusCheckItem(
            icon: Icons.check_circle,
            title: '카트리지 감지',
            isCompleted: state.cartridgeDetected,
          ),
          SizedBox(height: 12),
          _StatusCheckItem(
            icon: Icons.check_circle,
            title: '보정 데이터 로드',
            isCompleted: state.calibrationLoaded,
          ),
          SizedBox(height: 40),
          
          // 테스트 버튼 (개발용)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<MeasurementProcessBloc>().add(
                  const CartridgeDetected(),
                );
                Future.delayed(Duration(seconds: 1), () {
                  context.read<MeasurementProcessBloc>().add(
                    const CalibrationLoaded(),
                  );
                });
              },
              child: const Text('테스트: 카트리지 감지'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 2단계: 시료 준비 (40% 진행)
class SamplePreparationPage extends StatefulWidget {
  final String measurementType;
  const SamplePreparationPage({
    Key? key,
    required this.measurementType,
  }) : super(key: key);

  @override
  State<SamplePreparationPage> createState() => _SamplePreparationPageState();
}

class _SamplePreparationPageState extends State<SamplePreparationPage> {
  late Set<int> completedSteps;

  @override
  void initState() {
    super.initState();
    completedSteps = {};
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementProcessBloc, MeasurementProcessState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('시료 준비'),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                LinearProgressIndicator(value: 0.4),
                SizedBox(height: 24),
                
                if (state is SamplePreparationStep)
                  _buildSamplePreparationContent(context, state)
                else
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSamplePreparationContent(
    BuildContext context,
    SamplePreparationStep state,
  ) {
    final instructions = _getInstructions();
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '다음 단계를 따르세요',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 24),
          
          // 단계별 지시사항
          ...List.generate(instructions.length, (index) {
            final isCompleted = completedSteps.contains(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isCompleted) {
                    completedSteps.remove(index);
                  } else {
                    completedSteps.add(index);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green[50] : Colors.grey[50],
                  border: Border.all(
                    color: isCompleted ? Colors.green : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.circle,
                      color: isCompleted ? Colors.green : Colors.grey,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${instructions[index]}',
                            style: TextStyle(
                              fontSize: 16,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          
          SizedBox(height: 24),
          
          // AR 가이드 토글
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AR 가이드'),
              Switch(
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
          
          SizedBox(height: 32),
          
          // 다음 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: completedSteps.length == instructions.length
                  ? () {
                      context.read<MeasurementProcessBloc>().add(
                        const SamplePreparationCompleted(),
                      );
                    }
                  : null,
              child: const Text('시료 준비 완료'),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getInstructions() {
    switch (widget.measurementType.toLowerCase()) {
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

/// 3단계: 측정 중 (60% 진행)
class MeasuringPage extends StatefulWidget {
  final String measurementType;
  const MeasuringPage({
    Key? key,
    required this.measurementType,
  }) : super(key: key);

  @override
  State<MeasuringPage> createState() => _MeasuringPageState();
}

class _MeasuringPageState extends State<MeasuringPage> {
  @override
  void initState() {
    super.initState();
    // 측정 시작
    Future.microtask(() {
      context.read<MeasurementProcessBloc>().add(
        const StartMeasuring(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementProcessBloc, MeasurementProcessState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (state is MeasuringStep) {
              return await _showCancelDialog(context);
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('측정 중'),
              elevation: 0,
            ),
            body: state is MeasuringStep
                ? _buildMeasuringContent(context, state)
                : Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget _buildMeasuringContent(
    BuildContext context,
    MeasuringStep state,
  ) {
    final progress = state.progress;
    final phase = state.currentPhase.phaseName;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 진행률 표시
          LinearProgressIndicator(value: 0.6),
          SizedBox(height: 40),
          
          // 큰 진행률 표시
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${progress.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    phase,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 40),
          
          // 파형 데이터 표시
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Text(
                '파형 데이터 포인트: ${state.waveformData.length}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // 5단계 표시기
          _PhaseIndicators(
            phases: [
              '초기화',
              '기저선',
              '전압인가',
              '신호측정',
              '분석',
            ],
            currentPhaseIndex: _getPhaseIndex(phase),
            progress: progress,
          ),
          
          SizedBox(height: 24),
          
          // 남은 시간 표시
          Text(
            'ETA: ${_formatDuration(state.estimatedTimeRemaining)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          
          SizedBox(height: 40),
          
          // 취소 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showCancelDialog(context),
              child: const Text('측정 취소'),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showCancelDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('측정을 취소하시겠습니까?'),
        content: const Text('진행 중인 측정이 취소됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('계속'),
          ),
          TextButton(
            onPressed: () {
              context.read<MeasurementProcessBloc>().add(
                const CancelMeasurement(),
              );
              Navigator.of(context).pop(true);
            },
            child: const Text('취소'),
          ),
        ],
      ),
    ) ?? false;
  }

  int _getPhaseIndex(String phase) {
    const phases = ['초기화', '기저선', '전압인가', '신호측정', '분석'];
    return phases.indexOf(phase);
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}

/// 4단계: 결과 확인 (80% 진행)
class ResultPage extends StatefulWidget {
  final String measurementType;
  const ResultPage({
    Key? key,
    required this.measurementType,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementProcessBloc, MeasurementProcessState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('측정 결과'),
            elevation: 0,
          ),
          body: state is ResultStep
              ? _buildResultContent(context, state)
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildResultContent(
    BuildContext context,
    ResultStep state,
  ) {
    final result = state.result;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          LinearProgressIndicator(value: 0.8),
          SizedBox(height: 32),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 결과값 표시
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        result['value'].toString(),
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        result['unit'] ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32),
                
                // 정상 범위 표시
                Text('정상 범위', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 12),
                
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.65,
                          minHeight: 20,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '70 - 130 (정상)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // 불확도 표시
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    border: Border.all(color: Colors.amber[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.amber[700]),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '측정 불확도: ${result['uncertainty'] ?? '±2.5'} ${result['unit'] ?? ''}',
                          style: TextStyle(color: Colors.amber[900]),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // AI 해석
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.blue[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.smart_toy, color: Colors.blue),
                          SizedBox(width: 12),
                          Text(
                            'AI 분석',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        result['aiInterpretation'] ?? '정상 범위입니다',
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '신뢰도: ${result['confidence'] ?? 95}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 40),
                
                // 다음 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<MeasurementProcessBloc>().add(
                        const ProceedToNextStep(),
                      );
                    },
                    child: const Text('다음'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 5단계: 후속 조치 (100% 진행)
class FollowUpPage extends StatefulWidget {
  final String measurementType;
  const FollowUpPage({
    Key? key,
    required this.measurementType,
  }) : super(key: key);

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementProcessBloc, MeasurementProcessState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('측정 완료'),
            elevation: 0,
          ),
          body: state is FollowUpStep
              ? _buildFollowUpContent(context, state)
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildFollowUpContent(
    BuildContext context,
    FollowUpStep state,
  ) {
    final result = state.result;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          LinearProgressIndicator(value: 1.0),
          SizedBox(height: 32),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 완료 표시
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                
                SizedBox(height: 32),
                
                Center(
                  child: Text(
                    '측정이 완료되었습니다',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                
                SizedBox(height: 32),
                
                // 권장사항
                Text(
                  '권장사항',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 12),
                
                ...(result['recommendations'] as List?)?.map((rec) => _RecommendationItem(
                  title: rec['title'] ?? '',
                  description: rec['description'] ?? '',
                )) ?? [],
                
                SizedBox(height: 32),
                
                // 액션 버튼들
                if (result['needsRemeasurement'] ?? false)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<MeasurementProcessBloc>().add(
                          const RetryMeasurement(),
                        );
                      },
                      child: const Text('다시 측정하기'),
                    ),
                  ),
                
                if ((result['needsRemeasurement'] ?? false) && (result['needsConsultation'] ?? false))
                  SizedBox(height: 12),
                
                if (result['needsConsultation'] ?? false)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // 진료 예약 페이지로 이동
                      },
                      child: const Text('의료진 상담 예약'),
                    ),
                  ),
                
                SizedBox(height: 12),
                
                // 홈으로 가기
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/',
                        (route) => false,
                      );
                    },
                    child: const Text('홈으로 돌아가기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============ 헬퍼 위젯들 ============

class _StatusCheckItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCompleted;

  const _StatusCheckItem({
    required this.icon,
    required this.title,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: isCompleted ? Colors.green : Colors.grey,
          size: 32,
        ),
        SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isCompleted ? Colors.green : Colors.grey,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}

class _PhaseIndicators extends StatelessWidget {
  final List<String> phases;
  final int currentPhaseIndex;
  final double progress;

  const _PhaseIndicators({
    required this.phases,
    required this.currentPhaseIndex,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(phases.length, (index) {
        final isCompleted = index < currentPhaseIndex;
        final isCurrent = index == currentPhaseIndex;
        
        return Padding(
          padding: EdgeInsets.only(bottom: index < phases.length - 1 ? 12 : 0),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isCurrent ? Colors.blue : Colors.grey[200],
                  border: Border.all(
                    color: isCurrent ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCompleted || isCurrent ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                phases[index],
                style: TextStyle(
                  color: isCompleted || isCurrent ? Colors.blue : Colors.grey,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final String title;
  final String description;

  const _RecommendationItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: Colors.green),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (description.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('카트리지 정보', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('타입'),
                                Text(state.session.cartridgeType, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('유효기간'),
                                Text('${state.session.cartridge.expiryDate.year}-${state.session.cartridge.expiryDate.month}-${state.session.cartridge.expiryDate.day}'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('남은 횟수'),
                                Text('${state.session.cartridge.remainingUses}회'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 상태 표시
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(
                                state.cartridgeDetected ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: state.cartridgeDetected ? Colors.green : Colors.grey,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              const Text('카트리지 인식'),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                state.calibrationLoaded ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: state.calibrationLoaded ? Colors.green : Colors.grey,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              const Text('보정 데이터'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 시뮬레이션 버튼 (테스트용)
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<MeasurementProcessBloc>().add(
                            CartridgeDetected(
                              cartridge: state.session.cartridge,
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            context.read<MeasurementProcessBloc>().add(const CalibrationLoaded());
                          });
                        },
                        icon: const Icon(Icons.nfc),
                        label: const Text('카트리지 인식 시뮬레이션'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Step 2: 시료 준비
class SamplePreparationPage extends StatefulWidget {
  const SamplePreparationPage({Key? key}) : super(key: key);

  @override
  State<SamplePreparationPage> createState() => _SamplePreparationPageState();
}

class _SamplePreparationPageState extends State<SamplePreparationPage> {
  int _completedSteps = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementProcessBloc, MeasurementProcessState>(
      builder: (context, state) {
        if (state is! SamplePreparationStep) return const SizedBox();

        return Scaffold(
          appBar: AppBar(title: const Text('Step 2: 시료 준비')),
          body: SingleChildScrollView(
            child: Column(
              children: [
                LinearProgressIndicator(value: 0.4),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '다음 단계를 따라 시료를 준비하세요',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // 준비 단계 목록
                      ...List.generate(
                        state.instructions.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              if (index <= _completedSteps) {
                                setState(() => _completedSteps = index - 1);
                              } else if (index == _completedSteps + 1) {
                                setState(() => _completedSteps = index);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: index <= _completedSteps ? Colors.green[50] : Colors.grey[100],
                                border: Border.all(
                                  color: index <= _completedSteps ? Colors.green : Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    index < _completedSteps ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: index < _completedSteps ? Colors.green : Colors.grey,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Step ${index + 1}',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(state.instructions[index]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // AR 가이드 토글
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('AR 가이드'),
                          Switch(
                            value: state.arGuideEnabled,
                            onChanged: (_) {
                              // AR 가이드 토글
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // 준비 완료 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _completedSteps == state.instructions.length - 1
                              ? () {
                                  context.read<MeasurementProcessBloc>().add(
                                    const SamplePreparationCompleted(),
                                  );
                                }
                              : null,
                          child: const Text('시료 준비 완료'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Step 3: 측정 진행
class MeasuringPage extends StatelessWidget {
  const MeasuringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementProcessBloc, MeasurementProcessState>(
      builder: (context, state) {
        if (state is! MeasuringStep) return const SizedBox();

        return Scaffold(
          appBar: AppBar(title: const Text('Step 3: 측정 진행')),
          body: SingleChildScrollView(
            child: Column(
              children: [
                LinearProgressIndicator(value: 0.6),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // 진행률 표시
                      Text(
                        '${(state.currentPhase?.progress ?? 0) * 100}.0%',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(state.currentPhase?.phaseName ?? '측정 중...'),
                      const SizedBox(height: 32),

                      // 실시간 파형 차트 (시뮬레이션)
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.show_chart, size: 64, color: Colors.blue),
                              const SizedBox(height: 16),
                              Text('파형 데이터: ${state.waveformData.length} 포인트'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 단계 표시
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          5,
                          (i) => Column(
                            children: [
                              Icon(
                                i < ((state.currentPhase?.progress ?? 0) * 5).toInt()
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: i < ((state.currentPhase?.progress ?? 0) * 5).toInt()
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ['초기', '기저', '전압', '신호', '분석'][i],
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 예상 남은 시간
                      Text(
                        '예상 남은 시간: ${state.estimatedTimeRemaining.toInt()}초',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),

                      // 측정 취소 버튼
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<MeasurementProcessBloc>().add(
                              const CancelMeasurement(),
                            );
                          },
                          child: const Text('측정 취소'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Step 4: 결과 표시
class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementProcessBloc, MeasurementProcessState>(
      builder: (context, state) {
        if (state is! ResultStep) return const SizedBox();

        return Scaffold(
          appBar: AppBar(title: const Text('Step 4: 측정 결과')),
          body: SingleChildScrollView(
            child: Column(
              children: [
                LinearProgressIndicator(value: 0.8),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // 결과값 표시
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${state.result.value}',
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(state.result.unit),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                state.result.status.toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 정상 범위 표시
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('정상 범위'),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: state.result.value / 200,
                                minHeight: 24,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('70 ${state.result.unit}'),
                                const Text('130 ${state.result.unit}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 불확실도
                      if (state.showUncertainty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('측정 불확실도'),
                                    Text('±${state.result.uncertainty} ${state.result.unit}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),

                      // AI 해석
                      if (state.showAIInterpretation)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('AI 해석'),
                              const SizedBox(height: 8),
                              Text(state.result.aiInterpretation),
                              const SizedBox(height: 8),
                              Text(
                                '신뢰도: ${(state.result.aiConfidence * 100).toInt()}%',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),

                      // 다음 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<MeasurementProcessBloc>().add(
                              const ProceedToNextStep(),
                            );
                          },
                          child: const Text('다음'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Step 5: 후속 조치
class FollowUpPage extends StatelessWidget {
  const FollowUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementProcessBloc, MeasurementProcessState>(
      builder: (context, state) {
        if (state is! FollowUpStep) return const SizedBox();

        return Scaffold(
          appBar: AppBar(title: const Text('Step 5: 후속 조치')),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const LinearProgressIndicator(value: 1.0),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '측정이 완료되었습니다',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // 권장사항
                      if (state.recommendations.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '권장사항',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            ...state.recommendations.asMap().entries.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(e.value)),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 24),
                          ],
                        ),

                      // 다시 측정 제안
                      if (state.suggestRemeasurement)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<MeasurementProcessBloc>().add(
                                const RetryMeasurement(),
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('다시 측정하기'),
                          ),
                        ),

                      // 전문가 상담 제안
                      if (state.suggestConsultation)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // 전문가 상담 페이지로 이동
                            },
                            icon: const Icon(Icons.videocam),
                            label: const Text('전문가 상담 예약'),
                          ),
                        ),

                      // 코칭 액션
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // AI 코칭 페이지로 이동
                          },
                          icon: const Icon(Icons.smart_toy),
                          label: const Text('AI 코칭 확인'),
                        ),
                      ),

                      // 홈으로 돌아가기
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            child: const Text('홈으로 돌아가기'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
