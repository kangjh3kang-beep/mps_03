import 'package:flutter/material.dart';
import 'screens/measurement_screen.dart';
import 'screens/ai_coaching_screen.dart';
import 'screens/family_management_screen.dart';
import 'screens/video_consultation_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/measurement_selection_screen.dart';
import 'screens/ai_coaching_menu_screen.dart';
import 'screens/pc_dashboard_screen.dart';
import 'screens/reader_mode_screen.dart';
import 'responsive_layout.dart';
import 'pc_sidebar.dart';
import '../services/ai_physician.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ResponsiveLayout(
      mobileBody: HomeScreen(),
      pcBody: PCDashboardScreen(),
      readerBody: ReaderModeScreen(),
    ),
    const MeasurementSelectionScreen(),
    const AICoachingMenuScreen(),
    const FamilyManagementScreen(),
    const VideoConsultationScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.slate[950],
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.slate[500],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.biotech), label: '측정'),
            BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'AI주치의'),
            BottomNavigationBarItem(icon: Icon(Icons.family_restroom), label: '마이데이터'),
            BottomNavigationBarItem(icon: Icon(Icons.forum), label: '커뮤니티'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
        ),
      ),
      pcBody: Scaffold(
        body: Row(
          children: [
            PCSidebar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
      readerBody: const ReaderModeScreen(),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;
  const PlaceholderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: const TextStyle(fontSize: 24, color: Colors.slate400)),
    );
  }
}
