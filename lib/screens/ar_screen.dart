import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/screens/walk_screen.dart';

class ARScreen extends StatefulWidget {
  static const String id = 'AR';

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  UnityWidgetController _unityWidgetController;

  @override
  void dispose() {
    super.dispose();
    _unityWidgetController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: UnityWidget(
            onUnityViewCreated: onUnityCreated,
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

  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
    // シーンを再ロード
    _unityWidgetController.postMessage('GameDirector', 'Restart', '');
  }
}
