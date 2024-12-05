import 'package:flutter/cupertino.dart';

class BottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  final int selectedIndex;

  const BottomNavBar({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      currentIndex: selectedIndex,
      onTap: onTabChange,
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoColors.inactiveGray,
      backgroundColor: CupertinoColors.systemBackground,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.doc_text),
          label: 'Form',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.list_dash),
          label: 'List',
        ),
      ],
    );
  }
}