import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/walk_screen.dart';
import 'package:yonaki/services/director_service.dart';
import 'package:yonaki/services/story_service.dart';

class ARScreen extends StatefulWidget {
  static const String id = 'AR';

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  YonakiProvider _yonakiProvider;
  UnityWidgetController _unityWidgetController;
  StoryService _storyService;

  // unityWidgetを表示するか
  bool _visible = true;

  @override
  void dispose() {
    super.dispose();
    _unityWidgetController.pause();
  }

  @override
  Widget build(BuildContext context) {
    _yonakiProvider = Provider.of<YonakiProvider>(context);
    _storyService = StoryService(
      context: context,
      fade: () => setState(() => _visible = false),
      visible: () => setState(() => _visible = true),
    );

    return Column(
      children: [
        Expanded(
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: UnityWidget(
              onUnityViewCreated: (controller) =>
                  onUnityCreated(controller, context),
            ),
          ),
          flex: 10,
        ),
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text('テスト用戻るボタン'),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, WalkScreen.id),
                  ),
                  MaterialButton(
                    child: Text('unityWidgetを隠す'),
                    onPressed: () => {
                      setState(() {
                        _visible = !_visible;
                      }),
                    },
                  ),
                ],
              ),
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
      storyService: _storyService,
      unityWidgetController: controller,
      programList: [
        '''{"process": "await"}''', // <= 平面検知してくれるまで待つ
        '''{"process": "setObject", "name": "Sphere"}''',
        '''{"process": "createObject", "space": "0"}''',
        '''{"process": "setTrigger", "trigger": "Find"}''',
        '''{"process": "destroyObject", "tag": "Sphere"}''',
        '''{"process": "showStory", "stories": ["なんだこの丸いの...", "せや！\\n交番に届けたろ！！"]}''',
        '''{"process": "setObject", "name": "Sasuke"}''',
        '''{"process": "createObject", "space": "2"}''',
        '''{"process": "setTrigger", "trigger": "Find"}''',
        '''{"process": "showStory", "stories": ["なんだあいつ"]}''',
        '''{"process": "setCollider", "collider": "0.5"}''',
        '''{"process": "setSpeed", "speed": "50"}''',
        '''{"process": "setAnimTarget", "name": "Sasuke"}''',
        '''{"process": "setAnim", "num": "1"}''',
        '''{"process": "setChaser", "tag": "Sasuke"}''',
        '''{"process": "await"}''',
        '''{"process": "destroyObject", "tag": "Sasuke"}''',
        '''{"process": "showStory", "stories": ["変な恐竜に襲われた", "あいつの卵だったのかな..."]}''',
      ],
    );

    // ディレクタースタート
    directorService.start();

    // unityListenerのnext関数を変更
    _yonakiProvider.editUnityListenerNext(() => directorService.next());
  }
}
