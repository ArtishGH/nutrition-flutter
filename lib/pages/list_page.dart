import 'package:czajka_nutrition_cupertino/pages/user_page.dart';
import 'package:flutter/cupertino.dart';
import '../database/db_helper.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  // Load users from the database
  Future<void> loadUsers() async {
    final fetchedUsers = await DBHelper.instance.fetchUsers();
    setState(() {
      users = fetchedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'User List',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: CupertinoColors.black,
      ),
      child: users.isEmpty
          ? const Center(
        child: Text(
          'No users saved.',
          style: TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 18,
          ),
        ),
      )
          : CupertinoListSection.insetGrouped(
        header: const Text(
          'Users',
          style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
        ),
        children: users
            .map(
              (user) => Dismissible(
            key: ValueKey(user['id']),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await DBHelper.instance.deleteUser(user['id']);
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text('User Deleted'),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
              loadUsers(); // Reload the user list
            },
            background: Container(
              color: CupertinoColors.destructiveRed,
              alignment: Alignment.centerRight,
              child: const Icon(
                CupertinoIcons.delete,
                color: CupertinoColors.white,
              ),
            ),
            child: CupertinoListTile(
              key: ValueKey(user['id']),
              leading: const Icon(
                CupertinoIcons.person_fill,
                size: 32,
                color: CupertinoColors.systemGrey,
              ),
              title: Text(
                '${user['name']} ${user['surname']}',
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 18,
                ),
              ),
              trailing: const Icon(
                CupertinoIcons.forward,
                color: CupertinoColors.activeBlue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => UserPage(
                      user: user,
                      onUserDeleted: loadUsers,
                    ),
                  ),
                );
              },
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}