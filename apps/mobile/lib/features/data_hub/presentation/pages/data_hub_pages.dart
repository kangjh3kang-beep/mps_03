import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

/// 데이터 헙 메인 페이지
class DataHubPage extends StatelessWidget {
  const DataHubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('데이터 분석'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 트렌드 분석
          _DataHubCard(
            icon: Icons.trending_up,
            title: '트렌드 분석',
            subtitle: '측정값 변화 추이',
            onTap: () => context.push('/data-hub/trends'),
          ),

          // 상관관계 분석
          _DataHubCard(
            icon: Icons.hub,
            title: '상관관계 분석',
            subtitle: '변수 간 관계도',
            onTap: () => context.push('/data-hub/correlation'),
          ),

          // 보고서 생성
          _DataHubCard(
            icon: Icons.description,
            title: '보고서 생성',
            subtitle: 'PDF 보고서 다운로드',
            onTap: () => context.push('/data-hub/reports'),
          ),

          // 외부 동기화
          _DataHubCard(
            icon: Icons.sync,
            title: '외부 동기화',
            subtitle: '다른 앱과 연동',
            onTap: () => context.push('/data-hub/external-sync'),
          ),

          // 가족 데이터
          _DataHubCard(
            icon: Icons.family_restroom,
            title: '가족 데이터',
            subtitle: '가족 구성원 관리',
            onTap: () => context.push('/data-hub/family'),
          ),
        ],
      ),
    );
  }
}

class _DataHubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DataHubCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(icon, color: Colors.blue, size: 32),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}

/// 트렌드 분석 페이지
class TrendAnalysisPage extends StatefulWidget {
  const TrendAnalysisPage({Key? key}) : super(key: key);

  @override
  State<TrendAnalysisPage> createState() => _TrendAnalysisPageState();
}

class _TrendAnalysisPageState extends State<TrendAnalysisPage> {
  String _selectedPeriod = 'week';
  String _selectedMetric = 'glucose';

  final Map<String, List<FlSpot>> _trendData = {
    'glucose': [
      FlSpot(0, 85),
      FlSpot(1, 88),
      FlSpot(2, 82),
      FlSpot(3, 90),
      FlSpot(4, 87),
      FlSpot(5, 84),
      FlSpot(6, 89),
    ],
    'bloodPressure': [
      FlSpot(0, 120),
      FlSpot(1, 118),
      FlSpot(2, 122),
      FlSpot(3, 119),
      FlSpot(4, 121),
      FlSpot(5, 120),
      FlSpot(6, 118),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('트렌드 분석'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 기간 선택
          _PeriodSelector(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              setState(() => _selectedPeriod = period);
            },
          ),
          const SizedBox(height: 24),

          // 지표 선택
          _MetricSelector(
            selectedMetric: _selectedMetric,
            onMetricChanged: (metric) {
              setState(() => _selectedMetric = metric);
            },
          ),
          const SizedBox(height: 24),

          // 차트
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['월', '화', '수', '목', '금', '토', '일'];
                            final index = value.toInt();
                            if (index >= 0 && index < days.length) {
                              return Text(days[index]);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _trendData[_selectedMetric] ?? [],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 통계
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: '평균',
                  value: '86.2',
                  unit: 'mg/dL',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: '최고',
                  value: '90',
                  unit: 'mg/dL',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: '최저',
                  value: '82',
                  unit: 'mg/dL',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 상관관계 분석 페이지
class CorrelationAnalysisPage extends StatefulWidget {
  const CorrelationAnalysisPage({Key? key}) : super(key: key);

  @override
  State<CorrelationAnalysisPage> createState() => _CorrelationAnalysisPageState();
}

class _CorrelationAnalysisPageState extends State<CorrelationAnalysisPage> {
  String _selectedType = 'health';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상관관계 분석'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 분석 유형 선택
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'health', label: Text('건강')),
              ButtonSegment(value: 'environment', label: Text('환경')),
              ButtonSegment(value: 'lifestyle', label: Text('생활방식')),
            ],
            selected: {_selectedType},
            onSelectionChanged: (selected) {
              setState(() => _selectedType = selected.first);
            },
          ),
          const SizedBox(height: 24),

          // 상관관계 목록
          _CorrelationItem(
            variable1: '혈당',
            variable2: '운동 시간',
            correlation: -0.78,
            interpretation: '강한 음의 상관관계: 운동이 많을수록 혈당이 낮음',
          ),
          _CorrelationItem(
            variable1: '혈압',
            variable2: '스트레스',
            correlation: 0.65,
            interpretation: '중간 양의 상관관계: 스트레스가 높을수록 혈압 상승',
          ),
          _CorrelationItem(
            variable1: '수면 시간',
            variable2: '체중',
            correlation: -0.54,
            interpretation: '중간 음의 상관관계: 수면 부족시 체중 증가 경향',
          ),
          _CorrelationItem(
            variable1: '물 섭취',
            variable2: '피부 건강',
            correlation: 0.72,
            interpretation: '강한 양의 상관관계: 수분 섭취가 피부 개선에 도움',
          ),
        ],
      ),
    );
  }
}

