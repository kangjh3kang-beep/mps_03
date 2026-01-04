import 'package:flutter/material.dart';

/// 가족 공유 메인 페이지
class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('가족 건강 관리'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => Navigator.pushNamed(context, '/family/invite'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFamilySummary(),
            const SizedBox(height: 24),
            _buildFamilyMembers(context),
            const SizedBox(height: 24),
            _buildSharedData(),
            const SizedBox(height: 24),
            _buildFamilyActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilySummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1E3A5F), const Color(0xFF0D2137)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.family_restroom, color: Colors.cyan, size: 32),
              SizedBox(width: 12),
              Text(
                '홍길동 가족',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('가족 구성원', '4명', Icons.people),
              _buildSummaryItem('평균 건강점수', '82점', Icons.favorite),
              _buildSummaryItem('이번 주 측정', '28회', Icons.analytics),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.cyan, size: 24),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildFamilyMembers(BuildContext context) {
    final members = [
      FamilyMember('나', '본인', 85, 'online', true),
      FamilyMember('홍영희', '배우자', 88, 'online', false),
      FamilyMember('홍준호', '자녀', 92, 'offline', false),
      FamilyMember('홍수지', '자녀', 78, 'online', false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('가족 구성원',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 16),
        ...members.map((m) => _buildMemberCard(context, m)),
      ],
    );
  }

  Widget _buildMemberCard(BuildContext context, FamilyMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: member.isMe ? null : () => Navigator.pushNamed(context, '/family/member/${member.name}'),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.cyan.withOpacity(0.2),
                  child: Text(
                    member.name[0],
                    style: const TextStyle(
                        color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                if (member.status == 'online')
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1A2942), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(member.name,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      if (member.isMe)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.cyan.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('나',
                              style: TextStyle(color: Colors.cyan, fontSize: 10)),
                        ),
                    ],
                  ),
                  Text(member.relation,
                      style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${member.healthScore}점',
                    style: TextStyle(
                        color: _getScoreColor(member.healthScore),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const Text('건강점수',
                    style: TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
            if (!member.isMe) ...[
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.teal;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }

  Widget _buildSharedData() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('공유 데이터',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('모두 보기',
                  style: TextStyle(color: Colors.cyan, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          _buildSharedItem(Icons.favorite, '혈압', '가족 평균: 118/78 mmHg', Colors.red),
          _buildSharedItem(Icons.water_drop, '혈당', '가족 평균: 95 mg/dL', Colors.blue),
          _buildSharedItem(Icons.monitor_heart, '심박수', '가족 평균: 72 bpm', Colors.pink),
        ],
      ),
    );
  }

  Widget _buildSharedItem(IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white)),
                Text(value, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyActions(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          Icons.share,
          '데이터 공유 설정',
          '공유할 건강 데이터 선택',
          Colors.blue,
          () => Navigator.pushNamed(context, '/family/shared-data'),
        ),
        _buildActionButton(
          Icons.notifications,
          '가족 알림',
          '가족 건강 변화 알림 설정',
          Colors.orange,
          () => Navigator.pushNamed(context, '/family/notifications'),
        ),
        _buildActionButton(
          Icons.bar_chart,
          '가족 분석',
          '가족 건강 트렌드 분석',
          Colors.green,
          () => Navigator.pushNamed(context, '/family/group-analytics'),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2942),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}

/// 가족 초대 페이지
class InviteFamilyPage extends StatelessWidget {
  const InviteFamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('가족 초대'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInviteCodeCard(),
            const SizedBox(height: 24),
            _buildInviteMethods(),
            const SizedBox(height: 24),
            _buildPendingInvites(),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteCodeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.withOpacity(0.3), Colors.blue.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const Text('가족 초대 코드',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          const Text('MPS-FAMILY-2024',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('복사'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.qr_code, size: 18),
                label: const Text('QR코드'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('코드는 24시간 후 만료됩니다',
              style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInviteMethods() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('초대 방법',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildMethodItem(Icons.message, 'SMS로 초대', Colors.green),
          _buildMethodItem(Icons.email, '이메일로 초대', Colors.blue),
          _buildMethodItem(Icons.share, '링크 공유', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildMethodItem(IconData icon, String title, Color color) {
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
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white))),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingInvites() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('대기 중인 초대',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildPendingItem('kim@example.com', '2시간 전 초대'),
          _buildPendingItem('lee@example.com', '1일 전 초대'),
        ],
      ),
    );
  }

  Widget _buildPendingItem(String email, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email, style: const TextStyle(color: Colors.white)),
                Text(time, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('다시 보내기')),
        ],
      ),
    );
  }
}

class FamilyMember {
  final String name;
  final String relation;
  final int healthScore;
  final String status;
  final bool isMe;

  FamilyMember(this.name, this.relation, this.healthScore, this.status, this.isMe);
}

