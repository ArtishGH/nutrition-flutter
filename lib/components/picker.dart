import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  final String placeholder;
  final List data;
  final void Function(int) selectOption;

  const Picker(
      {super.key,
      required this.placeholder,
      required this.data,
      required this.selectOption});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  int? selectedWidget;

  void handleOpenPicker() {
    if (selectedWidget == null) {
      setState(() => selectedWidget = 0);
      widget.selectOption(0);
    }
    _showPicker();
  }

  void _showPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: CupertinoColors.darkBackgroundGray,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 50,
                  scrollController: FixedExtentScrollController(
                      initialItem:
                          selectedWidget != null ? selectedWidget! : 0),
                  onSelectedItemChanged: (value) => {
                    widget.selectOption(value),
                    setState(() => selectedWidget = value)
                  },
                  children: widget.data.map<Widget>((item) {
                    return Center(
                      child: Text(
                        item['value'].toString(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTextFormFieldRow(
        placeholder: widget.placeholder,
        readOnly: true,
        onTap: handleOpenPicker,
        controller: TextEditingController(
            text: selectedWidget != null
                ? widget.data[selectedWidget!]['value'].toString()
                : ''));
  }
}
