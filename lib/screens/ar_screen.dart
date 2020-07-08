import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/walk_screen.dart';
import 'package:yonaki/services/director_service.dart';

class ARScreen extends StatefulWidget {
  static const String id = 'AR';

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  YonakiProvider _yonakiProvider;
  UnityWidgetController _unityWidgetController;

  @override
  void dispose() {
    super.dispose();
    _unityWidgetController.pause();
  }

  @override
  Widget build(BuildContext context) {
    _yonakiProvider = Provider.of<YonakiProvider>(context);

    return Column(
      children: [
        Expanded(
          child: UnityWidget(
            onUnityViewCreated: (controller) =>
                onUnityCreated(controller, context),
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

  void onUnityCreated(
      UnityWidgetController controller, BuildContext context) async {
    this._unityWidgetController = controller;
    // シーンを再ロード
    _unityWidgetController.postMessage('GameDirector', 'Restart', '');

    // すぐにディレクターが起動すると正しく動作しないため1秒後に実行
    await Future.delayed(Duration(seconds: 1));

    // ディレクターを生成
    final directorService = DirectorService(
      context: context,
      unityWidgetController: controller,
      programList: [
        '''{"process": "setObject", "name": "Cube"}''',
        '''{"process": "showStory", "stories": ["綺麗なキューブを拾った。", "なぜこんな道端に場違いなキューブがあるのだろう..."]}''',
      ],
    );

    // ディレクタースタート
    directorService.start();

    // unityListenerのnext関数を変更
    _yonakiProvider.editUnityListenerNext(() => directorService.next());
  }
}
