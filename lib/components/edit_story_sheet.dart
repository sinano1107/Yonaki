import 'package:flutter/material.dart';

class EditStorySheet extends StatefulWidget {
  final String story;
  final Function onChanged;
  final Function dispose;

  EditStorySheet({
    @required this.story,
    @required this.onChanged,
    @required this.dispose,
  });

  @override
  _EditStorySheetState createState() => _EditStorySheetState();
}

class _EditStorySheetState extends State<EditStorySheet> {
  String value;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    value = widget.story;
    _textEditingController = TextEditingController(text: value);
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _textEditingController,
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (String newValue) => widget.onChanged(newValue),
          ),
        ],
      ),
    );
  }
}
