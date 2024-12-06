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

  int selectedAgeIndex = 0;
  int selectedHeightIndex = 70;
  int selectedGenderIndex = 0;
  int selectedWeightIndex = 40;

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

  Future<void> saveUser() async {
    final currentYear = DateTime.now().year;
    final selectedYear = int.parse(ages[selectedAgeIndex]['value']);
    final age = currentYear - selectedYear;

    final int height =
        int.parse(heights[selectedHeightIndex]['value'].replaceAll(' cm', ''));
    final int weight =
        int.parse(weights[selectedWeightIndex]['value'].replaceAll(' kg', ''));

    final user = {
      'name': nameController.text,
      'surname': surnameController.text,
      'age': age,
      'height': height,
      'gender': genders[selectedGenderIndex]['value'],
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

      // clear fields after saving
      nameController.clear();
      surnameController.clear();
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
                selectOption: (index) {
                  setState(() {
                    selectedAgeIndex = index;
                  });
                },
              ),
              const SizedBox(height: 12),
              Picker(
                placeholder: 'Height',
                data: heights,
                selectOption: (index) {
                  setState(() {
                    selectedHeightIndex = index;
                  });
                },
              ),
              const SizedBox(height: 12),
              Picker(
                placeholder: 'Gender',
                data: genders,
                selectOption: (index) {
                  setState(() {
                    selectedGenderIndex = index;
                  });
                },
              ),
              const SizedBox(height: 12),
              Picker(
                placeholder: 'Weight',
                data: weights,
                selectOption: (index) {
                  setState(() {
                    selectedWeightIndex = index;
                  });
                },
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                borderRadius: BorderRadius.circular(12),
                onPressed: saveUser,
                child: const Text(
                  'Save to Database',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
