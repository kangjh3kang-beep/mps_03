import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 카트리지몰 페이지 - 7개 탭 구현
/// 기획안: /more/marketplace/cartridge-mall
class CartridgeMallPage extends StatefulWidget {
  const CartridgeMallPage({Key? key}) : super(key: key);

  @override
  State<CartridgeMallPage> createState() => _CartridgeMallPageState();
}

class _CartridgeMallPageState extends State<CartridgeMallPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<CartridgeCategory> _categories = [
    CartridgeCategory(
      id: 'health',
      name: '건강',
      icon: Icons.favorite,
      color: Colors.red,
      products: [
        CartridgeProduct(
          id: 'glucose-1',
          name: '혈당 측정 카트리지',
          price: 8000,
          packOptions: ['1개', '10개', '30개'],
          description: '정밀한 혈당 측정용 바이오센서 카트리지',
          accuracy: '±5%',
          measuresPerCartridge: 1,
        ),
        CartridgeProduct(
          id: 'ketone-1',
          name: '케톤체 측정 카트리지',
          price: 12000,
          packOptions: ['1개', '10개'],
          description: '혈중 케톤체 농도 측정용',
          accuracy: '±10%',
          measuresPerCartridge: 1,
        ),
        CartridgeProduct(
          id: 'cholesterol-1',
          name: '콜레스테롤 측정 카트리지',
          price: 15000,
          packOptions: ['1개', '5개'],
          description: '총 콜레스테롤, HDL, LDL 측정',
          accuracy: '±5%',
          measuresPerCartridge: 1,
        ),
        CartridgeProduct(
          id: 'lactate-1',
          name: '젖산 측정 카트리지',
          price: 10000,
          packOptions: ['1개', '10개'],
          description: '운동 시 젖산 수치 추적',
          accuracy: '±5%',
          measuresPerCartridge: 1,
        ),
        CartridgeProduct(
          id: 'uric-acid-1',
          name: '요산 측정 카트리지',
          price: 12000,
          packOptions: ['1개', '10개'],
          description: '통풍 예방을 위한 요산 측정',
          accuracy: '±5%',
          measuresPerCartridge: 1,
        ),
        CartridgeProduct(
          id: 'metabolic-panel',
          name: '대사 패널 (5종)',
          price: 25000,
          packOptions: ['1세트'],
          description: '혈당, 케톤, 콜레스테롤, 젖산, 요산 종합',
          accuracy: '±5%',
          measuresPerCartridge: 5,
          isBestSeller: true,
        ),
      ],
    ),
    CartridgeCategory(
      id: 'environment',
      name: '환경',
      icon: Icons.eco,
      color: Colors.green,
      products: [
        CartridgeProduct(
          id: 'radon-1',
          name: '라돈 측정 카트리지',
          price: 35000,
          packOptions: ['1개'],
          description: '실내 라돈 농도 정밀 측정',
          accuracy: '±10%',
          measuresPerCartridge: 1,
        ),
        CartridgeProduct(
          id: 'vocs-1',
          name: 'VOCs 측정 카트리지',
          price: 25000,
          packOptions: ['1개', '5개'],
          description: '휘발성 유기화합물 측정',
          accuracy: '±15%',
          measuresPerCartridge: 10,
        ),
        CartridgeProduct(
          id: 'co2-1',
          name: 'CO2 측정 카트리지',
          price: 15000,
          packOptions: ['1개', '5개'],
          description: '이산화탄소 농도 측정',
          accuracy: '±5%',
          measuresPerCartridge: 50,
        ),
        CartridgeProduct(
          id: 'air-quality-panel',
          name: '실내공기질 패널',
          price: 30000,
          packOptions: ['1세트'],
          description: 'VOCs, CO2, 미세먼지 종합',
          accuracy: '±10%',
          measuresPerCartridge: 10,
          isBestSeller: true,
        ),
      ],
    ),
    CartridgeCategory(
      id: 'water',
      name: '수질',
      icon: Icons.water_drop,
      color: Colors.blue,
      products: [
        CartridgeProduct(
          id: 'ph-1',
          name: 'pH 측정 카트리지',
          price: 10000,
          packOptions: ['1개', '10개'],
          description: '물의 산도/알칼리도 측정',
          accuracy: '±0.1',
          measuresPerCartridge: 50,
        ),
        CartridgeProduct(
          id: 'heavy-metals-1',
          name: '중금속 측정 카트리지',
          price: 20000,
          packOptions: ['1개', '5개'],
          description: '납, 수은, 카드뮴 등 검출',
          accuracy: '±10ppb',
          measuresPerCartridge: 10,
        ),
        CartridgeProduct(
          id: 'chlorine-1',
          name: '잔류염소 측정 카트리지',
          price: 12000,
          packOptions: ['1개', '10개'],
          description: '수돗물 소독제 잔류량',
          accuracy: '±0.05ppm',
          measuresPerCartridge: 20,
        ),
      ],
    ),
    CartridgeCategory(
      id: 'food',
      name: '식품',
      icon: Icons.restaurant,
      color: Colors.orange,
      products: [
        CartridgeProduct(
          id: 'pesticide-1',
          name: '잔류농약 검사 카트리지',
          price: 20000,
          packOptions: ['1개', '5개'],
          description: '과일, 채소의 농약 잔류 검사',
          accuracy: '99%',
          measuresPerCartridge: 5,
        ),
        CartridgeProduct(
          id: 'pathogen-1',
          name: '식중독균 검사 카트리지',
          price: 25000,
          packOptions: ['1개', '5개'],
          description: '살모넬라, 대장균 등 검출',
          accuracy: '99.5%',
          measuresPerCartridge: 3,
        ),
        CartridgeProduct(
          id: 'allergen-1',
          name: '알레르겐 검사 카트리지',
          price: 30000,
          packOptions: ['1개', '5개'],
          description: '땅콩, 글루텐, 유제품 등',
          accuracy: '99%',
          measuresPerCartridge: 5,
        ),
      ],
    ),
    CartridgeCategory(
      id: 'safety',
      name: '안전',
      icon: Icons.security,
      color: Colors.purple,
      products: [
        CartridgeProduct(
          id: 'drug-detection-1',
          name: '음료 약물 검사 카트리지',
          price: 40000,
          packOptions: ['1개', '3개'],
          description: 'GHB, 로히프놀, 케타민 검출',
          accuracy: '99%',
          measuresPerCartridge: 3,
          isBestSeller: true,
        ),
      ],
    ),
    CartridgeCategory(
      id: 'research',
      name: '연구용',
      icon: Icons.science,
      color: Colors.teal,
      products: [
        CartridgeProduct(
          id: 'custom-biomarker-1',
          name: '맞춤형 바이오마커 카트리지',
          price: 50000,
          packOptions: ['커스텀'],
          description: '연구 목적 맞춤 제작',
          accuracy: '연구용',
          measuresPerCartridge: 1,
          isCustomizable: true,
        ),
        CartridgeProduct(
          id: 'research-panel',
          name: '연구용 멀티마커 패널',
          price: 200000,
          packOptions: ['1세트'],
          description: '최대 20개 바이오마커 동시 측정',
          accuracy: '연구용',
          measuresPerCartridge: 1,
        ),
      ],
    ),
    CartridgeCategory(
      id: 'third-party',
      name: '서드파티',
      icon: Icons.extension,
      color: Colors.grey,
      products: [],
      isThirdParty: true,
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
        title: const Text('카트리지몰'),
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
          if (category.isThirdParty) {
            return _buildThirdPartyTab();
          }
          return _buildProductGrid(category);
        }).toList(),
      ),
    );
  }

  Widget _buildProductGrid(CartridgeCategory category) {
    if (category.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('상품 준비 중입니다', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: category.products.length,
      itemBuilder: (context, index) {
        return _CartridgeProductCard(
          product: category.products[index],
          categoryColor: category.color,
          onTap: () => context.go('/marketplace/cartridge/${category.products[index].id}'),
        );
      },
    );
  }

  Widget _buildThirdPartyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Developer SDK 배너
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[400]!, Colors.blue[600]!],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.code, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Text(
                      'Developer SDK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '만파식 플랫폼에서 동작하는\n나만의 카트리지를 개발하세요',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple,
                  ),
                  child: const Text('개발자 등록하기'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 개발 가이드
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.blue),
              title: const Text('개발자 가이드'),
              subtitle: const Text('SDK 문서 및 튜토리얼'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.api, color: Colors.green),
              title: const Text('API 레퍼런스'),
              subtitle: const Text('카트리지 인터페이스 명세'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.verified, color: Colors.amber),
              title: const Text('인증 프로그램'),
              subtitle: const Text('공식 인증 카트리지 등록'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),

          // 서드파티 카트리지 목록 (샘플)
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '인증된 서드파티 카트리지',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          _ThirdPartyProductCard(
            name: '애완동물 건강 패널',
            developer: 'PetHealth Corp',
            rating: 4.8,
            downloads: 1200,
            isVerified: true,
          ),
          const SizedBox(height: 12),
          _ThirdPartyProductCard(
            name: '식물 영양소 분석기',
            developer: 'GreenTech Labs',
            rating: 4.5,
            downloads: 850,
            isVerified: true,
          ),
          const SizedBox(height: 12),
          _ThirdPartyProductCard(
            name: '스포츠 퍼포먼스 분석',
            developer: 'AthleteAI',
            rating: 4.7,
            downloads: 2100,
            isVerified: true,
          ),
        ],
      ),
    );
  }
}

