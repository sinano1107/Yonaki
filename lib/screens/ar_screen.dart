import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/screens/walk_screen.dart';
import 'package:yonaki/services/director_service.dart';
import 'package:yonaki/services/unity_listener_service.dart';

class ARScreen extends StatefulWidget {
  static const String id = 'AR';

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  UnityWidgetController _unityWidgetController;
  DirectorService _directorService;

  @override
  void dispose() {
    super.dispose();
    print('unityを中止');
    _unityWidgetController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: UnityWidget(
            onUnityViewCreated: (controller) => onUnityCreated(controller, context),
            onUnityMessage: onUnityMessage,
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

  void onUnityCreated(UnityWidgetController controller, BuildContext context) async {
    this._unityWidgetController = controller;
    // unityを再開
    _unityWidgetController.resume();
    // シーンを再ロード
    _unityWidgetController.postMessage('GameDirector', 'Restart', '');

    // ディレクターを生成
    _directorService = DirectorService(
      context: context,
      unityWidgetController: controller,
      programList: [
        '''{"process": "setObject", "name": "Cube"}''',
        '''{"process": "showStory", "stories": ["綺麗なキューブを拾った。", "なぜこんな道端に場違いなキューブがあるのだろう..."]}''',
      ],
    );

    // すぐにディレクターが起動すると正しく動作しないため1秒後に実行
    await Future.delayed(Duration(seconds: 1));

    // ディレクタースタート
    _directorService.start();
  }

  void onUnityMessage(controller, message) {
    print(message);
    UnityListenerService(next: () {
      print('next');
    });
  }
}
