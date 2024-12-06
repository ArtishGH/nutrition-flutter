import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'package:czajka_nutrition_cupertino/components/cupertino_button.dart';

class UserPage extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onUserDeleted;

  const UserPage({super.key, required this.user, required this.onUserDeleted});

  double calculateBMI(double weight, double height) {
    if (height <= 0) return 0;
    return weight / ((height / 100) * (height / 100));
  }

  // delete the current user form the database
  Future<void> deleteCurrentUser(BuildContext context) async {
    await DBHelper.instance.deleteUser(user['id']);
    _showCupertinoDialog(context, 'User successfully deleted from the database',
        CupertinoColors.destructiveRed);
    onUserDeleted();
    Navigator.pop(context);
  }

  void _showCupertinoDialog(
      BuildContext context, String message, Color backgroundColor) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('User deleted'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double weight = double.tryParse(user['weight'].toString()) ?? 0.0;
    final double height = double.tryParse(user['height'].toString()) ?? 0.0;
    final double bmi = calculateBMI(weight, height);
    final String bmiCategory = _getBMICategory(bmi);
    final double bmiPercentage = (bmi - 10) / (40 - 10); // Map to 0-1 scale

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text(
          '${user['name']} ${user['surname']}',
          style: const TextStyle(color: CupertinoColors.white, fontSize: 18),
        ),
      ),
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Summary',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.person_fill,
                      color: CupertinoColors.systemGrey,
                      size: 32,
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Details',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 18,
                  ),
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    CupertinoListTile.notched(
                      title: const Text('BMI'),
                      leading: const Icon(
                        CupertinoIcons.person_fill,
                        color: CupertinoColors.systemGreen,
                      ),
                      additionalInfo: Text(
                        '${bmi.toStringAsFixed(2)} ($bmiCategory)',
                        style: TextStyle(
                          color: _getBMIColor(bmi),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {},
                    ),
                    CupertinoListTile.notched(
                      title: const Text('Height'),
                      leading: const Icon(
                        Icons.height,
                        color: CupertinoColors.systemGreen,
                      ),
                      additionalInfo: Text('${height.toStringAsFixed(1)} cm'),
                    ),
                    CupertinoListTile.notched(
                      title: const Text('Weight'),
                      leading: const Icon(
                        Icons.fitness_center,
                        color: CupertinoColors.systemTeal,
                      ),
                      additionalInfo: Text('${weight.toStringAsFixed(1)} kg'),
                    ),
                    CupertinoListTile.notched(
                      title: const Text('Gender'),
                      leading: const Icon(
                        CupertinoIcons.person_2_fill,
                        color: CupertinoColors.systemOrange,
                      ),
                      additionalInfo: Text(user['gender']),
                    ),
                    CupertinoListTile.notched(
                      title: const Text('Age'),
                      leading: const Icon(
                        CupertinoIcons.calendar,
                        color: CupertinoColors.systemIndigo,
                      ),
                      additionalInfo: Text('${user['age']} years'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Half Circle BMI Meter
                Center(
                  child: CustomPaint(
                    size: const Size(200, 150), // Half circle size
                    painter: HalfCircleMeterPainter(
                        bmiPercentage, _getBMIColor(bmi)),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    _getMessageBasedOnBMI(bmi),
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: MyCupertinoButton(
                    color: CupertinoColors.destructiveRed,
                    text: 'Delete Profile',
                    onPressed: () => deleteCurrentUser(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal weight';
    if (bmi < 29.9) return 'Overweight';
    return 'Obesity';
  }

  String _getMessageBasedOnBMI(double bmi) {
    if (bmi < 18.5) return 'Consider gaining some weight for a healthier body.';
    if (bmi < 24.9) return 'You have a healthy weight!';
    if (bmi < 29.9) return 'Consider losing some weight for a healthier body.';
    return 'Consult a healthcare provider for weight management.';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return CupertinoColors.systemBlue;
    if (bmi < 24.9) return CupertinoColors.systemGreen;
    if (bmi < 29.9) return CupertinoColors.systemOrange;
    return CupertinoColors.systemRed;
  }
}

class HalfCircleMeterPainter extends CustomPainter {
  final double percentage;
  final Color color;

  HalfCircleMeterPainter(this.percentage, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = CupertinoColors.darkBackgroundGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height);
    final double sweepAngle = 3.14 * percentage; // Sweep only the top half

    // Draw background half-circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14, // Start at the bottom (π radians)
      3.14, // Sweep 180 degrees (half circle)
      false,
      paint,
    );

    // Draw progress half-circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14, // Start at the bottom
      sweepAngle, // Sweep based on percentage
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
