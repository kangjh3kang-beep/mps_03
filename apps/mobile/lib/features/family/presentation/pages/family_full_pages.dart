import 'package:flutter/material.dart';

/// 가족 공유 페이지들 - Phase 5

// 가족 메인
class FamilyMainPage extends StatelessWidget {
  const FamilyMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('가족 공유')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  const Icon(Icons.family_restroom,
                      size: 48, color: Colors.blue),
                  const SizedBox(height: 12),
                  const Text('우리 가족',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('3명의 가족 구성원')
                ]))),
        const SizedBox(height: 16),
        _member('홍길동', '나', Colors.blue),
        _member('김영희', '배우자', Colors.pink),
        _member('홍철수', '아들', Colors.green),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: const Icon(Icons.person_add)),
    );
  }

  Widget _member(String n, String r, Color c) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
          leading: CircleAvatar(
              backgroundColor: c.withOpacity(0.1),
              child: Icon(Icons.person, color: c)),
          title: Text(n),
          subtitle: Text(r)));
}

// 멤버초대
class InviteMemberPage extends StatelessWidget {
  const InviteMemberPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('구성원 초대')),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const TextField(
                decoration: InputDecoration(
                    labelText: '이메일 주소', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            DropdownButtonFormField(
                decoration: const InputDecoration(
                    labelText: '관계', border: OutlineInputBorder()),
                items: ['배우자', '부모님', '자녀', '형제']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (_) {}),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: const Text('초대 보내기'))
          ])),
    );
  }
}

// 권한관리
class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('권한 관리')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _perm('김영희', '혈당 데이터 보기', true),
        _perm('김영희', '알림 받기', true),
        _perm('홍철수', '혈당 데이터 보기', true),
        _perm('홍철수', '알림 받기', false)
      ]),
    );
  }

  Widget _perm(String n, String p, bool v) =>
      SwitchListTile(title: Text('$n - $p'), value: v, onChanged: (_) {});
}

// 공유대시보드
class SharedDashboardPage extends StatelessWidget {
  const SharedDashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공유 대시보드')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _member('홍길동', '혈당: 95 mg/dL', Colors.green),
        _member('김영희', '혈당: 102 mg/dL', Colors.orange),
        _member('홍철수', '혈당: 88 mg/dL', Colors.green)
      ]),
    );
  }

  Widget _member(String n, String v, Color c) => Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
          leading: CircleAvatar(
              backgroundColor: c.withOpacity(0.1),
              child: Icon(Icons.person, color: c)),
          title: Text(n),
          subtitle: Text(v),
          trailing: Icon(Icons.circle, color: c, size: 12)));
}

// 응급연락처
class EmergencyContactsPage extends StatelessWidget {
  const EmergencyContactsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('응급 연락처')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.red),
                title: const Text('119 응급서비스'))),
        Card(
            child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('김영희 (배우자)'),
                subtitle: const Text('010-1234-5678'))),
        Card(
            child: ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('담당 의료진'),
                subtitle: const Text('김OO 내분비내과')))
      ]),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}

// 가족알림
class FamilyAlertsPage extends StatelessWidget {
  const FamilyAlertsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('가족 알림')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _alert('홍길동님 혈당 측정 완료', '95 mg/dL', '5분 전'),
        _alert('김영희님 주의 알림', '혈당 상승 감지', '1시간 전'),
        _alert('홍철수님 측정 완료', '88 mg/dL', '3시간 전')
      ]),
    );
  }

  Widget _alert(String t, String s, String time) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
          title: Text(t),
          subtitle: Text(s),
          trailing: Text(time, style: TextStyle(color: Colors.grey[600]))));
}

// 가족리포트
class FamilyReportsPage extends StatelessWidget {
  const FamilyReportsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('가족 리포트')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('주간 가족 건강 리포트',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('모든 가족 구성원이 정상 범위를 유지하고 있습니다.')
                    ]))),
        const SizedBox(height: 16),
        ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('리포트 다운로드'))
      ]),
    );
  }
}

// 가족채팅
class FamilyChatPage extends StatelessWidget {
  const FamilyChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('가족 채팅')),
      body: Column(children: [
        Expanded(
            child: ListView(padding: const EdgeInsets.all(16), children: [
          _msg('오늘 측정 결과 좋아요!', '김영희', false),
          _msg('고마워요~', '나', true)
        ])),
        Container(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Expanded(
                  child: TextField(
                      decoration: const InputDecoration(
                          hintText: '메시지...', border: OutlineInputBorder()))),
              IconButton(icon: const Icon(Icons.send), onPressed: () {})
            ]))
      ]),
    );
  }

  Widget _msg(String t, String u, bool me) => Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: me ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(12)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!me)
              Text(u,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: me ? Colors.white : Colors.grey[700])),
            Text(t, style: TextStyle(color: me ? Colors.white : Colors.black))
          ])));
}

// 멤버상세
class MemberDetailPage extends StatelessWidget {
  final String? memberId;
  const MemberDetailPage({super.key, this.memberId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('구성원 상세')),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            const Text('김영희',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('배우자'),
            const SizedBox(height: 24),
            Card(
                child: Column(children: [
              ListTile(
                  title: const Text('최근 혈당'),
                  trailing: const Text('102 mg/dL')),
              ListTile(
                  title: const Text('평균 혈당'), trailing: const Text('96 mg/dL'))
            ]))
          ])),
    );
  }
}

// 돌봄모드
class CaregiverModePage extends StatelessWidget {
  const CaregiverModePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('돌봄 모드')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            color: Colors.blue.withOpacity(0.1),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: const [
                  Icon(Icons.favorite, size: 48, color: Colors.blue),
                  SizedBox(height: 12),
                  Text('돌봄 모드 활성화',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 4),
                  Text('가족 구성원의 건강을 실시간으로 모니터링합니다')
                ]))),
        const SizedBox(height: 16),
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('위험 알림')),
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('측정 알림')),
        SwitchListTile(
            value: false, onChanged: (_) {}, title: const Text('야간 알림'))
      ]),
    );
  }
}

// 공유설정
class SharingSettingsPage extends StatelessWidget {
  const SharingSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공유 설정')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('혈당 데이터 공유')),
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('측정 알림 공유')),
        SwitchListTile(
            value: false, onChanged: (_) {}, title: const Text('위치 정보 공유')),
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('응급 상황 알림'))
      ]),
    );
  }
}

// 가족활동
class FamilyActivityLogPage extends StatelessWidget {
  const FamilyActivityLogPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('가족 활동 기록')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 10,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('활동 ${10 - i}'),
                  subtitle: Text('${i + 1}시간 전')))),
    );
  }
}
