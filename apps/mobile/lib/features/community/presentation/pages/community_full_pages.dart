import 'package:flutter/material.dart';

/// 커뮤니티 페이지들 - Phase 5

// 커뮤니티 메인
class CommunityMainPage extends StatelessWidget {
  const CommunityMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('커뮤니티')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _card('혈당 관리 팁 공유합니다', 'user1', 15, 3),
        _card('오늘 측정 결과 좋네요!', 'user2', 8, 1),
        _card('운동 후 혈당 변화 질문', 'user3', 22, 5),
      ]),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: const Icon(Icons.edit)),
    );
  }

  Widget _card(String t, String u, int l, int c) => Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              Text(u, style: TextStyle(color: Colors.grey[600])),
              const Spacer(),
              Row(children: [
                const Icon(Icons.favorite, size: 16),
                Text(' $l'),
                const SizedBox(width: 8),
                const Icon(Icons.comment, size: 16),
                Text(' $c')
              ])
            ])
          ])));
}

// 게시글 상세
class PostDetailPage extends StatelessWidget {
  final String? postId;
  const PostDetailPage({super.key, this.postId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시글')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('혈당 관리 팁 공유합니다',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('user1 • 2시간 전', style: TextStyle(color: Colors.grey[600])),
        const Divider(height: 24),
        const Text('식후 30분 산책이 혈당 조절에 효과적이에요.\n\n저는 매일 실천하고 있습니다!')
      ]),
    );
  }
}

// 글쓰기
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('글쓰기'),
          actions: [TextButton(onPressed: () {}, child: const Text('등록'))]),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: const [
            TextField(
                decoration: InputDecoration(
                    hintText: '제목', border: OutlineInputBorder())),
            SizedBox(height: 16),
            Expanded(
                child: TextField(
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                        hintText: '내용을 입력하세요', border: OutlineInputBorder())))
          ])),
    );
  }
}

// 포럼목록
class ForumsPage extends StatelessWidget {
  const ForumsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('포럼')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _forum('혈당 관리', Icons.water_drop, Colors.purple),
        _forum('식이요법', Icons.restaurant, Colors.green),
        _forum('운동', Icons.fitness_center, Colors.orange),
        _forum('자유게시판', Icons.chat_bubble, Colors.blue)
      ]),
    );
  }

  Widget _forum(String n, IconData i, Color c) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
          leading: Icon(i, color: c),
          title: Text(n),
          trailing: const Icon(Icons.chevron_right)));
}

// 챌린지
class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('챌린지')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _challenge('7일 연속 측정', 0.7, 234),
        _challenge('10000보 걷기', 0.4, 156),
        _challenge('물 2L 마시기', 0.9, 89)
      ]),
    );
  }

  Widget _challenge(String n, double p, int j) => Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(n, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: p),
            const SizedBox(height: 4),
            Text('${(p * 100).toInt()}% 완료 • $j명 참여')
          ])));
}

// 지원그룹
class SupportGroupsPage extends StatelessWidget {
  const SupportGroupsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('지원 그룹')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                leading: const CircleAvatar(child: Text('🩸')),
                title: const Text('당뇨 관리 모임'),
                subtitle: const Text('234명 참여'))),
        Card(
            child: ListTile(
                leading: const CircleAvatar(child: Text('❤️')),
                title: const Text('건강한 생활 모임'),
                subtitle: const Text('156명 참여'))),
      ]),
    );
  }
}

// 전문가Q&A
class ExpertQAPage extends StatelessWidget {
  const ExpertQAPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('전문가 Q&A')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('Q: 식후 혈당 관리법?'),
                subtitle: const Text('김OO 내분비내과 전문의 답변'))),
        Card(
            child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('Q: 운동 시간대 추천'),
                subtitle: const Text('이OO 가정의학과 전문의 답변')))
      ]),
    );
  }
}

