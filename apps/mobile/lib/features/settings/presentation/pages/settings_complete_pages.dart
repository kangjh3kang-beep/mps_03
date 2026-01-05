import 'package:flutter/material.dart';

/// 설정 페이지들 - Phase 5

// 설정 메인
class SettingsMainPage extends StatelessWidget {
  const SettingsMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _section('계정', [
          _item('프로필', Icons.person),
          _item('보안', Icons.security),
          _item('개인정보', Icons.privacy_tip),
        ]),
        _section('앱', [
          _item('알림', Icons.notifications),
          _item('데이터', Icons.storage),
          _item('디스플레이', Icons.display_settings),
          _item('언어', Icons.language),
        ]),
        _section('기타', [
          _item('도움말', Icons.help),
          _item('피드백', Icons.feedback),
          _item('앱 정보', Icons.info),
        ]),
        const SizedBox(height: 24),
        OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('로그아웃')),
      ]),
    );
  }

  Widget _section(String t, List<Widget> items) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(t,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey))),
        ...items,
        const SizedBox(height: 16)
      ]);
  Widget _item(String t, IconData i) => Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
          leading: Icon(i),
          title: Text(t),
          trailing: const Icon(Icons.chevron_right)));
}

// 프로필
class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(
            child: Stack(children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 16),
                      color: Colors.white,
                      onPressed: () {})))
        ])),
        const SizedBox(height: 24),
        const TextField(
            decoration:
                InputDecoration(labelText: '이름', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        const TextField(
            decoration: InputDecoration(
                labelText: '이메일', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        const TextField(
            decoration: InputDecoration(
                labelText: '전화번호', border: OutlineInputBorder())),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () {}, child: const Text('저장'))
      ]),
    );
  }
}

// 보안
class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('보안')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('비밀번호 변경'),
            trailing: const Icon(Icons.chevron_right)),
        ListTile(
            leading: const Icon(Icons.security),
            title: const Text('2단계 인증'),
            trailing: Switch(value: true, onChanged: (_) {})),
        ListTile(
            leading: const Icon(Icons.phone_android),
            title: const Text('기기 관리'),
            trailing: const Icon(Icons.chevron_right)),
        ListTile(
            leading: const Icon(Icons.history),
            title: const Text('로그인 기록'),
            trailing: const Icon(Icons.chevron_right))
      ]),
    );
  }
}

// 개인정보
class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('개인정보')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('데이터 수집 동의')),
        SwitchListTile(
            value: false, onChanged: (_) {}, title: const Text('마케팅 정보 수신')),
        ListTile(
            title: const Text('개인정보 처리방침'),
            trailing: const Icon(Icons.chevron_right)),
        ListTile(
            title: const Text('데이터 다운로드'),
            trailing: const Icon(Icons.download)),
        ListTile(
            title: const Text('계정 삭제'),
            trailing: const Icon(Icons.delete, color: Colors.red))
      ]),
    );
  }
}

// 알림
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림 설정')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('푸시 알림')),
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('측정 알림')),
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('위험 알림')),
        SwitchListTile(
            value: false, onChanged: (_) {}, title: const Text('마케팅 알림')),
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('가족 알림'))
      ]),
    );
  }
}

// 데이터관리
class DataManagementPage extends StatelessWidget {
  const DataManagementPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('데이터 관리')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('저장된 데이터',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('측정 기록: 1,234건'),
                      Text('캐시 데이터: 45MB')
                    ]))),
        const SizedBox(height: 16),
        ListTile(title: const Text('데이터 동기화')),
        ListTile(title: const Text('데이터 내보내기')),
        ListTile(
            title: const Text('캐시 삭제'),
            trailing: const Icon(Icons.delete_outline)),
        ListTile(
            title: const Text('모든 데이터 삭제'),
            trailing: const Icon(Icons.delete, color: Colors.red))
      ]),
    );
  }
}

// 디스플레이
class DisplaySettingsPage extends StatelessWidget {
  const DisplaySettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('디스플레이')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SwitchListTile(
            value: false, onChanged: (_) {}, title: const Text('다크 모드')),
        ListTile(
            title: const Text('글꼴 크기'),
            subtitle: Slider(value: 0.5, onChanged: (_) {})),
        ListTile(
            title: const Text('테마 색상'),
            trailing: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle)))
      ]),
    );
  }
}

