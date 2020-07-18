import 'package:flutter/material.dart';
import 'package:yonaki/models/program.dart';

class ProgramScreen extends StatelessWidget {
  static const String id = "program";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          child: Text('テストボタン'),
          onPressed: () {
            final setObject = SetObject();
            setObject.program.editParam('name', '設定するオブジェクトの名前');
            print(setObject.program.encode().toString());

            final showStory = ShowStory();
            showStory.program.editParam('stories', '''["表示するストーリー"]''');
            print(showStory.program.encode().toString());
          },
        ),
      ),
    );
  }
}
