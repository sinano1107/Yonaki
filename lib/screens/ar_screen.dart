import 'package:flutter/material.dart';
import 'package:yonaki/screens/walk_screen.dart';
import 'package:yonaki/services/director_service.dart';
import 'package:yonaki/services/story_service.dart';
import 'package:yonaki/services/unity_listener_service.dart';

class ARScreen extends StatelessWidget {
  static const String id = 'AR';
  final _directorService = DirectorService(
    programList: [
      '''{"process": "setObject", "object": "Sphere"}''',
      '''{"process": "setObject", "object": "Cube"}''',
      '''{"process": "unKnown"}''',
    ],
  );
  final _unityListenerService = UnityListenerService(
    next: () => print('次へ移れと言われました'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('AR画面(仮)'),
            MaterialButton(
              child: Text('テスト用戻るボタン'),
              onPressed: () => Navigator.pushReplacementNamed(context, WalkScreen.id),
            ),
            MaterialButton(
              child: Text('テスト用ダイアログボタン'),
              onPressed: () => StoryService().showStory(context, [
                'まさきくんは\nうんこをしました',
                'とても気持ち良い脱糞でした。\nあ〜すっきりした〜！！',
              ]),
            ),
            MaterialButton(
              child: Text('テスト用ディレクタースタートボタン'),
              onPressed: () => _directorService.start(),
            ),
            MaterialButton(
              child: Text('テスト用ディレクターネクストボタン'),
              onPressed: () => _directorService.next(),
            ),
            MaterialButton(
              child: Text('テスト用UnityからのNextリクエスト発生ボタン'),
              onPressed: () => _unityListenerService.listen('next'),
            ),
          ],
        ),
      ),
    );
  }
}
