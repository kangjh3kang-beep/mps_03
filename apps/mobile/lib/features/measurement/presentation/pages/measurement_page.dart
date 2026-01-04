import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/measurement_bloc.dart';

class MeasurementPage extends StatelessWidget {
  const MeasurementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('측정')),
      body: BlocBuilder<MeasurementBloc, MeasurementState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _MeasurementTypeSelector(),
                const SizedBox(height: 20),
                _MeasurementHistoryCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MeasurementTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final types = ['건강', '환경', '수질', '식품', '안전', '연구'];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('측정 유형 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: types.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.read<MeasurementBloc>().add(
                    MeasurementStarted(type: types[index]),
                  );
                },
                child: Card(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(types[index], textAlign: TextAlign.center),
                    ),
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

class _MeasurementHistoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('측정 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('측정 #${index + 1}'),
                  subtitle: const Text('2026-01-01 10:00'),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
