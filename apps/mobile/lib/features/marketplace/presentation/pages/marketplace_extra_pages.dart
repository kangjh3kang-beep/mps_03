import 'package:flutter/material.dart';

/// 마켓플레이스 추가 페이지들 - Phase 4 Part 2

// 특가
class DealsPage extends StatelessWidget {
  const DealsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('특가 상품'), backgroundColor: Colors.red),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                  leading: Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.red,
                      child: Text('${20 + i * 5}%',
                          style: const TextStyle(color: Colors.white))),
                  title: Text('특가 상품 ${i + 1}')))),
    );
  }
}

// 번들
class BundlesPage extends StatelessWidget {
  const BundlesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('번들 패키지')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _bundle('스타터', '₩199,000'),
        _bundle('프리미엄', '₩399,000'),
      ]),
    );
  }

  Widget _bundle(String n, String p) => Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
          title: Text('$n 패키지'),
          trailing:
              Text(p, style: const TextStyle(fontWeight: FontWeight.bold))));
}

// 로열티
class LoyaltyProgramPage extends StatelessWidget {
  const LoyaltyProgramPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로열티 프로그램')),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
            Icon(Icons.workspace_premium, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text('골드 회원',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('12,500 포인트')
          ])),
    );
  }
}

// 리워드
class RewardsStorePage extends StatelessWidget {
  const RewardsStorePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('리워드 스토어')),
      body: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _reward('카트리지 5개', '5,000P'),
            _reward('구독권 1개월', '10,000P')
          ]),
    );
  }

  Widget _reward(String n, String p) => Card(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.card_giftcard, size: 40, color: Colors.purple),
        const SizedBox(height: 8),
        Text(n),
        Text(p, style: const TextStyle(fontWeight: FontWeight.bold))
      ]));
}

// 기프트카드
class GiftCardsPage extends StatelessWidget {
  const GiftCardsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기프트카드')),
      body: ListView(
          padding: const EdgeInsets.all(16),
          children: ['₩10,000', '₩30,000', '₩50,000']
              .map((a) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                      leading: const Icon(Icons.card_giftcard),
                      title: Text(a),
                      trailing: ElevatedButton(
                          onPressed: () {}, child: const Text('구매')))))
              .toList()),
    );
  }
}

// 고객지원
class MarketplaceSupportPage extends StatelessWidget {
  const MarketplaceSupportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('고객 지원')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ListTile(leading: const Icon(Icons.chat), title: const Text('실시간 채팅')),
        ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('전화 상담'),
            subtitle: const Text('1588-0000')),
        ListTile(leading: const Icon(Icons.email), title: const Text('이메일 문의'))
      ]),
    );
  }
}

// 인보이스
class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('인보이스'), actions: [
        IconButton(icon: const Icon(Icons.download), onPressed: () {})
      ]),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
              child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('인보이스',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('번호: INV-20260105-001'),
                        Divider(height: 32),
                        Text('합계: ₩145,000',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))
                      ])))),
    );
  }
}

// 구독상세
class SubscriptionDetailPage extends StatelessWidget {
  final String? subscriptionId;
  const SubscriptionDetailPage({super.key, this.subscriptionId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('구독 상세')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: Column(children: [
          ListTile(
              title: const Text('프리미엄 구독'), subtitle: const Text('월 ₩39,000')),
          ListTile(
              title: const Text('다음 결제'), trailing: const Text('2026.02.01'))
        ]))
      ]),
    );
  }
}
