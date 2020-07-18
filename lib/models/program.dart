import 'package:flutter/foundation.dart';

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

  Map<String, dynamic> encode() {
    Map<String, dynamic> answer = {'p': process};
    params.forEach((name, param) {
      answer[name] = param.val;
    });

    return answer;
  }

  void editParam(String name, String newVal) {
    params[name].val = newVal;
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
