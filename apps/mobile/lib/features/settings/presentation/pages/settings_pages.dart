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
          // 계정
          _buildSection(
            context,
            title: '계정',
            items: [
              _buildSettingItem(
                context,
                icon: Icons.person,
                title: '프로필 관리',
                subtitle: '이름, 이메일, 프로필 사진',
                onTap: () => context.push('/settings/profile'),
              ),
              _buildSettingItem(
                context,
                icon: Icons.security,
                title: '보안',
                subtitle: '비밀번호, 2단계 인증',
                onTap: () {},
              ),
              _buildSettingItem(
                context,
                icon: Icons.credit_card,
                title: '결제 정보',
                subtitle: '신용카드, 계좌',
                onTap: () {},
              ),
            ],
          ),

          // 디바이스
          _buildSection(
            context,
            title: '디바이스',
            items: [
              _buildSettingItem(
                context,
                icon: Icons.devices,
                title: '연결된 기기',
                subtitle: '측정 기기 관리',
                onTap: () => context.push('/settings/devices'),
              ),
              _buildSettingItem(
                context,
                icon: Icons.bluetooth,
                title: 'Bluetooth',
                subtitle: '페어링된 기기',
                onTap: () {},
              ),
            ],
          ),

          // 건강/긴급
          _buildSection(
            context,
            title: '건강 & 긴급',
            items: [
              _buildSettingItem(
                context,
                icon: Icons.favorite,
                title: '긴급 연락처',
                subtitle: '응급 시 연락할 사람',
                onTap: () => context.push('/settings/emergency'),
              ),
              _buildSettingItem(
                context,
                icon: Icons.medical_information,
                title: '의료 정보',
                subtitle: '혈액형, 알레르기 등',
                onTap: () {},
              ),
            ],
          ),

          // 외부 연동
          _buildSection(
            context,
            title: '외부 서비스 연동',
            items: [
              _buildSettingItem(
                context,
                icon: Icons.cloud,
                title: '클라우드 백업',
                subtitle: 'Google Drive, iCloud',
                onTap: () {},
              ),
              _buildSettingItem(
                context,
                icon: Icons.fitness_center,
                title: '건강 앱 연동',
                subtitle: 'Apple Health, Google Fit',
                onTap: () {},
              ),
            ],
          ),

          // 알림
          _buildSection(
            context,
            title: '알림',
            items: [
              _buildSettingItem(
                context,
                icon: Icons.notifications,
                title: '알림 설정',
                subtitle: '푸시 알림, 이메일 알림',
                onTap: () => context.push('/settings/notifications'),
              ),
            ],
          ),

          // 개인정보
          _buildSection(
            context,
            title: '개인정보 & 보안',
            items: [
              _buildSettingItem(
                context,
                icon: Icons.shield,
                title: '개인정보 보호',
                subtitle: '데이터 사용 정책',
                onTap: () => context.push('/settings/privacy'),
              ),
              _buildSettingItem(
                context,
                icon: Icons.visibility_off,
                title: '프라이버시',
                subtitle: '프로필 공개 설정',
                onTap: () {},
              ),
            ],
          ),

          // 앱 설정
          _buildSection(
            context,
            title: '앱 설정',
            items: [
              _buildSettingItem(
                context,
                icon: Icons.palette,
                title: '테마',
                subtitle: '밝은 테마, 어두운 테마',
                onTap: () => context.push('/settings/appearance'),
              ),
              _buildSettingItem(
                context,
                icon: Icons.language,
                title: '언어',
                subtitle: '앱 언어 설정',
                onTap: () => context.push('/settings/language'),
              ),
              _buildSettingItem(
                context,
                icon: Icons.info,
                title: '앱 정보',
                subtitle: '버전, 라이선스',
                onTap: () => context.push('/settings/about'),
              ),
            ],
          ),

          // 계정 관리
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '계정 관리',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('로그아웃'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('로그아웃'),
                          content: const Text('로그아웃하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pop();
                                context.go('/login');
                              },
                              child: const Text('로그아웃'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('계정 삭제'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('계정 삭제'),
                          content: const Text('계정을 삭제하면 모든 데이터가 삭제됩니다. 정말로 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pop();
                                context.go('/login');
                              },
                              child: const Text('삭제', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

/// 프로필 설정 페이지
class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '김만팍');
    _emailController = TextEditingController(text: 'kim@example.com');
    _phoneController = TextEditingController(text: '010-1234-5678');
    _bioController = TextEditingController(text: '건강한 삶을 위해 노력 중입니다');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 관리'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('프로필이 저장되었습니다')),
              );
            },
            child: const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 사진
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue[100],
                    child: const Icon(Icons.person, size: 60, color: Colors.blue),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('카메라 실행')),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 정보 입력
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTextField('이름', _nameController, Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField('이메일', _emailController, Icons.email),
                  const SizedBox(height: 16),
                  _buildTextField('전화번호', _phoneController, Icons.phone),
                  const SizedBox(height: 16),
                  _buildTextField('소개', _bioController, Icons.description, maxLines: 4),
                  const SizedBox(height: 24),
                  
                  // 성별, 나이
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('성별', style: Theme.of(context).textTheme.labelSmall),
                            const SizedBox(height: 8),
                            DropdownButtonFormField(
                              value: '남성',
                              items: ['남성', '여성', '기타']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (_) {},
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('생년월일', style: Theme.of(context).textTheme.labelSmall),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(1990),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                );
                              },
                              child: const Text('1990-01-15'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

/// 디바이스 목록 페이지
class DeviceListPage extends StatefulWidget {
  const DeviceListPage({Key? key}) : super(key: key);

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('연결된 기기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('새 기기 검색 중...')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDeviceCard(
            name: 'ManPasik Reader Pro',
            type: '혈당 측정기',
            status: '연결됨',
            battery: 87,
            isConnected: true,
          ),
          const SizedBox(height: 12),
          _buildDeviceCard(
            name: 'Environmental Sensor',
            type: '환경 센서',
            status: '연결됨',
            battery: 65,
            isConnected: true,
          ),
          const SizedBox(height: 12),
          _buildDeviceCard(
            name: 'Smart Watch',
            type: '스마트워치',
            status: '연결 해제됨',
            battery: 0,
            isConnected: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard({
    required String name,
    required String type,
    required String status,
    required int battery,
    required bool isConnected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isConnected ? Icons.devices : Icons.devices_off,
                color: isConnected ? Colors.blue : Colors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(type, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isConnected ? Colors.green[100] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: isConnected ? Colors.green[700] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          if (isConnected) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.battery_full, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text('$battery%', style: const TextStyle(fontSize: 12)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('연결 해제', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 긴급 연락처 페이지
class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({Key? key}) : super(key: key);

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('긴급 연락처'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('긴급 연락처 추가'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(labelText: '이름'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(labelText: '연락처'),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(labelText: '관계'),
                        value: '배우자',
                        items: ['배우자', '부모', '자녀', '형제', '친구']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('긴급 연락처가 추가되었습니다')),
                        );
                      },
                      child: const Text('추가'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildContactCard('이영희', '배우자', '010-9876-5432'),
          const SizedBox(height: 12),
          _buildContactCard('김철수', '아버지', '010-1111-2222'),
          const SizedBox(height: 12),
          _buildContactCard('이순신', '형제', '010-3333-4444'),
        ],
      ),
    );
  }

  Widget _buildContactCard(String name, String relationship, String phone) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundColor: Colors.blue[100]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(relationship, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(phone, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('편집')),
              const PopupMenuItem(child: Text('삭제')),
            ],
          ),
        ],
      ),
    );
  }
}

