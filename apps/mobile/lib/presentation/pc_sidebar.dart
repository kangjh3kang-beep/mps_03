import 'package:flutter/material.dart';

class PCSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const PCSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: true,
      backgroundColor: Colors.slate[950],
      selectedIconTheme: const IconThemeData(color: Colors.cyan),
      unselectedIconTheme: const IconThemeData(color: Colors.slate),
      selectedLabelTextStyle: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
      unselectedLabelTextStyle: const TextStyle(color: Colors.slate),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text('홈')),
        NavigationRailDestination(icon: Icon(Icons.biotech), label: Text('측정')),
        NavigationRailDestination(icon: Icon(Icons.medical_services), label: Text('AI주치의')),
        NavigationRailDestination(icon: Icon(Icons.family_restroom), label: Text('마이데이터')),
        NavigationRailDestination(icon: Icon(Icons.forum), label: Text('커뮤니티')),
        NavigationRailDestination(icon: Icon(Icons.settings), label: Text('설정')),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
