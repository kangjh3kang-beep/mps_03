import 'package:flutter/material.dart';

/// 프로필 설정 페이지
class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: '홍길동');
  final _emailController = TextEditingController(text: 'hong@example.com');
  final _phoneController = TextEditingController(text: '010-1234-5678');
  String _gender = '남성';
  DateTime _birthDate = DateTime(1990, 1, 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('프로필 설정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProfileImage(),
              const SizedBox(height: 32),
              _buildTextField('이름', _nameController, Icons.person),
              _buildTextField('이메일', _emailController, Icons.email),
              _buildTextField('전화번호', _phoneController, Icons.phone),
              _buildGenderSelector(),
              _buildBirthDateSelector(),
              const SizedBox(height: 32),
              _buildMedicalInfoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.cyan.withOpacity(0.2),
            child: const Icon(Icons.person, size: 60, color: Colors.cyan),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.cyan,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0A1628), width: 3),
              ),
              child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.cyan),
          filled: true,
          fillColor: const Color(0xFF1A2942),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.cyan),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.wc, color: Colors.cyan),
          const SizedBox(width: 16),
          const Text('성별', style: TextStyle(color: Colors.white54)),
          const Spacer(),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: '남성', label: Text('남성')),
              ButtonSegment(value: '여성', label: Text('여성')),
            ],
            selected: {_gender},
            onSelectionChanged: (value) => setState(() => _gender = value.first),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDateSelector() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _birthDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) setState(() => _birthDate = date);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2942),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.cake, color: Colors.cyan),
            const SizedBox(width: 16),
            const Text('생년월일', style: TextStyle(color: Colors.white54)),
            const Spacer(),
            Text(
              '${_birthDate.year}.${_birthDate.month}.${_birthDate.day}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '의료 정보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildMedicalItem('혈액형', 'A형'),
          _buildMedicalItem('키', '175 cm'),
          _buildMedicalItem('몸무게', '70 kg'),
          _buildMedicalItem('알레르기', '없음'),
          _buildMedicalItem('복용 약물', '없음'),
        ],
      ),
    );
  }

  Widget _buildMedicalItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Row(
            children: [
              Text(value, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              const Icon(Icons.edit, size: 16, color: Colors.white54),
            ],
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필이 저장되었습니다')),
      );
    }
  }
}

