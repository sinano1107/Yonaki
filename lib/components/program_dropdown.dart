import 'package:flutter/material.dart';

class ProgramDropdown extends StatefulWidget {
  final List<String> keys;
  final Function onChanged;

  ProgramDropdown({
    @required this.keys,
    @required this.onChanged,
  });

  @override
  _ProgramDropdownState createState() => _ProgramDropdownState();
}

class _ProgramDropdownState extends State<ProgramDropdown> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.keys[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue,
      onChanged: (String newValue) {
        widget.onChanged(newValue);
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: widget.keys.map(
            (String value) => DropdownMenuItem(
          value: value,
          child: Text(value),
        ),
      ).toList(),
    );
  }
}
