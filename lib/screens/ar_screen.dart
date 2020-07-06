import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/screens/walk_screen.dart';

class ARScreen extends StatelessWidget {
  static const String id = 'AR';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: UnityWidget(
            onUnityViewCreated: (controller) => print('unityが起動されました'),
          ),
          flex: 10,
        ),
        Expanded(
          child: Card(
            child: MaterialButton(
              child: Text('テスト用戻るボタン'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, WalkScreen.id),
            ),
          ),
          flex: 1,
        ),
      ],
    );
  }
}
