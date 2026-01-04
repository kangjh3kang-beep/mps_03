import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/telemedicine_bloc.dart';

class TelemedicinePage extends StatelessWidget {
  const TelemedicinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('화상진료')),
      body: BlocBuilder<TelemedicineSessionBloc, TelemedicineSessionState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _DoctorListCard(),
                _AppointmentCard(),
                _PrescriptionCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DoctorListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('의사 목록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text('의사 #${index + 1}'),
                  subtitle: const Text('전문의'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.read<TelemedicineSessionBloc>().add(
                        StartVideoSession(doctorId: '$index'),
                      );
                    },
                    child: const Text('상담'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('예약', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('2026-01-${index + 5} 10:00'),
                  subtitle: const Text('의사 상담 예약'),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('처방전', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('처방전 #${index + 1}'),
                  subtitle: const Text('2026-01-01 발급'),
                  trailing: const Icon(Icons.download),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
