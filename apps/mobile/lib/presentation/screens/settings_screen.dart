import 'package:flutter/material.dart';
import 'external_data_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          _buildSectionHeader('접근성 설정'),
          _buildSettingTile(context, Icons.accessibility_new, '접근성 모드', '시니어, 맹인, 농아인 지원', () {}),
          _buildSettingTile(context, Icons.text_fields, '글자 크기 조절', '크게, 보통, 작게', () {}),
          
          _buildSectionHeader('시스템 설정'),
          _buildSettingTile(context, Icons.language, '언어 선택', '한국어, English, 日本語, 中文', () {}),
          _buildSettingTile(context, Icons.link, '외부 데이터 연동', 'Apple Health, Google Fit 연동', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExternalDataScreen()),
            );
          }),
          _buildSettingTile(context, Icons.devices, '기기 관리', '연결된 리더기 및 센서', () {}),
          
          _buildSectionHeader('계정 및 보안'),
          _buildSettingTile(context, Icons.security, '보안 및 인증', '생체 인증, 2단계 인증', () {}),
          _buildSettingTile(context, Icons.privacy_tip, '개인정보 보호 정책', '데이터 활용 및 보호', () {}),
          
          _buildSectionHeader('정보'),
          _buildSettingTile(context, Icons.info_outline, '버전 정보', 'v2.2.0 (Global)', () {}),
          
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('로그아웃'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.slate[400]),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.slate[500])),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.slate[700]),
      onTap: onTap,
    );
  }
}
