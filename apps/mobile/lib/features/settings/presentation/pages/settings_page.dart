import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 설정 메인 페이지
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // 계정 설정
          _SettingSectionHeader(title: '계정'),
          _SettingItem(
            icon: Icons.person,
            title: '프로필',
            subtitle: '사용자 정보 관리',
            onTap: () => context.push('/settings/account/profile'),
          ),
          _SettingItem(
            icon: Icons.email,
            title: '이메일',
            subtitle: '이메일 변경',
            onTap: () => context.push('/settings/account/email'),
          ),
          _SettingItem(
            icon: Icons.lock,
            title: '비밀번호',
            subtitle: '비밀번호 변경',
            onTap: () => context.push('/settings/account/password'),
          ),
          _SettingItem(
            icon: Icons.phone,
            title: '전화번호',
            subtitle: '전화번호 관리',
            onTap: () => context.push('/settings/account/phone'),
          ),
          _SettingItem(
            icon: Icons.delete,
            title: '계정 삭제',
            subtitle: '계정 삭제 요청',
            onTap: () => context.push('/settings/account/delete'),
          ),

          // 기기 설정
          _SettingSectionHeader(title: '기기 관리'),
          _SettingItem(
            icon: Icons.devices,
            title: '리더기 목록',
            subtitle: '연결된 기기 관리',
            onTap: () => context.push('/settings/devices/list'),
          ),
          _SettingItem(
            icon: Icons.add_circle,
            title: '기기 추가',
            subtitle: '새 리더기 연결',
            onTap: () => context.push('/settings/devices/add'),
          ),
          _SettingItem(
            icon: Icons.update,
            title: '펌웨어 업데이트',
            subtitle: '기기 업데이트 확인',
            onTap: () => context.push('/settings/devices/firmware'),
          ),

          // 긴급 설정
          _SettingSectionHeader(title: '긴급 설정'),
          _SettingItem(
            icon: Icons.contact_emergency,
            title: '긴급 연락처',
            subtitle: '긴급 상황 연락처 관리',
            onTap: () => context.push('/settings/emergency/contacts'),
          ),
          _SettingItem(
            icon: Icons.warning,
            title: '알람 임계값',
            subtitle: '측정값 알람 설정',
            onTap: () => context.push('/settings/emergency/thresholds'),
          ),
          _SettingItem(
            icon: Icons.call,
            title: '자동 호출 설정',
            subtitle: '응급 상황 자동 호출',
            onTap: () => context.push('/settings/emergency/auto-call'),
          ),

          // 외부 통합
          _SettingSectionHeader(title: '외부 통합'),
          _SettingItem(
            icon: Icons.devices_other,
            title: '웨어러블 기기',
            subtitle: 'Apple Watch, Galaxy Watch 등',
            onTap: () => context.push('/settings/external/wearables'),
          ),
          _SettingItem(
            icon: Icons.home,
            title: '스마트홈',
            subtitle: 'IoT 기기 연동',
            onTap: () => context.push('/settings/external/smart-home'),
          ),
          _SettingItem(
            icon: Icons.health_and_safety,
            title: '건강 앱 연동',
            subtitle: '다른 건강앱과 동기화',
            onTap: () => context.push('/settings/external/health-apps'),
          ),

          // 알림 설정
          _SettingSectionHeader(title: '알림'),
          _SettingItem(
            icon: Icons.notifications,
            title: '알림 설정',
            subtitle: '앱 알림 관리',
            onTap: () => context.push('/settings/notifications'),
          ),

          // 개인정보 및 보안
          _SettingSectionHeader(title: '개인정보 및 보안'),
          _SettingItem(
            icon: Icons.share,
            title: '데이터 공유',
            subtitle: '데이터 공유 동의',
            onTap: () => context.push('/settings/privacy/sharing'),
          ),
          _SettingItem(
            icon: Icons.check_circle,
            title: '동의 관리',
            subtitle: '약관 및 동의',
            onTap: () => context.push('/settings/privacy/consent'),
          ),
          _SettingItem(
            icon: Icons.download,
            title: '데이터 다운로드',
            subtitle: '내 데이터 내보내기',
            onTap: () => context.push('/settings/privacy/download'),
          ),
          _SettingItem(
            icon: Icons.delete_outline,
            title: '데이터 삭제',
            subtitle: '측정 데이터 삭제',
            onTap: () => context.push('/settings/privacy/deletion'),
          ),

          // 앱 설정
          _SettingSectionHeader(title: '앱 설정'),
          _SettingItem(
            icon: Icons.language,
            title: '언어',
            subtitle: '앱 언어 변경',
            onTap: () => context.push('/settings/app/language'),
          ),
          _SettingItem(
            icon: Icons.brightness_4,
            title: '테마',
            subtitle: 'Light, Dark, System',
            onTap: () => context.push('/settings/app/theme'),
          ),
          _SettingItem(
            icon: Icons.info,
            title: '앱 정보',
            subtitle: '버전 및 라이선스',
            onTap: () => context.push('/settings/app/about'),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SettingSectionHeader extends StatelessWidget {
  final String title;

  const _SettingSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle, maxLines: 1),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
          );
        },
      ),
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: const Icon(Icons.person, size: 40),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('사용자 이름', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('user@example.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('프로필 수정'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        ...items,
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

class _ToggleSetting extends StatefulWidget {
  final String title;
  final bool enabled;

  const _ToggleSetting({required this.title, required this.enabled});

  @override
  State<_ToggleSetting> createState() => _ToggleSettingState();
}

class _ToggleSettingState extends State<_ToggleSetting> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: Switch(
        value: _enabled,
        onChanged: (value) {
          setState(() => _enabled = value);
          context.read<SettingsBloc>().add(
            UpdateSetting(key: widget.title, value: value),
          );
        },
      ),
    );
  }
}
