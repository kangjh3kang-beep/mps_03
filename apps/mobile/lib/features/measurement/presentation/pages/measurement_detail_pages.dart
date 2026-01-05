import 'package:flutter/material.dart';

/// 측정 상세 페이지들 - Phase 2 구현
/// 캘리브레이션, 품질 체크, 해석, 공유, 내보내기, 이력, 비교, 추이, 권장사항, 상세

// ============================================
// 캘리브레이션 페이지
// ============================================
class CalibrationPage extends StatefulWidget {
  const CalibrationPage({super.key});

  @override
  State<CalibrationPage> createState() => _CalibrationPageState();
}

class _CalibrationPageState extends State<CalibrationPage> {
  int _currentStep = 0;
  bool _isCalibrating = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('기기 캘리브레이션'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 진행 상태
            _buildProgressIndicator(theme),
            const SizedBox(height: 32),

            // 캘리브레이션 단계
            _buildCalibrationSteps(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ),
            ),
            Text(
              '${(_progress * 100).toInt()}%',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _isCalibrating ? '캘리브레이션 진행 중...' : '캘리브레이션 준비',
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildCalibrationSteps(ThemeData theme) {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: () async {
        if (_currentStep == 2) {
          // 캘리브레이션 시작
          setState(() => _isCalibrating = true);
          for (int i = 0; i <= 100; i += 10) {
            await Future.delayed(const Duration(milliseconds: 200));
            setState(() => _progress = i / 100);
          }
          setState(() {
            _isCalibrating = false;
            _currentStep = 3;
          });
        } else if (_currentStep < 3) {
          setState(() => _currentStep++);
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) setState(() => _currentStep--);
      },
      steps: [
        Step(
          title: const Text('기기 연결'),
          content: const Text('리더기를 USB 또는 Bluetooth로 연결해주세요.'),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('대조 용액 준비'),
          content: const Text('캘리브레이션용 대조 용액을 준비해주세요.'),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('캘리브레이션 실행'),
          content: const Text('대조 용액을 삽입하고 캘리브레이션을 시작합니다.'),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('완료'),
          content: const Text('캘리브레이션이 완료되었습니다!'),
          isActive: _currentStep >= 3,
          state: _currentStep == 3 ? StepState.complete : StepState.indexed,
        ),
      ],
    );
  }
}

