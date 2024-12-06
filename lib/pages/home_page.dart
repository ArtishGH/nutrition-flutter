import 'package:flutter/cupertino.dart';

import 'form_page.dart';
import 'list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
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
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) => const FormPage(),
            );
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) => const ListPage(),
            );
          default:
            return CupertinoTabView(
              builder: (BuildContext context) => const FormPage(),
            );
        }
      },
    );
  }
}