/// 알림 설정 페이지
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotification = true;
  bool _measurementReminder = true;
  bool _healthAlert = true;
  bool _emailNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('푸시 알림'),
            subtitle: const Text('앱 알림 수신'),
            trailing: Switch(
              value: _pushNotification,
              onChanged: (value) => setState(() => _pushNotification = value),
            ),
          ),
          ListTile(
            title: const Text('측정 알림'),
            subtitle: const Text('측정 시간 알림'),
            trailing: Switch(
              value: _measurementReminder,
              onChanged: (value) => setState(() => _measurementReminder = value),
            ),
          ),
          ListTile(
            title: const Text('건강 알림'),
            subtitle: const Text('비정상 수치 알림'),
            trailing: Switch(
              value: _healthAlert,
              onChanged: (value) => setState(() => _healthAlert = value),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('이메일 알림'),
            subtitle: const Text('주간 건강 리포트'),
            trailing: Switch(
              value: _emailNotification,
              onChanged: (value) => setState(() => _emailNotification = value),
            ),
          ),
        ],
      ),
    );
  }
}

/// 개인정보 설정 페이지
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({Key? key}) : super(key: key);

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _profilePublic = false;
  bool _dataCollection = true;
  bool _analyticsShare = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 보호'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('프로필 공개'),
              subtitle: const Text('다른 사용자가 프로필 조회'),
              trailing: Switch(
                value: _profilePublic,
                onChanged: (value) => setState(() => _profilePublic = value),
              ),
            ),
            ListTile(
              title: const Text('데이터 수집'),
              subtitle: const Text('서비스 개선을 위한 사용 데이터 수집'),
              trailing: Switch(
                value: _dataCollection,
                onChanged: (value) => setState(() => _dataCollection = value),
              ),
            ),
            ListTile(
              title: const Text('분석 데이터 공유'),
              subtitle: const Text('익명화된 건강 데이터 공유'),
              trailing: Switch(
                value: _analyticsShare,
                onChanged: (value) => setState(() => _analyticsShare = value),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '데이터 관리',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('데이터 다운로드 준비 중...')),
                        );
                      },
                      child: const Text('내 데이터 다운로드'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('모든 데이터 삭제'),
                            content: const Text('삭제된 데이터는 복구할 수 없습니다.'),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('모든 데이터가 삭제되었습니다')),
                                  );
                                },
                                child: const Text('삭제', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('모든 데이터 삭제'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 테마 설정 페이지
class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({Key? key}) : super(key: key);

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  String _theme = 'auto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테마'),
      ),
      body: ListView(
        children: [
          RadioListTile(
            title: const Text('시스템 설정 따르기'),
            value: 'auto',
            groupValue: _theme,
            onChanged: (value) => setState(() => _theme = value ?? 'auto'),
          ),
          RadioListTile(
            title: const Text('밝은 테마'),
            value: 'light',
            groupValue: _theme,
            onChanged: (value) => setState(() => _theme = value ?? 'light'),
          ),
          RadioListTile(
            title: const Text('어두운 테마'),
            value: 'dark',
            groupValue: _theme,
            onChanged: (value) => setState(() => _theme = value ?? 'dark'),
          ),
        ],
      ),
    );
  }
}

