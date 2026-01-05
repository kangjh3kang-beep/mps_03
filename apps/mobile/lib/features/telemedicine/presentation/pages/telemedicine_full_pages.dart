import 'package:flutter/material.dart';

/// 화상진료 페이지들 - Phase 4

// 진료메인
class TelemedicineMainPage extends StatelessWidget {
  const TelemedicineMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('화상 진료')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('김OO 전문의'),
                subtitle: const Text('내분비내과'),
                trailing:
                    ElevatedButton(onPressed: () {}, child: const Text('예약')))),
        Card(
            child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('이OO 전문의'),
                subtitle: const Text('가정의학과'),
                trailing:
                    ElevatedButton(onPressed: () {}, child: const Text('예약')))),
      ]),
    );
  }
}

// 예약
class AppointmentBookingPage extends StatelessWidget {
  const AppointmentBookingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('진료 예약')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('날짜 선택', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
            spacing: 8,
            children: ['1/6', '1/7', '1/8']
                .map((d) => ChoiceChip(
                    label: Text(d), selected: d == '1/6', onSelected: (_) {}))
                .toList()),
        const SizedBox(height: 16),
        const Text('시간 선택', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
            spacing: 8,
            children: ['10:00', '14:00', '16:00']
                .map((t) => ChoiceChip(
                    label: Text(t), selected: false, onSelected: (_) {}))
                .toList()),
      ]),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(onPressed: () {}, child: const Text('예약 확정'))),
    );
  }
}

// 예약내역
class AppointmentsListPage extends StatelessWidget {
  const AppointmentsListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('예약 내역')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 3,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                  title: Text('진료 예약 #${3 - i}'),
                  subtitle: Text('2026.01.${6 + i}'),
                  trailing: Text(i == 0 ? '예정' : '완료',
                      style: TextStyle(
                          color: i == 0 ? Colors.blue : Colors.green))))),
    );
  }
}

// 진료실
class VideoConsultationPage extends StatelessWidget {
  const VideoConsultationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.videocam, size: 100, color: Colors.white),
        const SizedBox(height: 16),
        const Text('화상 진료 대기 중...',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 32),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              icon: const Icon(Icons.mic_off, color: Colors.white),
              onPressed: () {}),
          const SizedBox(width: 24),
          IconButton(
              icon: const Icon(Icons.call_end, color: Colors.red),
              onPressed: () {}),
          const SizedBox(width: 24),
          IconButton(
              icon: const Icon(Icons.videocam_off, color: Colors.white),
              onPressed: () {})
        ])
      ])),
    );
  }
}

// 의사프로필
class DoctorProfilePage extends StatelessWidget {
  final String? doctorId;
  const DoctorProfilePage({super.key, this.doctorId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('의료진 프로필')),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            const Text('김OO 전문의',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('내분비내과'),
            const SizedBox(height: 24),
            Card(
                child: Column(children: [
              ListTile(title: const Text('경력'), subtitle: const Text('20년')),
              ListTile(title: const Text('학력'), subtitle: const Text('서울대 의대'))
            ]))
          ])),
    );
  }
}

// 채팅상담
class DoctorChatPage extends StatelessWidget {
  const DoctorChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('채팅 상담')),
      body: Column(children: [
        Expanded(
            child: ListView(padding: const EdgeInsets.all(16), children: [
          _msg('안녕하세요. 문의하실 내용이 있으신가요?', false),
          _msg('네, 혈당 관리에 대해 상담받고 싶습니다.', true)
        ])),
        Container(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Expanded(
                  child: TextField(
                      decoration: const InputDecoration(
                          hintText: '메시지 입력...',
                          border: OutlineInputBorder()))),
              IconButton(icon: const Icon(Icons.send), onPressed: () {})
            ]))
      ]),
    );
  }

  Widget _msg(String t, bool me) => Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: me ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(12)),
          child: Text(t,
              style: TextStyle(color: me ? Colors.white : Colors.black))));
}

// 처방전
class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('처방전')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 2,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                  leading: const Icon(Icons.description),
                  title: Text('처방전 #${2 - i}'),
                  subtitle: const Text('2026.01.05'),
                  trailing: IconButton(
                      icon: const Icon(Icons.download), onPressed: () {})))),
    );
  }
}

// 진료기록
class MedicalRecordsPage extends StatelessWidget {
  const MedicalRecordsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('진료 기록')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                  title: Text('진료 기록 #${5 - i}'),
                  subtitle: Text('2026.01.${5 - i}')))),
    );
  }
}

// 병원찾기
class HospitalFinderPage extends StatelessWidget {
  const HospitalFinderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('병원 찾기')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('서울대학교병원'),
                subtitle: const Text('서울특별시 종로구'))),
        Card(
            child: ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('삼성서울병원'),
                subtitle: const Text('서울특별시 강남구')))
      ]),
    );
  }
}

// 증상체커
class SymptomCheckerPage extends StatelessWidget {
  const SymptomCheckerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('증상 체커')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('어떤 증상이 있으신가요?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['두통', '피로감', '어지러움', '갈증', '체중변화', '시력변화']
                .map((s) => FilterChip(label: Text(s), onSelected: (_) {}))
                .toList())
      ]),
    );
  }
}

// 건강다이어리
class HealthDiaryPage extends StatelessWidget {
  const HealthDiaryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('건강 다이어리')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 7,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                  title: Text('1월 ${5 - i}일'),
                  subtitle: const Text('오늘 컨디션 좋음')))),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}

// 보험청구
class InsuranceClaimPage extends StatelessWidget {
  const InsuranceClaimPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('보험 청구')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('보험 청구 안내',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('• 진료비 영수증 첨부 필요\n• 처리 기간: 3-5 영업일')
                    ]))),
        const SizedBox(height: 16),
        ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload),
            label: const Text('청구하기'))
      ]),
    );
  }
}

// 응급서비스
class EmergencyServicesPage extends StatelessWidget {
  const EmergencyServicesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('응급 서비스'), backgroundColor: Colors.red),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.emergency, size: 80, color: Colors.red),
        const SizedBox(height: 16),
        const Text('응급 상황인가요?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            icon: const Icon(Icons.phone),
            label: const Text('119 연결'))
      ])),
    );
  }
}

// 약국찾기
class PharmacyFinderPage extends StatelessWidget {
  const PharmacyFinderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('약국 찾기')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                leading: const Icon(Icons.local_pharmacy),
                title: const Text('건강약국'),
                subtitle: const Text('서울 강남구 • 500m'))),
        Card(
            child: ListTile(
                leading: const Icon(Icons.local_pharmacy),
                title: const Text('행복약국'),
                subtitle: const Text('서울 강남구 • 800m')))
      ]),
    );
  }
}

// 라이브러리
class HealthLibraryPage extends StatelessWidget {
  const HealthLibraryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('건강 라이브러리')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                title: const Text('당뇨병 관리 가이드'),
                subtitle: const Text('혈당 조절의 모든 것'))),
        Card(
            child: ListTile(
                title: const Text('건강한 식습관'), subtitle: const Text('영양과 당뇨'))),
        Card(
            child: ListTile(
                title: const Text('운동과 혈당'), subtitle: const Text('효과적인 운동법')))
      ]),
    );
  }
}