// 언어
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('언어')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        RadioListTile(
            value: 'ko',
            groupValue: 'ko',
            onChanged: (_) {},
            title: const Text('한국어')),
        RadioListTile(
            value: 'en',
            groupValue: 'ko',
            onChanged: (_) {},
            title: const Text('English')),
        RadioListTile(
            value: 'ja',
            groupValue: 'ko',
            onChanged: (_) {},
            title: const Text('日本語')),
        RadioListTile(
            value: 'zh',
            groupValue: 'ko',
            onChanged: (_) {},
            title: const Text('中文'))
      ]),
    );
  }
}

// 도움말
class HelpSettingsPage extends StatelessWidget {
  const HelpSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도움말')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ListTile(leading: const Icon(Icons.book), title: const Text('사용 가이드')),
        ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('자주 묻는 질문')),
        ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('튜토리얼 동영상')),
        ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('고객 지원'))
      ]),
    );
  }
}

// 피드백
class FeedbackSettingsPage extends StatelessWidget {
  const FeedbackSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('피드백')),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const Text('앱 사용 경험은 어떠셨나요?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    5,
                    (i) => IconButton(
                        icon: Icon(Icons.star,
                            color: i < 4 ? Colors.amber : Colors.grey[300],
                            size: 36),
                        onPressed: () {}))),
            const SizedBox(height: 24),
            const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: '의견을 남겨주세요', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('제출'))
          ])),
    );
  }
}

// 앱 정보
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('앱 정보')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(
            child: Column(children: const [
          Icon(Icons.medical_services, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text('MPS 만파식',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('버전 1.0.0')
        ])),
        const SizedBox(height: 32),
        ListTile(title: const Text('이용약관')),
        ListTile(title: const Text('개인정보 처리방침')),
        ListTile(title: const Text('오픈소스 라이선스')),
        const SizedBox(height: 24),
        Center(
            child: Text('© 2026 MPS Corp.',
                style: TextStyle(color: Colors.grey[600])))
      ]),
    );
  }
}

// 기기관리
class DeviceManagementPage extends StatelessWidget {
  const DeviceManagementPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기기 관리')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                leading: const Icon(Icons.bluetooth),
                title: const Text('MPS Reader v2'),
                subtitle: const Text('연결됨'),
                trailing: const Icon(Icons.check_circle, color: Colors.green))),
        const SizedBox(height: 16),
        ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('새 기기 연결'))
      ]),
    );
  }
}

// 측정 단위
class UnitSettingsPage extends StatelessWidget {
  const UnitSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('측정 단위')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('혈당 단위', style: TextStyle(fontWeight: FontWeight.bold)),
        RadioListTile(
            value: 'mg',
            groupValue: 'mg',
            onChanged: (_) {},
            title: const Text('mg/dL')),
        RadioListTile(
            value: 'mmol',
            groupValue: 'mg',
            onChanged: (_) {},
            title: const Text('mmol/L'))
      ]),
    );
  }
}

// 백업
class BackupSettingsPage extends StatelessWidget {
  const BackupSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('백업 및 복원')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('마지막 백업',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('2026.01.04 15:30')
                    ]))),
        const SizedBox(height: 16),
        ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.cloud_upload),
            label: const Text('지금 백업')),
        const SizedBox(height: 8),
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.cloud_download),
            label: const Text('백업에서 복원'))
      ]),
    );
  }
}

// 접근성
class AccessibilitySettingsPage extends StatelessWidget {
  const AccessibilitySettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('접근성')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SwitchListTile(
            value: false, onChanged: (_) {}, title: const Text('음성 안내')),
        SwitchListTile(
            value: false, onChanged: (_) {}, title: const Text('고대비 모드')),
        SwitchListTile(
            value: false, onChanged: (_) {}, title: const Text('화면 읽기')),
        ListTile(title: const Text('글꼴 크기'), trailing: const Text('보통'))
      ]),
    );
  }
}
