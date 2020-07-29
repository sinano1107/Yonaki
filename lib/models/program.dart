import 'dart:convert';
import 'package:quiver/iterables.dart';

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
  final Color color;

  Program({
    @required this.document,
    @required this.process,
    @required this.params,
    @required this.color,
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
        if (param.val == null)
          param.val = '''["ストーリーを", "表示します"]''';
        answer = EditStories(
          strStories: param.val,
          edit: (List<dynamic> stories) => param.val = json.encode(stories),
        );
      } else {
        final keys = param.choice.keys.toList();
        final values = param.choice.values.toList();

        if (param.val == null)
          param.val = values[0];

        answer = ProgramDropdown(
          keys: keys,
          val: param.choice.keys.firstWhere(
            (k) => param.choice[k] == param.val,
            orElse: () => null,
          ), // valからkeyを取得しています
          onChanged: (String newValue) => param.val = param.choice[newValue],
        );
      }

      paramWidgets.add(answer);
    });

    return Container(
      key: key,
      width: 300,
      child: Card(
        color: color,
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
      ),
    );
  }

  Widget generateDrag(dynamic data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        height: 150,
        width: 190,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Card(
                color: color,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Expanded(
                        flex: 1,
                        child: Text(
                          process,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        flex: 3,
                        child: Text(
                          document,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Draggable<dynamic>(
                  data: data,
                  child: Icon(Icons.drag_handle),
                  feedback: this.generateWidget(null, null),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
const _objects = {
  '目玉': 'Eyeball',
  '目無し': 'Menasi',
  '人形': 'Ichimatu',
};

// すべてのプログラムを入れるリスト
final List<dynamic> allProgram = [
  'CreateObject',
  'DestroyObject',
  'SetTrigger',
  'ToggleShowGauge',
  'ResetGauge',
  'ShowStory',
  'StartChase',
  'SetAnim',
  'Await',
];

// 新鮮なプログラムを取得
dynamic getNewProgram(String name) {
  switch (name) {
    case 'CreateObject':
      return CreateObject();
    case 'DestroyObject':
      return DestroyObject();
    case 'SetTrigger':
      return SetTrigger();
    case 'ToggleShowGauge':
      return ToggleShowGauge();
    case 'ResetGauge':
      return ResetGauge();
    case 'ShowStory':
      return ShowStory();
    case 'StartChase':
      return StartChase();
    case 'SetAnim':
      return SetAnim();
    case 'Await':
      return Await();
    default:
      print('指定のプログラムが登録されていません $name');
  }
}

// createObject
class CreateObject {
  Program program = Program(
    document: 'オブジェクトを生成します',
    process: 'createObject',
    params: {
      'name': Param(choice: _objects),
      'space': Param(choice: {
        '0': '0',
        '1': '1',
        '2': '2',
        '3': '3',
        '4': '4',
      }),
    },
    color: Colors.red[100],
  );
}

// destroyObject
class DestroyObject {
  Program program = Program(
    document: '指定のオブジェクトを破壊します',
    process: 'destroyObject',
    params: {
      'tag': Param(choice: _objects),
    },
    color: Colors.red[200],
  );
}

// setTrigger
class SetTrigger {
  Program program = Program(
    document: '次の処理に移る条件を設定します',
    process: 'setTrigger',
    params: {
      'trigger': Param(choice: {
        '見つけた時': 'Find',
        '拾った時': 'PickUp',
      }),
    },
    color: Colors.red[300],
  );
}

// toggleShowGauge {
class ToggleShowGauge {
  Program program = Program(
    document: 'ゲージの表示を切り替えます',
    process: 'toggleShowGauge',
    params: {},
    color: Colors.red[400],
  );
}

// resetGauge
class ResetGauge {
  Program program = Program(
    document: 'ゲージの値をリセットします',
    process: 'ResetGauge',
    params: {},
    color: Colors.red[500],
  );
}

// showStory
class ShowStory {
  Program program = Program(
    document: 'ストーリーを表示します',
    process: 'showStory',
    params: {
      'stories': Param(
        choice: null, // nullだと文字入力ができる
      ),
    },
    color: Colors.red[600],
  );
}

// startChase
class StartChase {
  Program program = Program(
    document: '追いかけっこを開始します',
    process: 'startChase',
    params: {
      'tag': Param(
        choice: _objects,
      ),
      'speed': Param(
        choice: Map.fromIterable(
          range(1, 201),
          key: (e) => '$e %',
          value: (e) => e.toString(),
        ),
      ),
      'collider': Param(
        choice: Map.fromIterable(
          range(1, 101),
          key: (e) => (e / 100).toString(),
          value: (e) => (e / 100).toString(),
        ),
      ),
    },
    color: Colors.red[700],
  );
}

// setAnim
class SetAnim {
  Program program = Program(
    document: 'オブジェクトのアニメーションを設定します',
    process: 'setAnim',
    params: {
      'name': Param(choice: _objects),
      'num': Param(choice: {
        '待つ': '0',
        '歩く': '1',
      }),
    },
    color: Colors.red[800],
  );
}

// await
class Await {
  Program program = Program(
    document: 'オブジェクトに捕まるまで待ちます',
    process: 'await',
    params: {},
    color: Colors.red[900],
  );
}
