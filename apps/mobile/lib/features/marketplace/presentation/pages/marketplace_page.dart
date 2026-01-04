import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/marketplace_bloc.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마켓플레이스')),
      body: BlocBuilder<CartridgeMallBloc, CartridgeMallState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _CategorySelector(),
                _CartridgeListCard(),
                _SubscriptionCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = ['건강', '환경', '수질', '식품', '안전'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: categories.map((cat) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(cat),
                onSelected: (selected) {
                  context.read<CartridgeMallBloc>().add(
                    FilterByCategory(category: cat),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CartridgeListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('카트리지', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('카트리지 #${index + 1}'),
                  subtitle: const Text('¥ 99,000'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('구매'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('구독 플랜', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _SubscriptionPlan(
              name: '기본',
              price: '9,900',
              features: ['월 10회 측정', '기본 AI 코칭'],
            ),
            const SizedBox(height: 12),
            _SubscriptionPlan(
              name: '프리미엄',
              price: '19,900',
              features: ['무제한 측정', '고급 AI 코칭', '화상진료'],
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionPlan extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;

  const _SubscriptionPlan({
    required this.name,
    required this.price,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('¥$price', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.check, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Text(f),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