/// 보안 설정 페이지
class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;
  bool _autoLockEnabled = true;
  String _autoLockTime = '5분';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('보안 설정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityStatus(),
            const SizedBox(height: 24),
            _buildSecurityOptions(),
            const SizedBox(height: 24),
            _buildPasswordSection(),
            const SizedBox(height: 24),
            _buildSessionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withOpacity(0.3), Colors.green.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, color: Colors.green, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '보안 상태: 양호',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '계정이 안전하게 보호되고 있습니다',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOptions() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            '생체 인증',
            '지문/얼굴 인식으로 로그인',
            Icons.fingerprint,
            _biometricEnabled,
            (v) => setState(() => _biometricEnabled = v),
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildSwitchTile(
            '2단계 인증',
            'SMS 또는 인증 앱 사용',
            Icons.security,
            _twoFactorEnabled,
            (v) => setState(() => _twoFactorEnabled = v),
          ),
          const Divider(color: Colors.white12, height: 1),
          _buildSwitchTile(
            '자동 잠금',
            '비활성 시 자동으로 앱 잠금',
            Icons.lock_clock,
            _autoLockEnabled,
            (v) => setState(() => _autoLockEnabled = v),
          ),
          if (_autoLockEnabled)
            Padding(
              padding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
              child: DropdownButton<String>(
                value: _autoLockTime,
                isExpanded: true,
                dropdownColor: const Color(0xFF1A2942),
                style: const TextStyle(color: Colors.white),
                items: ['1분', '5분', '10분', '30분']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _autoLockTime = v!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyan),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.cyan,
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '비밀번호',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildActionTile('비밀번호 변경', Icons.key, () {}),
          _buildActionTile('PIN 코드 설정', Icons.pin, () {}),
        ],
      ),
    );
  }

  Widget _buildSessionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '로그인 세션',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildSessionItem('이 기기', 'iPhone 14 Pro', '현재 활성', true),
          _buildSessionItem('다른 기기', 'Chrome on Mac', '2일 전', false),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('모든 기기에서 로그아웃'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.cyan),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
    );
  }

  Widget _buildSessionItem(String device, String details, String status, bool current) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            current ? Icons.phone_android : Icons.computer,
            color: current ? Colors.green : Colors.white54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device, style: const TextStyle(color: Colors.white)),
                Text(details, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: current ? Colors.green.withOpacity(0.2) : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: current ? Colors.green : Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 알림 설정 페이지
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = false;
  bool _measurementAlerts = true;
  bool _coachingReminders = true;
  bool _communityUpdates = false;
  bool _promotions = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('알림 설정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChannelSettings(),
            const SizedBox(height: 24),
            _buildCategorySettings(),
            const SizedBox(height: 24),
            _buildQuietHours(),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelSettings() {
    return _buildSection('알림 채널', [
      _buildSwitchItem('푸시 알림', _pushEnabled, (v) => setState(() => _pushEnabled = v)),
      _buildSwitchItem('이메일 알림', _emailEnabled, (v) => setState(() => _emailEnabled = v)),
      _buildSwitchItem('SMS 알림', _smsEnabled, (v) => setState(() => _smsEnabled = v)),
    ]);
  }

  Widget _buildCategorySettings() {
    return _buildSection('알림 카테고리', [
      _buildSwitchItem('측정 알림', _measurementAlerts, (v) => setState(() => _measurementAlerts = v)),
      _buildSwitchItem('코칭 리마인더', _coachingReminders, (v) => setState(() => _coachingReminders = v)),
      _buildSwitchItem('커뮤니티 업데이트', _communityUpdates, (v) => setState(() => _communityUpdates = v)),
      _buildSwitchItem('프로모션', _promotions, (v) => setState(() => _promotions = v)),
    ]);
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.cyan),
        ],
      ),
    );
  }

  Widget _buildQuietHours() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bedtime, color: Colors.purple),
              SizedBox(width: 8),
              Text(
                '방해 금지 시간',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTimeSelector('시작', _quietStart, (t) => setState(() => _quietStart = t)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('~', style: TextStyle(color: Colors.white54, fontSize: 24)),
              ),
              Expanded(
                child: _buildTimeSelector('종료', _quietEnd, (t) => setState(() => _quietEnd = t)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(String label, TimeOfDay time, ValueChanged<TimeOfDay> onChanged) {
    return InkWell(
      onTap: () async {
        final selected = await showTimePicker(context: context, initialTime: time);
        if (selected != null) onChanged(selected);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// 데이터 및 개인정보 설정 페이지
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _analyticsEnabled = true;
  bool _crashReportsEnabled = true;
  bool _personalizedAds = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('데이터 및 개인정보'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataUsageSection(),
            const SizedBox(height: 24),
            _buildPrivacyControls(),
            const SizedBox(height: 24),
            _buildDataManagement(),
            const SizedBox(height: 24),
            _buildLegalSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataUsageSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '데이터 사용량',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildStorageBar('로컬 저장소', 0.35, '1.2 GB / 3.4 GB'),
          const SizedBox(height: 12),
          _buildStorageBar('클라우드 동기화', 0.62, '2.1 GB / 3.4 GB'),
        ],
      ),
    );
  }

  Widget _buildStorageBar(String label, double ratio, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text(details, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(
              ratio > 0.8 ? Colors.red : (ratio > 0.5 ? Colors.orange : Colors.cyan),
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '개인정보 설정',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildPrivacySwitch('앱 사용 분석', '서비스 개선을 위한 익명 데이터 수집', _analyticsEnabled,
              (v) => setState(() => _analyticsEnabled = v)),
          _buildPrivacySwitch('오류 보고', '앱 안정성 향상을 위한 충돌 데이터', _crashReportsEnabled,
              (v) => setState(() => _crashReportsEnabled = v)),
          _buildPrivacySwitch('맞춤형 광고', '관심사 기반 광고 표시', _personalizedAds,
              (v) => setState(() => _personalizedAds = v)),
        ],
      ),
    );
  }

  Widget _buildPrivacySwitch(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white)),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.cyan),
        ],
      ),
    );
  }

  Widget _buildDataManagement() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '데이터 관리',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildActionItem(Icons.download, '데이터 내보내기', '모든 데이터를 JSON/CSV로 다운로드', Colors.blue),
          _buildActionItem(Icons.cloud_sync, '동기화 설정', '클라우드 백업 관리', Colors.green),
          _buildActionItem(Icons.delete_forever, '데이터 삭제', '모든 개인 데이터 영구 삭제', Colors.red),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white)),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '법적 문서',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildLegalLink('개인정보처리방침'),
          _buildLegalLink('서비스 이용약관'),
          _buildLegalLink('오픈소스 라이선스'),
          _buildLegalLink('의료기기 규제 정보'),
        ],
      ),
    );
  }

  Widget _buildLegalLink(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.open_in_new, color: Colors.white54, size: 18),
      onTap: () {},
    );
  }
}

