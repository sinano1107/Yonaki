import 'package:flutter/material.dart';
import 'package:yonaki/screens/walk_screen.dart';
import 'package:yonaki/services/story_service.dart';

class ARScreen extends StatelessWidget {
  static const String id = 'AR';

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
          ],
        ),
      ),
    );
  }
}
