import 'package:flutter/cupertino.dart';

class BirthDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const BirthDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  void showDatePicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // picker itself
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: selectedDate,
                  mode: CupertinoDatePickerMode.date,
                  maximumDate: DateTime.now(),
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year,
                  onDateTimeChanged: onDateChanged,
                ),
              ),
              CupertinoButton(
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Text(
        '${selectedDate.month}-${selectedDate.day}-${selectedDate.year}',
        style: const TextStyle(fontSize: 18),
      ),
      onPressed: () => showDatePicker(context),
    );
  }
}