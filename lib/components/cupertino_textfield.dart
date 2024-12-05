import 'package:flutter/cupertino.dart';

class MyCupertinoTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  const MyCupertinoTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: CupertinoTextField(
        controller: controller,
        placeholder: hintText,
        keyboardType: keyboardType,
        placeholderStyle: const TextStyle(
          color: CupertinoColors.systemGrey,
          fontSize: 16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 16,
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.darkBackgroundGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: CupertinoColors.systemGrey,
            width: 1.0,
          ),
        ),
        cursorColor: CupertinoColors.activeBlue,
      ),
    );
  }
}