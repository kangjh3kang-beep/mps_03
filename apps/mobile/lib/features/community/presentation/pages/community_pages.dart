import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// 커뮤니티 메인 페이지
class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 탭
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TabButton(
                    label: '포럼',
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                ),
                Expanded(
                  child: TabButton(
                    label: 'Q&A',
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ),
                Expanded(
                  child: TabButton(
                    label: '챌린지',
                    isSelected: _selectedTab == 2,
                    onTap: () => setState(() => _selectedTab = 2),
                  ),
                ),
              ],
            ),
          ),
          // 컨텐츠
          Expanded(
            child: _selectedTab == 0
                ? const ForumPage()
                : _selectedTab == 1
                    ? const QAPage()
                    : const Center(child: Text('챌린지')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/community/create-post'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 포럼 페이지
class ForumPage extends StatelessWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildPostCard(
        context,
        title: index == 0 ? '[공지] 앱 업데이트 예정' : '혈당 관리 팁을 공유해주세요',
        author: index == 0 ? '관리자' : '김만팍$index',
        date: DateFormat('MM-dd HH:mm').format(DateTime.now()),
        content: '많은 사용자들이 혈당 관리에 어려움을 겪고 있습니다. 효과적인 방법을 공유해주세요.',
        likes: 128 + index * 10,
        comments: 45 + index * 5,
        views: 1200 + index * 100,
        isPinned: index == 0,
        isOfficial: index == 0,
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context, {
    required String title,
    required String author,
    required String date,
    required String content,
    required int likes,
    required int comments,
    required int views,
    bool isPinned = false,
    bool isOfficial = false,
  }) {
    return GestureDetector(
      onTap: () => context.push('/community/post/1'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: isOfficial ? Colors.blue[50] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                if (isPinned)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.push_pin, size: 12, color: Colors.red[700]),
                        const SizedBox(width: 2),
                        Text('공지', style: TextStyle(fontSize: 10, color: Colors.red[700])),
                      ],
                    ),
                  ),
                if (isOfficial)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('공식', style: TextStyle(fontSize: 10, color: Colors.blue[700])),
                  ),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 본문
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            // 메타 정보
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: Colors.grey[300]),
                const SizedBox(width: 6),
                Text(author, style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 8),
                Text(date, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                const Spacer(),
                _buildStatChip(Icons.visibility, views),
                const SizedBox(width: 6),
                _buildStatChip(Icons.chat_bubble_outline, comments),
                const SizedBox(width: 6),
                _buildStatChip(Icons.favorite_border, likes),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 2),
        Text('$count', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }
}

/// Q&A 페이지
class QAPage extends StatelessWidget {
  const QAPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildQACard(
        context,
        question: '혈당이 계속 높은데 어떻게 관리해야 하나요?',
        author: '사용자${index + 1}',
        date: DateFormat('MM-dd').format(DateTime.now()),
        answers: 5 + index * 2,
        isAnswered: index % 2 == 0,
      ),
    );
  }

  Widget _buildQACard(
    BuildContext context, {
    required String question,
    required String author,
    required String date,
    required int answers,
    required bool isAnswered,
  }) {
    return GestureDetector(
      onTap: () => context.push('/community/post/1'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isAnswered ? Colors.green[300]! : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 질문
            Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isAnswered)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '답변됨',
                      style: TextStyle(fontSize: 11, color: Colors.green[700]),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // 메타
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: Colors.grey[300]),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(author, style: const TextStyle(fontSize: 11)),
                      Text(date, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '답변 $answers개',
                    style: TextStyle(fontSize: 11, color: Colors.blue[700]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 포스트 상세 페이지
class PostDetailPage extends StatefulWidget {
  final String postId;

  const PostDetailPage({
    required this.postId,
    Key? key,
  }) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('포스트'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 포스트 헤더
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '혈당 관리 팁을 공유해주세요',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(radius: 16, backgroundColor: Colors.blue[100]),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('김만팍', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const Spacer(),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(child: Text('수정')),
                          const PopupMenuItem(child: Text('삭제')),
                          const PopupMenuItem(child: Text('신고')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // 본문
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '안녕하세요. 혈당 관리에 어려움을 겪고 있는 분들을 위해 효과적인 방법을 공유하고자 합니다.\n\n'
                '1. 정기적인 측정: 하루 3-4회 측정으로 패턴 파악\n'
                '2. 식사 관리: 저 GI 음식 위주로 섭취\n'
                '3. 운동: 주 5회 30분 유산소 운동\n'
                '4. 스트레스 관리: 충분한 수면과 명상\n\n'
                '저는 이러한 방법으로 혈당을 효과적으로 관리하고 있습니다.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // 액션 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : null,
                    ),
                    onPressed: () => setState(() => _isLiked = !_isLiked),
                  ),
                  Text(_isLiked ? '128' : '127'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('북마크에 추가되었습니다')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('공유되었습니다')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(),

            // 댓글 섹션
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '댓글 5개',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildComment(
                    author: '사용자1',
                    date: '2024-01-15',
                    content: '정말 좋은 팁 감사합니다! 바로 실천해보겠습니다.',
                    likes: 12,
                  ),
                  const SizedBox(height: 8),
                  _buildComment(
                    author: '사용자2',
                    date: '2024-01-14',
                    content: '저도 같은 경험을 했습니다. 정기적인 측정이 가장 중요한 것 같아요.',
                    likes: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('댓글이 작성되었습니다')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComment({
    required String author,
    required String date,
    required String content,
    required int likes,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: Colors.grey[300]),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(date, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.favorite_border, size: 14, color: Colors.grey),
              const SizedBox(width: 2),
              Text('$likes', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text('답글', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 포스트 작성 페이지
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('포스트 작성'),
        actions: [
          TextButton(
            onPressed: _titleController.text.isNotEmpty && _contentController.text.isNotEmpty
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('포스트가 작성되었습니다')),
                    );
                    context.pop();
                  }
                : null,
            child: const Text('작성'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '제목을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: null,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '내용을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: 12,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '태그 추가',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['혈당', '건강', '관리', '팁', '공유']
                        .map((tag) => InputChip(
                          label: Text(tag),
                          onDeleted: () {},
                        ))
                        .toList(),
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

class TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 3,
              color: isSelected ? Colors.blue : Colors.transparent,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
