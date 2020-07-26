import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/services/story_service.dart';

class DirectorService {
  final StoryService storyService;
  final UnityWidgetController unityWidgetController;
  final List<Map<String, dynamic>> programList;
  final Function finish;
  int index = 0; // 現在処理している指示のインデックス

  DirectorService({
    @required this.storyService,
    @required this.unityWidgetController,
    @required this.programList,
    @required this.finish,
  });

  void start() {
    _processing(programList[0]);
  }

  void next() {
    index += 1;
    if (index < programList.length)
      _processing(programList[index]);
    else {
      print('プログラムが終了しました');
      finish();
    }
  }

  void _processing(Map<String, dynamic> program) {
    print('program $program');
    switch (program['p']) {

      // オブジェクトを生成
      case 'createObject':
        print('オブジェクト ${program['name']} を ${program['space']} よりも外に生成します');
        unityWidgetController.postMessage('GameDirector', 'CreateObject',
            json.encode({'name': program['name'], 'space': program['space']}));
        break;

      // オブジェクトを削除
      case 'destroyObject':
        print('${program['tag']} を削除します');
        unityWidgetController.postMessage(
            'GameDirector', 'DestroyObject', program['tag']);
        break;

      // nextのトリガーを設定
      case 'setTrigger':
        print('NextのTriggerを ${program['trigger']} に設定します');
        unityWidgetController.postMessage(
            'GameDirector', 'SetTrigger', program['trigger']);
        break;

      // ゲージの表示切り替え
      case 'toggleShowGauge':
        print('ゲージの表示を切り替えます');
        unityWidgetController.postMessage(
            'GameDirector', 'ToggleShowGauge', '');
        break;

      // ゲージのリセット
      case 'resetGauge':
        print('ゲージをリセットします');
        unityWidgetController.postMessage('GameDirector', 'ResetGauge', '');
        break;

      // ストーリーを表示
      case 'showStory':
        print('ストーリーを表示します ${program['stories']}');
        storyService.showStory(json.decode(program['stories']), () => next());
        break;

      // 追いかけっこをスタート
      case 'startChase':
        print(
            '${program['tag']} が ${program['speed']}% の速さで追いかけてきます。 当たり判定は ${program['collider']} です');
        unityWidgetController.postMessage(
            'GameDirector',
            'StartChase',
            json.encode({
              'tag': program['tag'],
              'newSpeed': program['speed'],
              'newCollider': program['collider']
            }));
        break;

      // アニメを設定
      case 'setAnim':
        print("${program['name']} のアニメを ${program['num']} に設定します");
        unityWidgetController.postMessage('GameDirector', 'SetAnim',
            jsonEncode({'name': program['name'], 'num': program['num']}));
        break;

      // 次のnextがくるまで待つ
      case 'await':
        print('次のnextがくるまで待ちます');
        break;

      // エラー
      default:
        print('未知の処理を受け取りました。問題がないか確認してください\nprogram: $program');
    }
  }
}
