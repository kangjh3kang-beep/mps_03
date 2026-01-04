import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 구독 서비스 페이지
/// 기획안: /more/marketplace/subscription
class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      id: 'basic-safety',
      name: 'Basic Safety',
      badge: '기본',
      price: 29000,
      period: '월',
      color: Colors.blue,
      description: '건강 모니터링의 첫 걸음',
      features: [
        '월 10회 건강 측정',
        '기본 AI 코칭',
        '데이터 저장 (3개월)',
        '이메일 리포트',
      ],
      cartridges: ['혈당 카트리지 10개'],
      popularityPercent: 0,
    ),
    SubscriptionPlan(
      id: 'bio-optimization',
      name: 'Bio-Optimization',
      badge: '인기',
      price: 59000,
      period: '월',
      color: Colors.green,
      description: '적극적인 건강 최적화',
      features: [
        '월 30회 건강 측정',
        '고급 AI 코칭 + 개인화 추천',
        '무제한 데이터 저장',
        '주간 리포트 + 트렌드 분석',
        '가족 공유 (2인)',
        '우선 고객 지원',
      ],
      cartridges: ['혈당 카트리지 30개', '케톤체 카트리지 5개'],
      popularityPercent: 65,
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 'clinical-guard',
      name: 'Clinical Guard',
      badge: '프리미엄',
      price: 119000,
      period: '월',
      color: Colors.purple,
      description: '의료 수준의 관리',
      features: [
        '무제한 건강 측정',
        '프리미엄 AI 코칭 + 72시간 예측',
        '무제한 데이터 저장 + 백업',
        '일간 리포트 + 이상 탐지 알림',
        '가족 공유 (5인)',
        '24/7 전문 상담',
        '월 1회 화상 진료 포함',
        '처방전 관리',
      ],
      cartridges: [
        '혈당 카트리지 50개',
        '케톤체 카트리지 10개',
        '콜레스테롤 카트리지 5개',
      ],
      popularityPercent: 0,
    ),
    SubscriptionPlan(
      id: 'family',
      name: 'Family Plan',
      badge: '가족',
      price: 149000,
      period: '월',
      color: Colors.orange,
      description: '온 가족 건강 케어',
      features: [
        '가족 구성원 최대 10인',
        '구성원별 개별 건강 프로필',
        '가족 건강 대시보드',
        '구성원별 월 20회 측정',
        '어린이/노인 특화 AI 코칭',
        '가족 공유 리포트',
        '보호자 알림 기능',
      ],
      cartridges: [
        '혈당 카트리지 100개',
        '케톤체 카트리지 20개',
      ],
      popularityPercent: 0,
    ),
    SubscriptionPlan(
      id: 'enterprise',
      name: 'Enterprise',
      badge: '기업',
      price: 0, // 협의
      period: '월',
      color: Colors.grey,
      description: '기업/연구기관용 맞춤 솔루션',
      features: [
        '무제한 사용자',
        '맞춤형 대시보드',
        'API 액세스',
        '전용 서버 옵션',
        '법인 청구',
        '전담 매니저 배정',
        'SLA 보장',
        '데이터 분석 리포트',
      ],
      cartridges: ['맞춤 협의'],
      popularityPercent: 0,
      isEnterprise: true,
    ),
  ];

  String? _selectedPlanId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구독 서비스'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 헤더 배너
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.purple[600]!],
                ),
              ),
              child: Column(
                children: const [
                  Icon(Icons.workspace_premium, color: Colors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    '나에게 맞는 플랜을 선택하세요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '모든 플랜은 7일 무료 체험이 가능합니다',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // 플랜 목록
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _plans.map((plan) {
                  return _SubscriptionPlanCard(
                    plan: plan,
                    isSelected: _selectedPlanId == plan.id,
                    onSelect: () {
                      setState(() {
                        _selectedPlanId = plan.id;
                      });
                    },
                    onViewDetails: () {
                      context.go('/marketplace/subscription/${plan.id}');
                    },
                  );
                }).toList(),
              ),
            ),

            // 비교표
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '플랜 비교',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildComparisonTable(),
                    ],
                  ),
                ),
              ),
            ),

            // FAQ
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '자주 묻는 질문',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildFAQItem(
                        '언제든지 해지할 수 있나요?',
                        '네, 구독은 언제든지 해지 가능합니다. 해지 후에도 결제 기간 종료까지 서비스를 이용하실 수 있습니다.',
                      ),
                      _buildFAQItem(
                        '플랜을 변경할 수 있나요?',
                        '네, 언제든지 상위 또는 하위 플랜으로 변경 가능합니다. 변경 사항은 다음 결제일부터 적용됩니다.',
                      ),
                      _buildFAQItem(
                        '카트리지는 어떻게 배송되나요?',
                        '구독 시작 후 3일 이내에 첫 카트리지가 배송되며, 이후 잔여량에 따라 자동으로 보충 배송됩니다.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _selectedPlanId != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    // 구독 시작
                    final plan = _plans.firstWhere((p) => p.id == _selectedPlanId);
                    _showSubscriptionConfirmDialog(plan);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _plans.firstWhere((p) => p.id == _selectedPlanId).color,
                  ),
                  child: Text(
                    '${_plans.firstWhere((p) => p.id == _selectedPlanId).name} 시작하기',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildComparisonTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[100]),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('기능', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Basic', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Bio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Clinical', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
        _buildComparisonRow('월 측정 횟수', '10회', '30회', '무제한'),
        _buildComparisonRow('AI 코칭', '기본', '고급', '프리미엄'),
        _buildComparisonRow('가족 공유', '-', '2인', '5인'),
        _buildComparisonRow('화상 진료', '-', '-', '월 1회'),
        _buildComparisonRow('데이터 저장', '3개월', '무제한', '무제한'),
      ],
    );
  }

  TableRow _buildComparisonRow(String feature, String basic, String bio, String clinical) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(feature, style: const TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(basic, style: const TextStyle(fontSize: 11)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(bio, style: const TextStyle(fontSize: 11)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(clinical, style: const TextStyle(fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontSize: 14)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer, style: TextStyle(color: Colors.grey[600])),
        ),
      ],
    );
  }

  void _showSubscriptionConfirmDialog(SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${plan.name} 구독'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('월 ₩${plan.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'),
            const SizedBox(height: 8),
            const Text('7일 무료 체험 후 자동 결제됩니다.'),
            const SizedBox(height: 16),
            Text(
              '포함 카트리지:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
            ...plan.cartridges.map((c) => Text('• $c', style: const TextStyle(fontSize: 13))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/marketplace/checkout?plan=${plan.id}');
            },
            child: const Text('무료 체험 시작'),
          ),
        ],
      ),
    );
  }
}

