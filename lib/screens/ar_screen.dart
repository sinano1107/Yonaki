import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/post_program_screen.dart';
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
    _unityWidgetController.postMessage('GameDirector', 'Sleep', '');
    _unityWidgetController.pause();
  }

  @override
  Widget build(BuildContext context) {
    final ARScreenArgument _arg = ModalRoute.of(context).settings.arguments;
    _yonakiProvider = Provider.of<YonakiProvider>(context);
    _storyService = StoryService(
      context: context,
      fade: () => setState(() => _visible = false),
      visible: () => setState(() => _visible = true),
    );

    return Scaffold(
      appBar: _arg.userProgram == null
          ? null
          : AppBar(
              title: Text('テスト'),
            ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: UnityWidget(
                onUnityViewCreated: (controller) => onUnityCreated(
                    controller, context, _arg.userProgram, _arg.isLocation),
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
                      onPressed: _arg.userProgram == null
                          ? () => Navigator.pushReplacementNamed(
                              context, WalkScreen.id)
                          : () => Navigator.pop(context),
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
      ),
    );
  }

  void onUnityCreated(UnityWidgetController controller, BuildContext context,
      List<Map<String, dynamic>> userProgram, bool isLocation) async {
    this._unityWidgetController = controller;
    // ゲームシーンをロード
    _unityWidgetController.postMessage('SleepDirector', 'Restart', '');

    // すぐにディレクターが起動すると正しく動作しないため1秒後に実行
    await Future.delayed(Duration(seconds: 1));

    // ディレクターを生成
    final directorService = DirectorService(
      storyService: _storyService,
      unityWidgetController: controller,
      programList: <Map<String, dynamic>>[
            {"p": "await"}
          ] +
          (userProgram == null ? _yonakiProvider.story.program : userProgram),
      finish: userProgram == null
          ? () {
              _yonakiProvider.story.next();
              Navigator.pushReplacementNamed(context, WalkScreen.id);
            }
          : isLocation
              ? () => Navigator.pop(context)
              : () => Navigator.pushNamed(context, PostProgramScreen.id,
                  arguments: PostProgramScreenArgument(userProgram)),
    );

    // ディレクタースタート
    directorService.start();

    // unityListenerのnext関数を変更
    _yonakiProvider.editUnityListenerNext(() => directorService.next());
  }
}

class ARScreenArgument {
  final List<Map<String, dynamic>> userProgram;
  final bool isLocation;

  ARScreenArgument({
    @required this.userProgram,
    @required this.isLocation,
  });
}
