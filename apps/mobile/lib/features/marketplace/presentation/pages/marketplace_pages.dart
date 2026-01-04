import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 마켓플레이스 메인 페이지
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마켓플레이스'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/marketplace/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 탭
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _TabButton(
                  label: '건강용품',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _TabButton(
                  label: '카트리지',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                _TabButton(
                  label: '구독',
                  isSelected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                ),
              ],
            ),
          ),
          
          // 콘텐츠
          Expanded(
            child: [
              _buildHealthMall(),
              _buildCartridgeMall(),
              _buildSubscription(),
            ][_selectedTab],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMall() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ProductCard(
          name: '종합 비타민',
          price: '29,900원',
          rating: 4.8,
          reviews: 245,
          image: '💊',
          onTap: () {},
        ),
        _ProductCard(
          name: '오메가-3 고함량',
          price: '35,900원',
          rating: 4.6,
          reviews: 128,
          image: '🐟',
          onTap: () {},
        ),
        _ProductCard(
          name: '비타민 D3',
          price: '24,900원',
          rating: 4.9,
          reviews: 356,
          image: '☀️',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCartridgeMall() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ProductCard(
          name: '혈당 측정 카트리지 (50개)',
          price: '89,900원',
          rating: 4.7,
          reviews: 512,
          image: '🧬',
          onTap: () {},
        ),
        _ProductCard(
          name: '라돈 측정 카트리지',
          price: '149,900원',
          rating: 4.5,
          reviews: 87,
          image: '☢️',
          onTap: () {},
        ),
        _ProductCard(
          name: '수질 측정 카트리지 (10개)',
          price: '59,900원',
          rating: 4.6,
          reviews: 203,
          image: '💧',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSubscription() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SubscriptionCard(
          title: '기본 안전',
          price: '9,900원/월',
          features: ['혈당 측정 카트리지 (20개/월)', 'AI 분석', '기본 리포트'],
          onTap: () {},
        ),
        _SubscriptionCard(
          title: 'Pro',
          price: '19,900원/월',
          features: ['카트리지 무제한', 'AI 코칭', '상세 리포트', '의료진 상담'],
          onTap: () {},
          isPremium: true,
        ),
        _SubscriptionCard(
          title: '패밀리',
          price: '34,900원/월',
          features: ['최대 5명 사용', '모든 카트리지', '가족 공유', '우선 지원'],
          onTap: () {},
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final double rating;
  final int reviews;
  final String image;
  final VoidCallback onTap;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Text(image, style: const TextStyle(fontSize: 32)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text('$rating ($reviews리뷰)', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final VoidCallback onTap;
  final bool isPremium;

  const _SubscriptionCard({
    required this.title,
    required this.price,
    required this.features,
    required this.onTap,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isPremium ? Colors.blue[50] : null,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('추천', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(feature),
                ],
              ),
            )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPremium ? Colors.blue : Colors.grey[300],
                  foregroundColor: isPremium ? Colors.white : Colors.black,
                ),
                child: const Text('선택'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 장바구니 페이지
class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> items = [
    {'name': '혈당 측정 카트리지 (50개)', 'price': 89900, 'quantity': 1},
    {'name': '종합 비타민', 'price': 29900, 'quantity': 2},
  ];

  @override
  Widget build(BuildContext context) {
    final total = items.fold<int>(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item['name']),
                    subtitle: Text('${item['price']}원'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (item['quantity'] > 1) {
                                item['quantity']--;
                              }
                            });
                          },
                        ),
                        Text('${item['quantity']}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              item['quantity']++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('합계', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${total}원', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.push('/marketplace/checkout');
                  },
                  child: const Text('결제'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 주문 페이지
class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주문 현황'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _OrderCard(
            orderNumber: '#2025001',
            date: '2025-01-01',
            items: 2,
            total: '119,800원',
            status: 'delivered',
          ),
          _OrderCard(
            orderNumber: '#2024352',
            date: '2024-12-25',
            items: 1,
            total: '89,900원',
            status: 'delivered',
          ),
          _OrderCard(
            orderNumber: '#2024301',
            date: '2024-12-20',
            items: 3,
            total: '234,700원',
            status: 'cancelled',
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderNumber;
  final String date;
  final int items;
  final String total;
  final String status;

  const _OrderCard({
    required this.orderNumber,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = status == 'delivered' ? '배송완료' : '취소됨';
    final statusColor = status == 'delivered' ? Colors.green : Colors.red;

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
                Text(orderNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Text('상품 $items개 • $total', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
