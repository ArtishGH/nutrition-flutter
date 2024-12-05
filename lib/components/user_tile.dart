import 'package:flutter/cupertino.dart';
import '../database/db_helper.dart';
import '../pages/user_page.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onDelete;

  const UserTile({super.key, required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(user['id']),
      background: Container(
        color: CupertinoColors.systemRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          CupertinoIcons.delete,
          color: CupertinoColors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        DBHelper.instance.deleteUser(user['id']);
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('User deleted'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        onDelete(); // Reload the user list
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: CupertinoColors.systemFill.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.person_fill,
              size: 32,
              color: CupertinoColors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '${user['name']} ${user['surname']}',
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => UserPage(
                      user: user,
                      onUserDeleted: onDelete,
                    ),
                  ),
                );
              },
              child: const Icon(
                CupertinoIcons.forward,
                color: CupertinoColors.activeBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}