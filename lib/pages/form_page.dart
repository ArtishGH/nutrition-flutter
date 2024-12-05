import 'package:flutter/cupertino.dart';
import '../components/cupertino_button.dart';
import '../components/cupertino_textfield.dart';
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

  Future<void> saveUser() async {
    try {
      final user = {
        'name': nameController.text,
        'surname': surnameController.text,
        'age': int.parse(ageController.text),
        'height': double.parse(heightController.text),
        'gender': genderController.text,
        'weight': double.parse(weightController.text),
      };

      await DBHelper.instance.insertUser(user);

      // Show success message
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Success'),
            content: const Text('User saved successfully!'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true); // Return `true` to signal refresh
                },
              ),
            ],
          );
        },
      );

      // Clear fields after saving
      nameController.clear();
      surnameController.clear();
      ageController.clear();
      heightController.clear();
      genderController.clear();
      weightController.clear();
    } catch (e) {
      // Handle errors
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill out all fields correctly.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Form Page', style: TextStyle(fontSize: 20),),
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
              MyCupertinoTextField(controller: nameController, hintText: 'Name'),
              MyCupertinoTextField(controller: surnameController, hintText: 'Surname'),
              MyCupertinoTextField(controller: ageController, hintText: 'Age', keyboardType: TextInputType.number),
              MyCupertinoTextField(controller: heightController, hintText: 'Height', keyboardType: TextInputType.number),
              MyCupertinoTextField(controller: genderController, hintText: 'Gender'),
              MyCupertinoTextField(controller: weightController, hintText: 'Weight', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              MyCupertinoButton(
                text: 'Save to Database',
                onPressed: saveUser,
                color: CupertinoColors.activeBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}