// ============================================
// 품질 체크 페이지
// ============================================
class QualityCheckPage extends StatelessWidget {
  const QualityCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('품질 검사')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildQualityCard(
            '센서 상태',
            '정상',
            Icons.sensors,
            Colors.green,
            '최근 교체: 7일 전',
          ),
          _buildQualityCard(
            '배터리',
            '85%',
            Icons.battery_charging_full,
            Colors.green,
            '예상 잔여: 2주',
          ),
          _buildQualityCard(
            '연결 품질',
            '우수',
            Icons.signal_cellular_4_bar,
            Colors.green,
            'Bluetooth 5.0',
          ),
          _buildQualityCard(
            '캘리브레이션',
            '필요',
            Icons.tune,
            Colors.orange,
            '마지막: 30일 전',
          ),
          _buildQualityCard(
            '데이터 동기화',
            '완료',
            Icons.sync,
            Colors.green,
            '최근: 5분 전',
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            label: const Text('전체 진단 실행'),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityCard(
    String title,
    String status,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Chip(
          label: Text(status),
          backgroundColor: color.withOpacity(0.1),
          labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ============================================
// 해석 페이지
// ============================================
class InterpretationPage extends StatelessWidget {
  const InterpretationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('결과 해석')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI 해석
            Card(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.psychology,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text('AI 분석 결과',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '현재 혈당 수치 95mg/dL은 정상 범위입니다. 공복 혈당 기준 70-100mg/dL 범위 내에 있으며, 건강한 혈당 조절 상태를 보여주고 있습니다.',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 참조 범위
            Text('참조 범위',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildReferenceRange('정상', '70-100 mg/dL', Colors.green),
            _buildReferenceRange('경계', '100-125 mg/dL', Colors.orange),
            _buildReferenceRange('당뇨', '126+ mg/dL', Colors.red),

            const SizedBox(height: 24),

            // 권장 사항
            Text('권장 사항',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildRecommendation(Icons.restaurant, '균형 잡힌 식단 유지'),
            _buildRecommendation(Icons.directions_walk, '규칙적인 운동'),
            _buildRecommendation(Icons.schedule, '정기적인 측정 지속'),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceRange(String label, String range, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          Text(range, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _buildRecommendation(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      dense: true,
    );
  }
}

// ============================================
// 결과 공유 페이지
// ============================================
class ResultSharingPage extends StatelessWidget {
  const ResultSharingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('결과 공유')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.people)),
            title: const Text('가족에게 공유'),
            subtitle: const Text('가족 그룹과 결과 공유'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.medical_services)),
            title: const Text('의료진에게 전송'),
            subtitle: const Text('담당 의사에게 결과 전송'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.email)),
            title: const Text('이메일로 전송'),
            subtitle: const Text('PDF 리포트 이메일 발송'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.share)),
            title: const Text('기타 공유'),
            subtitle: const Text('다른 앱으로 공유'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ============================================
// 내보내기 페이지
// ============================================
class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('데이터 내보내기')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: const Text('PDF 리포트'),
                  subtitle: const Text('상세 건강 리포트'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('내보내기'),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.table_chart, color: Colors.green),
                  title: const Text('Excel (CSV)'),
                  subtitle: const Text('스프레드시트 형식'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('내보내기'),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.code, color: Colors.blue),
                  title: const Text('JSON'),
                  subtitle: const Text('원본 데이터'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('내보내기'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 기간 선택
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('내보낼 기간',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                          label: const Text('최근 7일'),
                          selected: false,
                          onSelected: (_) {}),
                      ChoiceChip(
                          label: const Text('최근 30일'),
                          selected: true,
                          onSelected: (_) {}),
                      ChoiceChip(
                          label: const Text('최근 90일'),
                          selected: false,
                          onSelected: (_) {}),
                      ChoiceChip(
                          label: const Text('전체'),
                          selected: false,
                          onSelected: (_) {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// 측정 이력 페이지
// ============================================
class MeasurementHistoryPage extends StatelessWidget {
  const MeasurementHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('측정 이력'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Icon(Icons.water_drop, color: Colors.blue),
              ),
              title: Text('혈당 측정 #${20 - index}'),
              subtitle: Text('${95 + index} mg/dL • ${index + 1}일 전'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('정상', style: TextStyle(color: Colors.green)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================
// 결과 비교 페이지
// ============================================
class ResultComparisonPage extends StatelessWidget {
  const ResultComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('결과 비교')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 비교 기간 선택
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('이번 주', style: theme.textTheme.labelLarge),
                          const SizedBox(height: 8),
                          Text('92',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const Text('mg/dL 평균',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('지난 주', style: theme.textTheme.labelLarge),
                          const SizedBox(height: 8),
                          Text('98',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold)),
                          const Text('mg/dL 평균',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 변화량
            Card(
              color: Colors.green.withOpacity(0.1),
              child: ListTile(
                leading: const Icon(Icons.trending_down,
                    color: Colors.green, size: 32),
                title: const Text('-6 mg/dL',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                subtitle: const Text('지난 주 대비 개선'),
              ),
            ),
            const SizedBox(height: 24),

            // 상세 비교
            Text('상세 비교',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildComparisonRow('최고값', '112', '120', true),
            _buildComparisonRow('최저값', '78', '82', true),
            _buildComparisonRow('측정 횟수', '14', '12', true),
            _buildComparisonRow('정상 비율', '92%', '85%', true),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(
      String label, String current, String previous, bool improved) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(current, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Icon(
              improved ? Icons.arrow_downward : Icons.arrow_upward,
              color: improved ? Colors.green : Colors.red,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(previous, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 추이 분석 페이지
// ============================================
class TrendingAnalysisPage extends StatelessWidget {
  const TrendingAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('추이 분석')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 추세 요약
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.trending_down,
                        color: Colors.green, size: 48),
                    const SizedBox(height: 8),
                    Text('하락 추세',
                        style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    const Text('지난 30일간 혈당이 점차 감소하고 있습니다'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 그래프 플레이스홀더
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('추이 그래프')),
            ),
            const SizedBox(height: 24),

            // 통계
            Text('통계 요약',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildStatCard('평균', '94', 'mg/dL', Colors.blue)),
                const SizedBox(width: 12),
                Expanded(
                    child:
                        _buildStatCard('표준편차', '8.5', 'mg/dL', Colors.purple)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildStatCard('최고', '115', 'mg/dL', Colors.orange)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildStatCard('최저', '72', 'mg/dL', Colors.teal)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(unit,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 측정 권장사항 페이지
// ============================================
class MeasurementRecommendationsPage extends StatelessWidget {
  const MeasurementRecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('권장 사항')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRecommendationCard(
            Icons.schedule,
            '측정 시간',
            '식전 공복 상태에서 측정하는 것이 가장 정확합니다.',
            Colors.blue,
          ),
          _buildRecommendationCard(
            Icons.restaurant,
            '식이 관리',
            '저당 식품 위주로 식단을 구성하세요.',
            Colors.green,
          ),
          _buildRecommendationCard(
            Icons.directions_walk,
            '운동',
            '식후 30분 가벼운 산책을 권장합니다.',
            Colors.orange,
          ),
          _buildRecommendationCard(
            Icons.nightlight,
            '수면',
            '충분한 수면은 혈당 조절에 도움이 됩니다.',
            Colors.purple,
          ),
          _buildRecommendationCard(
            Icons.local_hospital,
            '정기 검진',
            '3개월마다 HbA1c 검사를 받으세요.',
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
      IconData icon, String title, String description, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 측정 상세 페이지
// ============================================
class MeasurementDetailPage extends StatelessWidget {
  final String? measurementId;

  const MeasurementDetailPage({super.key, this.measurementId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('측정 상세'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 측정값 카드
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.water_drop,
                        size: 48, color: Colors.purple),
                    const SizedBox(height: 16),
                    Text(
                      '95',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const Text('mg/dL', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('정상 범위',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 상세 정보
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('측정 시간'),
                    trailing: const Text('오전 8:30'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('측정 날짜'),
                    trailing: const Text('2026년 1월 5일'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.device_hub),
                    title: const Text('측정 기기'),
                    trailing: const Text('MPS Reader v2'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.science),
                    title: const Text('카트리지'),
                    trailing: const Text('GLU-A100'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