// 이벤트
class CommunityEventsPage extends StatelessWidget {
  const CommunityEventsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이벤트')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            color: Colors.blue.withOpacity(0.1),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('신년 건강 챌린지',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 4),
                      Text('2026.01.01 ~ 01.31'),
                      SizedBox(height: 8),
                      Text('참여하고 경품 받으세요!')
                    ]))),
        Card(
            child: ListTile(
                title: const Text('무료 건강 상담'), subtitle: const Text('매주 토요일')))
      ]),
    );
  }
}

// 리더보드
class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('리더보드')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 10,
          itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: i < 3 ? Colors.amber.withOpacity(0.1) : null,
              child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: i < 3 ? Colors.amber : Colors.grey[300],
                      child: Text('${i + 1}')),
                  title: Text('User ${i + 1}'),
                  trailing: Text('${1000 - i * 50}점')))),
    );
  }
}

// 멘토매칭
class MentorMatchingPage extends StatelessWidget {
  const MentorMatchingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('멘토 매칭')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
            child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('당뇨 관리 10년차 멘토'),
                subtitle: const Text('⭐ 4.9 • 리뷰 56개'),
                trailing: ElevatedButton(
                    onPressed: () {}, child: const Text('매칭 신청')))),
        Card(
            child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('건강 식단 전문가'),
                subtitle: const Text('⭐ 4.8 • 리뷰 42개'),
                trailing: ElevatedButton(
                    onPressed: () {}, child: const Text('매칭 신청'))))
      ]),
    );
  }
}

// 성공스토리
class SuccessStoriesPage extends StatelessWidget {
  const SuccessStoriesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('성공 스토리')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _story('3개월 만에 혈당 정상화', 'HbA1c 7.2% → 5.5%'),
        _story('꾸준한 관리의 힘', '1년간 매일 측정 성공'),
        _story('생활습관 개선 후기', '체중 10kg 감량')
      ]),
    );
  }

  Widget _story(String t, String s) => Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(s, style: TextStyle(color: Colors.grey[600]))
          ])));
}

// 리소스
class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('리소스')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('당뇨 관리 가이드 PDF')),
        ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('교육 동영상')),
        ListTile(leading: const Icon(Icons.link), title: const Text('유용한 링크'))
      ]),
    );
  }
}

// 프로필
class UserProfilePage extends StatelessWidget {
  final String? userId;
  const UserProfilePage({super.key, this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            const Text('홍길동',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('가입일: 2025.12.01'),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat('게시글', '12'),
              _stat('좋아요', '45'),
              _stat('댓글', '28')
            ])
          ])),
    );
  }

  Widget _stat(String l, String v) => Column(children: [
        Text(v,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(l)
      ]);
}

// 활동내역
class UserActivityPage extends StatelessWidget {
  const UserActivityPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 활동')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('게시글 작성'),
            subtitle: const Text('혈당 관리 팁...')),
        ListTile(
            leading: const Icon(Icons.comment),
            title: const Text('댓글 작성'),
            subtitle: const Text('좋은 정보 감사합니다!')),
        ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('좋아요'),
            subtitle: const Text('운동 후 혈당 변화...'))
      ]),
    );
  }
}

// 팔로워
class FollowersPage extends StatelessWidget {
  const FollowersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('팔로워')),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          itemBuilder: (_, i) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text('User ${i + 1}'),
              trailing:
                  OutlinedButton(onPressed: () {}, child: const Text('팔로우')))),
    );
  }
}

// 알림설정
class CommunityNotificationsPage extends StatelessWidget {
  const CommunityNotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림 설정')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('새 댓글 알림')),
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('새 팔로워 알림')),
        SwitchListTile(
            value: false, onChanged: (_) {}, title: const Text('좋아요 알림')),
        SwitchListTile(
            value: true, onChanged: (_) {}, title: const Text('챌린지 알림'))
      ]),
    );
  }
}

// 헬프센터
class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도움말')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ExpansionTile(
            title: const Text('계정 관련'),
            children: [ListTile(title: const Text('비밀번호 변경 방법'))]),
        ExpansionTile(
            title: const Text('앱 사용법'),
            children: [ListTile(title: const Text('측정 방법'))]),
        ExpansionTile(
            title: const Text('커뮤니티 이용'),
            children: [ListTile(title: const Text('게시글 작성 방법'))])
      ]),
    );
  }
}