// ============ 모델 ============
class CartridgeCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<CartridgeProduct> products;
  final bool isThirdParty;

  CartridgeCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.products,
    this.isThirdParty = false,
  });
}

class CartridgeProduct {
  final String id;
  final String name;
  final int price;
  final List<String> packOptions;
  final String description;
  final String accuracy;
  final int measuresPerCartridge;
  final bool isBestSeller;
  final bool isCustomizable;

  CartridgeProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.packOptions,
    required this.description,
    required this.accuracy,
    required this.measuresPerCartridge,
    this.isBestSeller = false,
    this.isCustomizable = false,
  });
}

// ============ 위젯 ============
class _CartridgeProductCard extends StatelessWidget {
  final CartridgeProduct product;
  final Color categoryColor;
  final VoidCallback onTap;

  const _CartridgeProductCard({
    required this.product,
    required this.categoryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Stack(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Icon(
                    Icons.science,
                    size: 48,
                    color: categoryColor.withOpacity(0.5),
                  ),
                ),
                if (product.isBestSeller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'BEST',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // 정보 영역
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '정확도: ${product.accuracy}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₩${product.price.toString().replaceAllMapped(
                            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                            (match) => '${match[1]},',
                          )}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                        Icon(
                          Icons.add_shopping_cart,
                          size: 20,
                          color: categoryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThirdPartyProductCard extends StatelessWidget {
  final String name;
  final String developer;
  final double rating;
  final int downloads;
  final bool isVerified;

  const _ThirdPartyProductCard({
    required this.name,
    required this.developer,
    required this.rating,
    required this.downloads,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.extension, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, size: 16, color: Colors.blue[600]),
                      ],
                    ],
                  ),
                  Text(
                    developer,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber[600]),
                      Text(' $rating', style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 12),
                      Icon(Icons.download, size: 14, color: Colors.grey[600]),
                      Text(' $downloads', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('설치'),
            ),
          ],
        ),
      ),
    );
  }
}
