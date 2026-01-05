import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 최근 측정 페이지 - 측정 이력 목록
class RecentMeasurementsPage extends StatelessWidget {
  const RecentMeasurementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 샘플 데이터
    final measurements = _generateSampleMeasurements();

    return Scaffold(
      appBar: AppBar(
        title: const Text('최근 측정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: measurements.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final measurement = measurements[index];
                return _buildMeasurementCard(context, measurement, theme);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 새 측정 시작
        },
        icon: const Icon(Icons.add),
        label: const Text('새 측정'),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            '아직 측정 기록이 없습니다',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째 측정을 시작해보세요',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementCard(
    BuildContext context,
    Map<String, dynamic> measurement,
    ThemeData theme,
  ) {
    final dateFormat = DateFormat('MM/dd HH:mm');
    final isToday = _isToday(measurement['timestamp']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // 상세 페이지로 이동
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          _getTypeColor(measurement['type']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTypeIcon(measurement['type']),
                      color: _getTypeColor(measurement['type']),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          measurement['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isToday
                              ? '오늘 ${DateFormat('HH:mm').format(measurement['timestamp'])}'
                              : dateFormat.format(measurement['timestamp']),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(measurement['status']),
                ],
              ),

              const Divider(height: 24),

              // 수치
              Row(
                children: [
                  _buildValueItem(
                    measurement['primaryLabel'],
                    measurement['primaryValue'],
                    measurement['primaryUnit'],
                  ),
                  if (measurement['secondaryLabel'] != null) ...[
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey[200],
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    _buildValueItem(
                      measurement['secondaryLabel'],
                      measurement['secondaryValue'],
                      measurement['secondaryUnit'],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueItem(String label, String value, String unit) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case '정상':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      case '주의':
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case '위험':
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'blood_glucose':
        return Icons.water_drop;
      case 'blood_pressure':
        return Icons.favorite;
      case 'temperature':
        return Icons.thermostat;
      case 'cholesterol':
        return Icons.science;
      default:
        return Icons.health_and_safety;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'blood_glucose':
        return Colors.purple;
      case 'blood_pressure':
        return Colors.red;
      case 'temperature':
        return Colors.orange;
      case 'cholesterol':
        return Colors.blue;
      default:
        return Colors.teal;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '필터',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                    label: const Text('전체'),
                    onSelected: (_) {},
                    selected: true),
                FilterChip(label: const Text('혈당'), onSelected: (_) {}),
                FilterChip(label: const Text('혈압'), onSelected: (_) {}),
                FilterChip(label: const Text('체온'), onSelected: (_) {}),
                FilterChip(label: const Text('콜레스테롤'), onSelected: (_) {}),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('적용'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateSampleMeasurements() {
    final now = DateTime.now();
    return [
      {
        'type': 'blood_glucose',
        'title': '혈당 측정',
        'timestamp': now.subtract(const Duration(hours: 2)),
        'status': '정상',
        'primaryLabel': '혈당',
        'primaryValue': '95',
        'primaryUnit': 'mg/dL',
        'secondaryLabel': null,
      },
      {
        'type': 'blood_pressure',
        'title': '혈압 측정',
        'timestamp': now.subtract(const Duration(hours: 5)),
        'status': '정상',
        'primaryLabel': '수축기',
        'primaryValue': '120',
        'primaryUnit': 'mmHg',
        'secondaryLabel': '이완기',
        'secondaryValue': '80',
        'secondaryUnit': 'mmHg',
      },
      {
        'type': 'temperature',
        'title': '체온 측정',
        'timestamp': now.subtract(const Duration(days: 1)),
        'status': '주의',
        'primaryLabel': '체온',
        'primaryValue': '37.5',
        'primaryUnit': '°C',
        'secondaryLabel': null,
      },
      {
        'type': 'cholesterol',
        'title': '콜레스테롤 검사',
        'timestamp': now.subtract(const Duration(days: 3)),
        'status': '정상',
        'primaryLabel': 'LDL',
        'primaryValue': '95',
        'primaryUnit': 'mg/dL',
        'secondaryLabel': 'HDL',
        'secondaryValue': '55',
        'secondaryUnit': 'mg/dL',
      },
    ];
  }
}
