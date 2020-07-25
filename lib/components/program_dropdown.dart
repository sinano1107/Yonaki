import 'package:flutter/material.dart';

class ProgramDropdown extends StatefulWidget {
  final List<String> keys;
  final String val;
  final Function onChanged;

  ProgramDropdown({
    @required this.keys,
    @required this.val,
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
    dropdownValue = widget.val == null ? widget.keys[0] : widget.val;
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
