import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 건강몰 페이지 - 5개 카테고리 구현
/// 기획안: /more/marketplace/health-mall
class HealthMallPage extends StatefulWidget {
  const HealthMallPage({Key? key}) : super(key: key);

  @override
  State<HealthMallPage> createState() => _HealthMallPageState();
}

class _HealthMallPageState extends State<HealthMallPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<HealthCategory> _categories = [
    HealthCategory(
      id: 'supplements',
      name: '영양제',
      icon: Icons.medication,
      color: Colors.green,
      products: [
        HealthProduct(
          id: 'vit-d-1',
          name: '비타민 D3 2000IU',
          brand: '만파식 뉴트리션',
          price: 25000,
          originalPrice: 30000,
          rating: 4.8,
          reviewCount: 1250,
          description: '혈당 관리에 도움을 주는 고함량 비타민 D',
          benefits: ['혈당 조절', '뼈 건강', '면역력'],
        ),
        HealthProduct(
          id: 'omega3-1',
          name: '오메가-3 피쉬오일 1000mg',
          brand: '만파식 뉴트리션',
          price: 35000,
          originalPrice: 42000,
          rating: 4.7,
          reviewCount: 890,
          description: '순수 EPA/DHA 함유 고품질 오메가-3',
          benefits: ['심혈관 건강', '혈중 지질', '뇌 건강'],
        ),
        HealthProduct(
          id: 'magnesium-1',
          name: '마그네슘 400mg',
          brand: '만파식 뉴트리션',
          price: 22000,
          originalPrice: 28000,
          rating: 4.9,
          reviewCount: 2100,
          description: '근육 이완과 숙면에 도움',
          benefits: ['근육 이완', '수면 개선', '혈당 조절'],
          isBestSeller: true,
        ),
        HealthProduct(
          id: 'probiotics-1',
          name: '프로바이오틱스 500억 CFU',
          brand: '만파식 뉴트리션',
          price: 45000,
          originalPrice: 55000,
          rating: 4.6,
          reviewCount: 756,
          description: '12종 유산균 복합 제제',
          benefits: ['장 건강', '면역력', '소화 개선'],
        ),
        HealthProduct(
          id: 'berberine-1',
          name: '베르베린 500mg',
          brand: '만파식 뉴트리션',
          price: 38000,
          originalPrice: 45000,
          rating: 4.7,
          reviewCount: 420,
          description: '혈당 관리를 위한 천연 식물 추출물',
          benefits: ['혈당 조절', '대사 개선'],
          isNew: true,
        ),
      ],
    ),
    HealthCategory(
      id: 'health-foods',
      name: '건강식품',
      icon: Icons.local_dining,
      color: Colors.orange,
      products: [
        HealthProduct(
          id: 'lowgi-bar-1',
          name: '저GI 프로틴바 12개입',
          brand: '만파식 푸드',
          price: 28000,
          originalPrice: 35000,
          rating: 4.5,
          reviewCount: 520,
          description: '혈당 상승이 완만한 건강 간식',
          benefits: ['저GI', '고단백', '포만감'],
        ),
        HealthProduct(
          id: 'nut-mix-1',
          name: '당뇨 친화 견과류 믹스',
          brand: '만파식 푸드',
          price: 18000,
          originalPrice: 22000,
          rating: 4.8,
          reviewCount: 890,
          description: '혈당 관리에 좋은 견과류 조합',
          benefits: ['저탄수화물', '건강한 지방', '미네랄'],
          isBestSeller: true,
        ),
        HealthProduct(
          id: 'superfood-powder-1',
          name: '슈퍼푸드 파우더',
          brand: '만파식 푸드',
          price: 42000,
          originalPrice: 50000,
          rating: 4.6,
          reviewCount: 310,
          description: '20가지 슈퍼푸드 블렌드',
          benefits: ['항산화', '에너지', '면역력'],
        ),
      ],
    ),
    HealthCategory(
      id: 'medical-devices',
      name: '의료기기',
      icon: Icons.medical_services,
      color: Colors.blue,
      products: [
        HealthProduct(
          id: 'lancet-1',
          name: '무통 채혈침 세트 (100개입)',
          brand: '만파식 메디컬',
          price: 15000,
          originalPrice: 18000,
          rating: 4.9,
          reviewCount: 3200,
          description: '0.2mm 초미세 니들로 통증 최소화',
          benefits: ['무통', '위생적', '편리함'],
          isBestSeller: true,
        ),
        HealthProduct(
          id: 'alcohol-swabs-1',
          name: '알코올 소독 솜 (200개입)',
          brand: '만파식 메디컬',
          price: 8000,
          originalPrice: 10000,
          rating: 4.8,
          reviewCount: 4500,
          description: '70% 이소프로필 알코올 함유',
          benefits: ['살균', '개별 포장', '휴대 편리'],
        ),
        HealthProduct(
          id: 'carrying-case-1',
          name: '만파식 리더기 케이스',
          brand: '만파식 액세서리',
          price: 35000,
          originalPrice: 40000,
          rating: 4.7,
          reviewCount: 890,
          description: '리더기와 카트리지 수납 가능',
          benefits: ['보호', '수납', '휴대성'],
        ),
      ],
    ),
    HealthCategory(
      id: 'sports',
      name: '운동용품',
      icon: Icons.fitness_center,
      color: Colors.red,
      products: [
        HealthProduct(
          id: 'resistance-band-1',
          name: '저항 밴드 세트 (5단계)',
          brand: '만파식 피트니스',
          price: 25000,
          originalPrice: 32000,
          rating: 4.6,
          reviewCount: 780,
          description: '집에서 할 수 있는 운동을 위한 밴드',
          benefits: ['근력 강화', '유연성', '휴대성'],
        ),
        HealthProduct(
          id: 'yoga-mat-1',
          name: '친환경 요가 매트',
          brand: '만파식 피트니스',
          price: 45000,
          originalPrice: 55000,
          rating: 4.8,
          reviewCount: 520,
          description: 'TPE 소재, 6mm 두께',
          benefits: ['친환경', '미끄럼 방지', '쿠션'],
        ),
        HealthProduct(
          id: 'smart-bottle-1',
          name: '스마트 물병 (수분 섭취 트래킹)',
          brand: '만파식 피트니스',
          price: 55000,
          originalPrice: 65000,
          rating: 4.5,
          reviewCount: 340,
          description: '수분 섭취량 자동 기록',
          benefits: ['수분 트래킹', '알림', '앱 연동'],
          isNew: true,
        ),
      ],
    ),
    HealthCategory(
      id: 'environment',
      name: '환경용품',
      icon: Icons.eco,
      color: Colors.teal,
      products: [
        HealthProduct(
          id: 'air-purifier-1',
          name: '미니 공기청정기',
          brand: '만파식 홈',
          price: 89000,
          originalPrice: 110000,
          rating: 4.7,
          reviewCount: 650,
          description: 'HEPA 필터, 개인 공간용',
          benefits: ['공기 정화', '저소음', '휴대성'],
        ),
        HealthProduct(
          id: 'water-filter-1',
          name: '휴대용 정수 필터',
          brand: '만파식 홈',
          price: 35000,
          originalPrice: 42000,
          rating: 4.6,
          reviewCount: 420,
          description: '3단 필터로 불순물 제거',
          benefits: ['정수', '휴대성', '경제적'],
        ),
        HealthProduct(
          id: 'humidity-sensor-1',
          name: '스마트 온습도계',
          brand: '만파식 홈',
          price: 28000,
          originalPrice: 35000,
          rating: 4.8,
          reviewCount: 890,
          description: '앱 연동 실시간 모니터링',
          benefits: ['온도/습도 확인', '앱 연동', '알림'],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('건강몰'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Badge(
              label: const Text('3'),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => context.go('/marketplace/cart'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((cat) {
            return Tab(
              icon: Icon(cat.icon, size: 20),
              text: cat.name,
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _buildProductList(category);
        }).toList(),
      ),
    );
  }

  Widget _buildProductList(HealthCategory category) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: category.products.length,
      itemBuilder: (context, index) {
        return _HealthProductCard(
          product: category.products[index],
          categoryColor: category.color,
          onTap: () => context.go('/marketplace/product/${category.products[index].id}'),
        );
      },
    );
  }
}

// ============ 모델 ============
class HealthCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<HealthProduct> products;

  HealthCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.products,
  });
}

