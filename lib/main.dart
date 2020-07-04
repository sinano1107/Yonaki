import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

void main() => runApp(Yonaki());

class Yonaki extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Unityブランチ'),
        ),
        body: UnityWidget(
          onUnityViewCreated: (controller) => print('Unityが生成されました'),
        ),
      ),
    );
  }
}