/// 언어 설정 페이지
class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String _language = 'ko';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('언어'),
      ),
      body: ListView(
        children: [
          RadioListTile(
            title: const Text('한국어'),
            value: 'ko',
            groupValue: _language,
            onChanged: (value) => setState(() => _language = value ?? 'ko'),
          ),
          RadioListTile(
            title: const Text('English'),
            value: 'en',
            groupValue: _language,
            onChanged: (value) => setState(() => _language = value ?? 'en'),
          ),
          RadioListTile(
            title: const Text('日本語'),
            value: 'ja',
            groupValue: _language,
            onChanged: (value) => setState(() => _language = value ?? 'ja'),
          ),
          RadioListTile(
            title: const Text('中文'),
            value: 'zh',
            groupValue: _language,
            onChanged: (value) => setState(() => _language = value ?? 'zh'),
          ),
        ],
      ),
    );
  }
}

/// 앱 정보 페이지
class AppInfoPage extends StatelessWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 정보'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('앱 버전'),
            trailing: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('빌드 번호'),
            trailing: const Text('1'),
          ),
          ListTile(
            title: const Text('출시일'),
            trailing: const Text('2024-01-15'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '라이선스',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('오픈소스 라이선스'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLicense('Flutter', 'BSD'),
                              _buildLicense('Provider', 'MIT'),
                              _buildLicense('GoRouter', 'BSD'),
                              _buildLicense('Hive', 'Apache 2.0'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: const Text('닫기'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('오픈소스 라이선스'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('이용약관'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('개인정보처리방침'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicense(String name, String license) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(license, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
