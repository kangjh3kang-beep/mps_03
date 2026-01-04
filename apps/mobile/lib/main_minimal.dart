import 'package:flutter/material.dart';

/// 최소 MVP 테스트용 진입점
/// 의존성 오류를 우회하여 기본 UI만 테스트
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ManpasikMinimalApp());
}

class ManpasikMinimalApp extends StatelessWidget {
  const ManpasikMinimalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '만파식',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const MainShellPage(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00BCD4),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00BCD4),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0E21),
    );
  }
}

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MeasurementPage(),
    const DataHubPage(),
    const AICoachPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.biotech), label: '측정'),
          NavigationDestination(icon: Icon(Icons.analytics), label: '분석'),
          NavigationDestination(icon: Icon(Icons.smart_toy), label: 'AI'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: '더보기'),
        ],
      ),
    );
  }
}

// ============ 홈 페이지 ============
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('만파식'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 건강 점수 카드
            _HealthScoreCard(),
            const SizedBox(height: 16),
            
            // 빠른 측정 버튼
            _QuickMeasurementCard(),
            const SizedBox(height: 16),
            
            // 최근 측정
            _RecentMeasurementsCard(),
            const SizedBox(height: 16),
            
            // AI 인사이트
            _AIInsightCard(),
          ],
        ),
      ),
    );
  }
}

class _HealthScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.2),
                    border: Border.all(color: Colors.green, width: 4),
                  ),
                  child: const Center(
                    child: Text(
                      '85',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '오늘의 건강 상태',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Text(
                        '좋음',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.arrow_upward, size: 16, color: Colors.green),
                          Text('+5 ', style: TextStyle(color: Colors.green)),
                          Text('지난주 대비', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
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

class _QuickMeasurementCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('빠른 측정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MeasurementButton(
                  icon: Icons.bloodtype,
                  label: '혈당',
                  color: Colors.red,
                ),
                _MeasurementButton(
                  icon: Icons.favorite,
                  label: '혈압',
                  color: Colors.pink,
                ),
                _MeasurementButton(
                  icon: Icons.air,
                  label: '라돈',
                  color: Colors.blue,
                ),
                _MeasurementButton(
                  icon: Icons.water_drop,
                  label: '수질',
                  color: Colors.cyan,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MeasurementButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _RecentMeasurementsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('최근 측정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('전체보기')),
              ],
            ),
            const ListTile(
              leading: Icon(Icons.bloodtype, color: Colors.red),
              title: Text('혈당'),
              subtitle: Text('2시간 전'),
              trailing: Text('108 mg/dL', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.favorite, color: Colors.pink),
              title: Text('혈압'),
              subtitle: Text('어제'),
              trailing: Text('128/82 mmHg', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AIInsightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('AI 인사이트', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('오늘 혈당이 안정적입니다. 저녁 식사 후 가벼운 산책을 추천드려요.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ 측정 페이지 ============
class MeasurementPage extends StatelessWidget {
  const MeasurementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('측정')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const [
          _MeasurementTypeCard(icon: Icons.bloodtype, label: '혈당', color: Colors.red),
          _MeasurementTypeCard(icon: Icons.favorite, label: '혈압', color: Colors.pink),
          _MeasurementTypeCard(icon: Icons.air, label: '라돈', color: Colors.blue),
          _MeasurementTypeCard(icon: Icons.water_drop, label: '수질', color: Colors.cyan),
          _MeasurementTypeCard(icon: Icons.restaurant, label: '식품', color: Colors.orange),
          _MeasurementTypeCard(icon: Icons.science, label: '연구용', color: Colors.purple),
        ],
      ),
    );
  }
}

class _MeasurementTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MeasurementTypeCard({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label 측정 시작')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ============ 데이터 허브 페이지 ============
class DataHubPage extends StatelessWidget {
  const DataHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('데이터 허브'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '건강'),
              Tab(text: '환경'),
              Tab(text: '추세'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('건강 데이터 대시보드')),
            Center(child: Text('환경 데이터 대시보드')),
            Center(child: Text('추세 분석 대시보드')),
          ],
        ),
      ),
    );
  }
}

// ============ AI 코치 페이지 ============
class AICoachPage extends StatefulWidget {
  const AICoachPage({super.key});

  @override
  State<AICoachPage> createState() => _AICoachPageState();
}

class _AICoachPageState extends State<AICoachPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      isUser: false,
      content: '안녕하세요! 저는 만파식 AI 코치입니다. 건강에 대해 궁금한 점을 물어보세요.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 건강 코치'),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 채팅 영역
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),
          
          // 입력 영역
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(isUser: true, content: _controller.text));
      
      // 시뮬레이션 AI 응답
      _messages.add(_ChatMessage(
        isUser: false,
        content: '귀하의 질문을 분석 중입니다. 최근 건강 데이터를 기반으로 맞춤형 조언을 제공해 드리겠습니다.',
      ));
    });
    
    _controller.clear();
  }
}

class _ChatMessage {
  final bool isUser;
  final String content;

  _ChatMessage({required this.isUser, required this.content});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message.isUser 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: message.isUser ? Colors.white : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============ 더보기 페이지 ============
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('더보기')),
      body: ListView(
        children: [
          // 프로필 섹션
          ListTile(
            leading: const CircleAvatar(
              radius: 30,
              child: Icon(Icons.person, size: 30),
            ),
            title: const Text('테스트 사용자'),
            subtitle: const Text('test@example.com'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          
          // 메뉴 그룹
          _MoreMenuItem(icon: Icons.store, title: '마켓플레이스'),
          _MoreMenuItem(icon: Icons.video_call, title: '원격 진료'),
          _MoreMenuItem(icon: Icons.forum, title: '커뮤니티'),
          const Divider(),
          
          _MoreMenuItem(icon: Icons.devices, title: '연결된 리더기'),
          _MoreMenuItem(icon: Icons.family_restroom, title: '가족 관리'),
          _MoreMenuItem(icon: Icons.backup, title: '데이터 백업'),
          const Divider(),
          
          _MoreMenuItem(icon: Icons.settings, title: '설정'),
          _MoreMenuItem(icon: Icons.help, title: '도움말'),
          _MoreMenuItem(icon: Icons.info, title: '앱 정보'),
        ],
      ),
    );
  }
}

class _MoreMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MoreMenuItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title 선택됨')),
        );
      },
    );
  }
}
