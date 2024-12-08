import 'package:flutter/cupertino.dart';
import '../components/picker.dart';
import '../database/db_helper.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  final List<Map<String, dynamic>> ages = List.generate(
      120, (index) => {'value': (DateTime.now().year - index).toString()});
  final List<Map<String, dynamic>> heights =
      List.generate(201, (index) => {'value': '${100 + index} cm'});
  final List<Map<String, dynamic>> genders = [
    {'value': 'Male'},
    {'value': 'Female'},
  ];
  final List<Map<String, dynamic>> weights =
      List.generate(101, (index) => {'value': '${30 + index} kg'});

  bool isNameValid(String name) {
    return name.isNotEmpty && RegExp(r'^[a-zA-Z]+$').hasMatch(name);
  }

  Future<void> saveUser() async {
    final String name = nameController.text.trim();
    final String surname = surnameController.text.trim();

    if (!isNameValid(name) || !isNameValid(surname)) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please enter a valid name and surname (letters only).'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    final int currentYear = DateTime.now().year;
    final int selectedYear = int.parse(ageController.text);
    final int age = currentYear - selectedYear;

    final int height = int.parse(heightController.text.replaceAll(' cm', ''));
    final int weight = int.parse(weightController.text.replaceAll(' kg', ''));

    final user = {
      'name': name,
      'surname': surname,
      'age': age,
      'height': height,
      'gender': genderController.text,
      'weight': weight,
    };

    try {
      await DBHelper.instance.insertUser(user);

      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('User Added'),
          content: const Text(
              'The user has been successfully added to the database.'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

      // clear all fields after saving
      nameController.clear();
      surnameController.clear();
      ageController.clear();
      heightController.clear();
      genderController.clear();
      weightController.clear();
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Failed to save user: $e'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Form Page', style: TextStyle(fontSize: 20)),
        backgroundColor: CupertinoColors.black,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 56),
              const Icon(
                CupertinoIcons.collections,
                size: 80,
                color: CupertinoColors.activeBlue,
              ),
              const SizedBox(height: 40),
              CupertinoTextField(
                controller: nameController,
                placeholder: 'Name',
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: surnameController,
                placeholder: 'Surname',
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              Picker(
                placeholder: 'Age',
                data: ages,
                controller: ageController,
                selectOption: (index) {
                  ageController.text = ages[index]['value'];
                },
              ),
              const SizedBox(height: 12),
              Picker(
                placeholder: 'Height',
                data: heights,
                controller: heightController,
                selectOption: (index) {
                  heightController.text = heights[index]['value'];
                },
              ),
              const SizedBox(height: 12),
              Picker(
                placeholder: 'Gender',
                data: genders,
                controller: genderController,
                selectOption: (index) {
                  genderController.text = genders[index]['value'];
                },
              ),
              const SizedBox(height: 12),
              Picker(
                placeholder: 'Weight',
                data: weights,
                controller: weightController,
                selectOption: (index) {
                  weightController.text = weights[index]['value'];
                },
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                borderRadius: BorderRadius.circular(12),
                onPressed: saveUser,
                child: const Text(
                  'Add User',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