class HealthProduct {
  final String id;
  final String name;
  final String brand;
  final int price;
  final int originalPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> benefits;
  final bool isBestSeller;
  final bool isNew;

  HealthProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.benefits,
    this.isBestSeller = false,
    this.isNew = false,
  });

  int get discountPercent => ((1 - price / originalPrice) * 100).round();
}

// ============ 위젯 ============
class _HealthProductCard extends StatelessWidget {
  final HealthProduct product;
  final Color categoryColor;
  final VoidCallback onTap;

  const _HealthProductCard({
    required this.product,
    required this.categoryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 영역
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.medication,
                      size: 48,
                      color: categoryColor.withOpacity(0.5),
                    ),
                  ),
                  if (product.isBestSeller)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'BEST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (product.isNew)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // 정보 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // 별점
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber[600]),
                        Text(
                          ' ${product.rating}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' (${product.reviewCount})',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // 혜택 태그
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: product.benefits.take(3).map((benefit) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            benefit,
                            style: TextStyle(
                              fontSize: 10,
                              color: categoryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    // 가격
                    Row(
                      children: [
                        if (product.discountPercent > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${product.discountPercent}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          '₩${_formatPrice(product.price)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (product.discountPercent > 0)
                          Text(
                            '₩${_formatPrice(product.originalPrice)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // 장바구니 버튼
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                    iconSize: 20,
                  ),
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart, color: categoryColor),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name}을(를) 장바구니에 담았습니다'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}
