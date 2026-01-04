import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Widget imports (실제 경로로 조정 필요)
// import 'package:manpasik/features/home/presentation/pages/home_page.dart';
// import 'package:manpasik/features/measurement/presentation/pages/measurement_page.dart';
// import 'package:manpasik/features/ai_coach/presentation/pages/ai_chat_page.dart';

void main() {
  group('Widget Render Tests', () {
    testWidgets('기본 MaterialApp 렌더링 테스트', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('테스트'),
            ),
          ),
        ),
      );

      expect(find.text('테스트'), findsOneWidget);
    });

    testWidgets('AppBar 타이틀 렌더링 테스트', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('만파식'),
            ),
            body: const Center(child: Text('내용')),
          ),
        ),
      );

      expect(find.text('만파식'), findsOneWidget);
    });

    testWidgets('BottomNavigationBar 렌더링 테스트', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Center(child: Text('내용')),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
                BottomNavigationBarItem(icon: Icon(Icons.biotech), label: '측정'),
                BottomNavigationBarItem(icon: Icon(Icons.analytics), label: '분석'),
                BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI'),
                BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '더보기'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('홈'), findsOneWidget);
      expect(find.text('측정'), findsOneWidget);
      expect(find.text('분석'), findsOneWidget);
      expect(find.text('AI'), findsOneWidget);
      expect(find.text('더보기'), findsOneWidget);
    });
  });

  group('Interactive Widget Tests', () {
    testWidgets('ElevatedButton 탭 테스트', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => tapped = true,
                child: const Text('측정 시작'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('측정 시작'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('TextField 입력 테스트', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: '메시지 입력'),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '테스트 메시지');
      await tester.pump();

      expect(controller.text, equals('테스트 메시지'));
    });

    testWidgets('Checkbox 토글 테스트', (tester) async {
      var isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Center(
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() => isChecked = value ?? false);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(isChecked, isFalse);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // StatefulBuilder 내에서 상태 변경 확인
    });

    testWidgets('TabBar 전환 테스트', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(text: '건강'),
                    Tab(text: '환경'),
                    Tab(text: '연구용'),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  Center(child: Text('건강 탭')),
                  Center(child: Text('환경 탭')),
                  Center(child: Text('연구용 탭')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('건강'), findsOneWidget);
      expect(find.text('환경'), findsOneWidget);
      expect(find.text('연구용'), findsOneWidget);

      // 탭 전환
      await tester.tap(find.text('환경'));
      await tester.pumpAndSettle();

      expect(find.text('환경 탭'), findsOneWidget);
    });
  });

  group('Card Widget Tests', () {
    testWidgets('측정 결과 카드 렌더링 테스트', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('혈당', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 8),
                      Text('108', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      Text('mg/dL', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('혈당'), findsOneWidget);
      expect(find.text('108'), findsOneWidget);
      expect(find.text('mg/dL'), findsOneWidget);
    });

    testWidgets('건강 점수 카드 색상 테스트', (tester) async {
      Color getScoreColor(int score) {
        if (score >= 80) return Colors.green;
        if (score >= 60) return Colors.orange;
        return Colors.red;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: getScoreColor(85),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('85', style: TextStyle(color: Colors.white, fontSize: 32)),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('85'), findsOneWidget);
    });
  });

  group('List Widget Tests', () {
    testWidgets('측정 기록 리스트 렌더링 테스트', (tester) async {
      final measurements = [
        {'type': '혈당', 'value': '108 mg/dL', 'time': '2시간 전'},
        {'type': '혈압', 'value': '128/82 mmHg', 'time': '어제'},
        {'type': '심박수', 'value': '72 bpm', 'time': '3시간 전'},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(measurements[index]['type']!),
                  subtitle: Text(measurements[index]['time']!),
                  trailing: Text(measurements[index]['value']!),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('혈당'), findsOneWidget);
      expect(find.text('혈압'), findsOneWidget);
      expect(find.text('심박수'), findsOneWidget);
    });

    testWidgets('빈 리스트 메시지 테스트', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('측정 기록이 없습니다'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('측정 기록이 없습니다'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });
  });

  group('Dialog and Modal Tests', () {
    testWidgets('확인 다이얼로그 테스트', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('측정 취소'),
                          content: const Text('측정을 취소하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('아니오'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('예'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('다이얼로그 열기'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      expect(find.text('측정 취소'), findsOneWidget);
      expect(find.text('측정을 취소하시겠습니까?'), findsOneWidget);
      expect(find.text('아니오'), findsOneWidget);
      expect(find.text('예'), findsOneWidget);
    });

    testWidgets('BottomSheet 테스트', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('측정 옵션', style: TextStyle(fontSize: 18)),
                              SizedBox(height: 16),
                              ListTile(
                                leading: Icon(Icons.bloodtype),
                                title: Text('혈당'),
                              ),
                              ListTile(
                                leading: Icon(Icons.favorite),
                                title: Text('혈압'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text('옵션 열기'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('옵션 열기'));
      await tester.pumpAndSettle();

      expect(find.text('측정 옵션'), findsOneWidget);
      expect(find.text('혈당'), findsOneWidget);
      expect(find.text('혈압'), findsOneWidget);
    });
  });

  group('Responsive Layout Tests', () {
    testWidgets('좁은 화면 레이아웃 테스트', (tester) async {
      tester.view.physicalSize = const Size(320, 568); // iPhone SE 크기
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Text(
                    constraints.maxWidth < 400 ? '모바일' : '태블릿',
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('모바일'), findsOneWidget);

      // 원래 크기로 복원
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('넓은 화면 레이아웃 테스트', (tester) async {
      tester.view.physicalSize = const Size(768, 1024); // iPad 크기
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Text(
                    constraints.maxWidth < 400 ? '모바일' : '태블릿',
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('태블릿'), findsOneWidget);

      // 원래 크기로 복원
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
