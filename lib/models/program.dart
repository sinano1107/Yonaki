import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yonaki/components/edit_stories.dart';
import 'package:yonaki/components/program_dropdown.dart';

// パラメーター
class Param {
  String val;
  final Map<String, String> choice;

  Param({
    @required this.choice,
  });
}

// プログラム
class Program {
  final String document;
  final String process;
  final Map<String, Param> params;

  Program({
    @required this.document,
    @required this.process,
    @required this.params,
  });

  // AR画面で動かせる形にencodeする
  Map<String, String> encode() {
    Map<String, String> answer = {'p': process};
    params.forEach((name, param) {
      answer[name] = param.val;
    });

    return answer;
  }

  // パラメーターを編集する
  void editParam(String name, String newVal) {
    params[name].val = newVal;
  }

  // このクラスを編集できるWidgetを返す
  Widget generateWidget(Function removeMe, Key key) {
    List<Widget> paramWidgets = [];
    this.params.forEach((name, param) {
      Widget answer;

      // choiceが空だったら
      if (param.choice == null) {
        param.val = '''["ストーリーを", "表示します"]''';
        answer = EditStories(
          strStories: param.val,
          edit: (List<dynamic> stories) => param.val = json.encode(stories),
        );
      } else {
        final keys = param.choice.keys.toList();
        final values = param.choice.values.toList();

        param.val = values[0];
        answer = ProgramDropdown(
          keys: keys,
          onChanged: (String newValue) => param.val = param.choice[newValue],
        );
      }

      paramWidgets.add(answer);
    });

    return Container(
      key: key,
      width: 300,
      color: Colors.pink,
      child: Column(
        children: <Widget>[
              Row(
                children: [
                  Text(this.process),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => removeMe(),
                  ),
                ],
              ),
            ] +
            paramWidgets,
      ),
    );
  }
}

//------------------------------------------------------------------------------

class SetObject {
  Program program = Program(
    document: '表示するオブジェクトを設定します',
    process: 'setObject',
    params: {
      'name': Param(
        choice: {'目玉': 'Eyeball', 'めなし': 'Menasi'},
      ),
    },
  );
}

class ShowStory {
  Program program = Program(
    document: 'ストーリーを表示します',
    process: 'showStory',
    params: {
      'stories': Param(
        choice: null, // nullだと文字入力ができる
      ),
    },
  );
}
