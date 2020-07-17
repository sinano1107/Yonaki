import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/services/story_service.dart';

class DirectorService {
  final StoryService storyService;
  final UnityWidgetController unityWidgetController;
  final List<String> programList;
  final Function finish;
  int index = 0; // 現在処理している指示のインデックス

  DirectorService({
    @required this.storyService,
    @required this.unityWidgetController,
    @required this.programList,
    @required this.finish,
  });

  void start() {
    _processing(json.decode(programList[0]));
  }

  void next() {
    index += 1;
    if (index < programList.length)
      _processing(json.decode(programList[index]));
    else {
      print('プログラムが終了しました');
      finish();
    }
  }

  void _processing(Map<String, dynamic> program) {
    print('program $program');
    switch (program['process']) {

      // UnityのARオブジェクトを指定
      case 'setObject':
        print('UnityのARオブジェクト ${program['name']} に指定します');
        unityWidgetController.postMessage(
            'GameDirector', 'SetObjectPrefab', program['name']);
        break;

      // オブジェクトを生成
      case 'createObject':
        print('オブジェクトを ${program['space']} よりも外に生成します');
        unityWidgetController.postMessage(
            'GameDirector', 'CreateObject', program['space']);
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
        unityWidgetController.postMessage(
            'GameDirector', 'ResetGauge', '');
        break;

      // ストーリーを表示
      case 'showStory':
        print('ストーリーを表示します ${program['stories']}');
        storyService.showStory(program['stories'], () => next());
        break;

      // 追いかける際のスピードを設定
      case 'setSpeed':
        print('追いかけるスピードを ${program['speed']}% に設定します');
        unityWidgetController.postMessage(
            'GameDirector', 'SetSpeed', program['speed']);
        break;

      // 追いかけてくるオブジェクトを設定
      case 'setChaser':
        print('追いかけてくるオブジェクトを ${program['tag']} に設定します');
        unityWidgetController.postMessage(
            'GameDirector', 'SetChaser', program['tag']);
        break;

      // 追いかけてくるオブジェクトとの当たり判定の距離を設定
      case 'setCollider':
        print('チェイサーとの当たり判定の距離を ${program['collider']} に設定します');
        unityWidgetController.postMessage(
            'GameDirector', 'SetCollider', program['collider']);
        break;

      // アニメのターゲットを設定
      case 'setAnimTarget':
        print('アニメのターゲットを ${program['name']}');
        unityWidgetController.postMessage(
          'GameDirector', 'SetAnimTarget', program['name']);
        break;

      // アニメを設定
      case 'setAnim':
        print("アニメを ${program['num']} に設定します");
        unityWidgetController.postMessage(
          'GameDirector', 'SetAnim', program['num']);
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