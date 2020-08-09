import 'package:flutter/material.dart';

class ProgramDropdown extends StatefulWidget {
  final String name;
  final List<String> keys;
  final String val;
  final Function onChanged;

  ProgramDropdown({
    @required this.name,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.name),
            flex: 1,
          ),
          Expanded(
            child: DropdownButton(
              value: dropdownValue,
              onChanged: (String newValue) {
                widget.onChanged(newValue);
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: widget.keys
                  .map(
                    (String value) => DropdownMenuItem(
                      value: value,
                      child: SizedBox(
                        width: 150,
                          child: Text(
                        value,
                        textAlign: TextAlign.center,
                      )),
                    ),
                  )
                  .toList(),
              dropdownColor: Colors.blueGrey,
              iconEnabledColor: Colors.blueGrey,
            ),
            flex: 3,
          ),
        ],
      ),
    );
  }
}