/// 보고서 생성 페이지
class ReportGenerationPage extends StatefulWidget {
  const ReportGenerationPage({Key? key}) : super(key: key);

  @override
  State<ReportGenerationPage> createState() => _ReportGenerationPageState();
}

class _ReportGenerationPageState extends State<ReportGenerationPage> {
  String _selectedReportType = 'health';
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보고서 생성'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 보고서 유형
          Text('보고서 유형', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...['health', 'environment', 'comprehensive'].map((type) {
            return RadioListTile<String>(
              title: Text(_getReportTypeName(type)),
              value: type,
              groupValue: _selectedReportType,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedReportType = value);
                }
              },
            );
          }),

          const SizedBox(height: 24),

          // 기간 선택
          Text('기간 선택', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(
                '${_dateRange.start.year}년 ${_dateRange.start.month}월 ${_dateRange.start.day}일 ~ ${_dateRange.end.year}년 ${_dateRange.end.month}월 ${_dateRange.end.day}일',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final newRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                  initialDateRange: _dateRange,
                );
                if (newRange != null) {
                  setState(() => _dateRange = newRange);
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          // 미리보기
          Text('보고서 내용', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$_selectedReportType 건강 리포트', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  const Text('• 기간: 지난 30일'),
                  const Text('• 총 측정 횟수: 28회'),
                  const Text('• 평균값: 86.2 mg/dL'),
                  const Text('• 정상 범위: 95%'),
                  const Text('• AI 분석: 건강한 상태 유지'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // 생성 버튼
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('보고서가 생성되었습니다')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('보고서 생성 & 다운로드'),
          ),
        ],
      ),
    );
  }

  String _getReportTypeName(String type) {
    switch (type) {
      case 'health':
        return '건강 리포트';
      case 'environment':
        return '환경 리포트';
      case 'comprehensive':
        return '종합 리포트';
      default:
        return '';
    }
  }
}

/// 외부 동기화 페이지
class ExternalSyncPage extends StatefulWidget {
  const ExternalSyncPage({Key? key}) : super(key: key);

  @override
  State<ExternalSyncPage> createState() => _ExternalSyncPageState();
}

