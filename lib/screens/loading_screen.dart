import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/location_story_screen.dart';
import 'package:yonaki/screens/program_screen.dart';
import 'package:yonaki/screens/walk_screen.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'loading';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  UnityWidgetController _unityWidgetController;

  @override
  void dispose() {
    super.dispose();
    _unityWidgetController.pause();
  }

  @override
  Widget build(BuildContext context) {
    final _yonakiProvider = Provider.of<YonakiProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height,
              width: size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      child: Text('歩く画面へ'),
                      onPressed: () =>
                          Navigator.pushNamed(context, WalkScreen.id),
                    ),
                    MaterialButton(
                      child: Text('プログラム画面へ'),
                      onPressed: () =>
                          Navigator.pushNamed(context, ProgramScreen.id),
                    ),
                    MaterialButton(
                      child: Text('ロケーションストーリー'),
                      onPressed: () =>
                          Navigator.pushNamed(context, LocationStoryScreen.id),
                    ),
                  ],
                ),
              ),
            ),

            // Unity初回起動時のラグを解決するために隠して起動
            Container(
              height: size.height,
              width: size.width,
              child: UnityWidget(
                onUnityViewCreated: _onUnityCreated,
                onUnityMessage: (controller, message) =>
                    _yonakiProvider.unityListenerService.listen(message),
              ),
            ),
          ],
        ),
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  void _onUnityCreated(controller) {
    print('unityがLoadingで生成されました');
    _unityWidgetController = controller;
  }
}
