import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/location_story_screen.dart';
import 'package:yonaki/screens/post_object_screen.dart';
import 'package:yonaki/screens/program_screen.dart';
import 'package:yonaki/screens/walk_screen.dart';

const double _width = 200;

class LoadingScreen extends StatefulWidget {
  static const String id = 'title';

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
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: size.height,
                width: size.width,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 150, bottom: 100),
                        child: Text(
                          '夜亡キ',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 100,
                          ),
                        ),
                      ),
                      MaterialButton(
                        child: Text('あるく'),
                        minWidth: _width,
                        color: Colors.red,
                        shape: StadiumBorder(),
                        onPressed: () =>
                            Navigator.pushNamed(context, WalkScreen.id),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        child: Text('恐怖体験を調べる'),
                        minWidth: _width,
                        color: Colors.red,
                        shape: StadiumBorder(),
                        onPressed: () => Navigator.pushNamed(
                            context, LocationStoryScreen.id),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        child: Text('恐怖体験を投稿する'),
                        minWidth: _width,
                        color: Colors.red,
                        shape: StadiumBorder(),
                        onPressed: () =>
                            Navigator.pushNamed(context, ProgramScreen.id),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        child: Text('幽霊を投稿する'),
                        minWidth: _width,
                        color: Colors.red,
                        shape: StadiumBorder(),
                        onPressed: () =>
                            Navigator.pushNamed(context, PostObjectScreen.id),
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