class _ExternalSyncPageState extends State<ExternalSyncPage> {
  Map<String, bool> _syncStatus = {
    'apple_health': true,
    'google_fit': false,
    'samsung': false,
    'oura': false,
    'fitbit': false,
    'garmin': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('외부 동기화'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('연동할 서비스를 선택하세요', 
            style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          ..._syncStatus.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: _getServiceIcon(entry.key),
                title: Text(_getServiceName(entry.key)),
                subtitle: Text(entry.value ? '연동됨' : '연동 안 됨'),
                trailing: Switch(
                  value: entry.value,
                  onChanged: (value) {
                    setState(() {
                      _syncStatus[entry.key] = value;
                    });
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${_getServiceName(entry.key)}과 연동되었습니다'),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          }),

          const SizedBox(height: 32),

          // 동기화 정보
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('동기화 설정',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('자동 동기화'),
                      Switch(value: true, onChanged: (_) {}),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('데이터 업로드'),
                      Switch(value: true, onChanged: (_) {}),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('데이터 다운로드'),
                      Switch(value: true, onChanged: (_) {}),
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

  Icon _getServiceIcon(String service) {
    switch (service) {
      case 'apple_health':
        return const Icon(Icons.apple, color: Colors.black);
      case 'google_fit':
        return const Icon(Icons.fit_screen, color: Colors.blue);
      case 'samsung':
        return Icon(Icons.watch, color: Colors.blue[900]);
      default:
        return const Icon(Icons.devices);
    }
  }

  String _getServiceName(String service) {
    switch (service) {
      case 'apple_health':
        return 'Apple Health';
      case 'google_fit':
        return 'Google Fit';
      case 'samsung':
        return 'Samsung Health';
      case 'oura':
        return 'Oura Ring';
      case 'fitbit':
        return 'Fitbit';
      case 'garmin':
        return 'Garmin';
      default:
        return '';
    }
  }
}

/// 가족 데이터 페이지
class FamilyDataPage extends StatefulWidget {
  const FamilyDataPage({Key? key}) : super(key: key);

  @override
  State<FamilyDataPage> createState() => _FamilyDataPageState();
}

class _FamilyDataPageState extends State<FamilyDataPage> {
  List<Map<String, String>> _familyMembers = [
    {'name': '본인', 'role': '주인', 'lastUpdate': '방금'},
    {'name': '아버지', 'role': '보호자', 'lastUpdate': '2시간 전'},
    {'name': '어머니', 'role': '보호자', 'lastUpdate': '3시간 전'},
    {'name': '누나', 'role': '가족', 'lastUpdate': '어제'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가족 데이터'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._familyMembers.map((member) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(member['name']!.substring(0, 1)),
                ),
                title: Text(member['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${member['role']} • 마지막 업데이트: ${member['lastUpdate']}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            );
          }),

          const SizedBox(height: 24),

          // 가족 초대
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('가족 멤버 초대'),
                  content: const TextField(
                    decoration: InputDecoration(
                      hintText: '이메일 주소 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('초대 메일이 전송되었습니다')),
                        );
                      },
                      child: const Text('초대'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text('가족 멤버 초대'),
          ),

          const SizedBox(height: 16),

          // 가족 권한 설정
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('권한 설정', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('측정 데이터 공유'),
                    value: true,
                    onChanged: (_) {},
                  ),
                  CheckboxListTile(
                    title: const Text('AI 분석 결과 공유'),
                    value: true,
                    onChanged: (_) {},
                  ),
                  CheckboxListTile(
                    title: const Text('건강 목표 공유'),
                    value: false,
                    onChanged: (_) {},
                  ),
                  CheckboxListTile(
                    title: const Text('응급 상황 알림'),
                    value: true,
                    onChanged: (_) {},
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

// ============ 헬퍼 위젯들 ============

class _PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['day', 'week', 'month', 'year'].map((period) {
        final isSelected = selectedPeriod == period;
        return Expanded(
          child: GestureDetector(
            onTap: () => onPeriodChanged(period),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _getPeriodLabel(period),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList().asMap().entries.map((entry) {
        final widget = entry.value;
        final index = entry.key;
        return Padding(
          padding: EdgeInsets.only(right: index < 3 ? 8 : 0),
          child: widget,
        );
      }).toList(),
    );
  }

  String _getPeriodLabel(String period) {
    switch (period) {
      case 'day':
        return '일간';
      case 'week':
        return '주간';
      case 'month':
        return '월간';
      case 'year':
        return '연간';
      default:
        return '';
    }
  }
}

class _MetricSelector extends StatelessWidget {
  final String selectedMetric;
  final Function(String) onMetricChanged;

  const _MetricSelector({
    required this.selectedMetric,
    required this.onMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedMetric,
      decoration: InputDecoration(
        labelText: '지표 선택',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: const [
        DropdownMenuItem(value: 'glucose', child: Text('혈당')),
        DropdownMenuItem(value: 'bloodPressure', child: Text('혈압')),
        DropdownMenuItem(value: 'heartRate', child: Text('심박수')),
      ],
      onChanged: (value) {
        if (value != null) {
          onMetricChanged(value);
        }
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _CorrelationItem extends StatelessWidget {
  final String variable1;
  final String variable2;
  final double correlation;
  final String interpretation;

  const _CorrelationItem({
    required this.variable1,
    required this.variable2,
    required this.correlation,
    required this.interpretation,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = correlation > 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$variable1 ↔ $variable2',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      isPositive ? '양의 상관관계' : '음의 상관관계',
                      style: TextStyle(
                        fontSize: 12,
                        color: isPositive ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green[100] : Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    correlation.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green[900] : Colors.orange[900],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(interpretation, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