// ============ 모델 ============
class SubscriptionPlan {
  final String id;
  final String name;
  final String badge;
  final int price;
  final String period;
  final Color color;
  final String description;
  final List<String> features;
  final List<String> cartridges;
  final int popularityPercent;
  final bool isPopular;
  final bool isEnterprise;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.badge,
    required this.price,
    required this.period,
    required this.color,
    required this.description,
    required this.features,
    required this.cartridges,
    required this.popularityPercent,
    this.isPopular = false,
    this.isEnterprise = false,
  });
}

// ============ 위젯 ============
class _SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onViewDetails;

  const _SubscriptionPlanCard({
    required this.plan,
    required this.isSelected,
    required this.onSelect,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? plan.color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: plan.color.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: plan.color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  // 선택 표시
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: plan.color, width: 2),
                      color: isSelected ? plan.color : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              plan.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: plan.color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                plan.badge,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (plan.isPopular) ...[
                              const SizedBox(width: 4),
                              Icon(Icons.star, size: 16, color: Colors.amber[600]),
                            ],
                          ],
                        ),
                        Text(
                          plan.description,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  // 가격
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (plan.isEnterprise)
                        const Text(
                          '협의',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      else ...[
                        Text(
                          '₩${plan.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: plan.color,
                          ),
                        ),
                        Text(
                          '/${plan.period}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // 기능 목록
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...plan.features.take(4).map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: plan.color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(feature, style: const TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  )),
                  if (plan.features.length > 4)
                    TextButton(
                      onPressed: onViewDetails,
                      child: Text('+ ${plan.features.length - 4}개 더 보기'),
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
