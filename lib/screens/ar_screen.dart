import 'package:flutter/material.dart';
import 'package:yonaki/screens/walk_screen.dart';

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
          ],
        ),
      ),
    );
  }
}
