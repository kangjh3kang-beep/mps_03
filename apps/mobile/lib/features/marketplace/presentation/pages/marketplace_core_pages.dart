import 'package:flutter/material.dart';

/// 마켓플레이스 기본 페이지들 - Phase 4 Part 1

// 마켓 메인
class MarketplaceMainPage extends StatelessWidget {
  const MarketplaceMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마켓플레이스')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 배너
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
                child: Text('신규 카트리지 20% 할인!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 24),
          // 카테고리
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategory('카트리지', Icons.science, Colors.purple),
              _buildCategory('건강식품', Icons.local_pharmacy, Colors.green),
              _buildCategory('구독', Icons.autorenew, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, IconData icon, Color color) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color)),
        const SizedBox(height: 8),
        Text(title),
      ],
    );
  }
}

// 장바구니
class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('장바구니')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                title: const Text('혈당 카트리지 (10개)'),
                subtitle: const Text('₩45,000'),
                trailing: const Text('x2'))),
        const Divider(),
        const Text('총 결제 금액: ₩90,000',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ]),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(onPressed: () {}, child: const Text('결제하기'))),
    );
  }
}

// 결제
class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('결제')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('결제 수단', style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('신용카드'),
            trailing: const Icon(Icons.check_circle, color: Colors.blue)),
        ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('카카오페이')),
      ]),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
              onPressed: () {}, child: const Text('₩90,000 결제하기'))),
    );
  }
}

// 주문내역
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주문 내역')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                  title: Text('주문 #${5 - i}'),
                  subtitle: const Text('배송 완료'),
                  trailing: const Text('₩45,000')))),
    );
  }
}

// 주문상세
class OrderDetailPage extends StatelessWidget {
  final String? orderId;
  const OrderDetailPage({super.key, this.orderId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주문 상세')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: Column(children: [
          ListTile(title: const Text('주문 상태'), trailing: const Text('배송 완료')),
          ListTile(title: const Text('결제 금액'), trailing: const Text('₩45,000'))
        ]))
      ]),
    );
  }
}

// 배송추적
class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배송 추적')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _step('주문 접수', true),
        _step('결제 완료', true),
        _step('배송 중', true),
        _step('배송 완료', false),
      ]),
    );
  }

  Widget _step(String t, bool done) => ListTile(
      leading: Icon(done ? Icons.check_circle : Icons.circle_outlined,
          color: done ? Colors.green : Colors.grey),
      title: Text(t));
}

// 반품
class ReturnsPage extends StatelessWidget {
  const ReturnsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('반품/교환')),
        body: Center(
            child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.assignment_return),
                label: const Text('반품 신청'))));
  }
}

// 리뷰
class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 리뷰')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                  leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                          5,
                          (j) => Icon(Icons.star,
                              size: 14,
                              color: j < 4 ? Colors.amber : Colors.grey))),
                  title: const Text('좋은 제품입니다')))),
    );
  }
}

// 위시리스트
class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('위시리스트')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 3,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                  title: Text('상품 ${i + 1}'),
                  trailing: IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {})))),
    );
  }
}
