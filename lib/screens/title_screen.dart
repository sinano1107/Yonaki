import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/location_story_screen.dart';
import 'package:yonaki/screens/post_object_screen.dart';
import 'package:yonaki/screens/program_screen.dart';
import 'package:yonaki/screens/walk_screen.dart';

const double _width = 200;

class TitleScreen extends StatefulWidget {
  static const String id = 'title';

  @override
  _TitleScreenState createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  UnityWidgetController _unityWidgetController;

  // サインインに必要なもの
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _signing = true;

  @override
  void initState() {
    super.initState();
    // サインイン
    _signIn();
  }

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
      body: ModalProgressHUD(
        inAsyncCall: _signing,
        child: SingleChildScrollView(
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
                        SizedBox(height: 10),
                        MaterialButton(
                          child: Text('サインアウト'),
                          minWidth: _width - 100,
                          color: Colors.blue,
                          shape: StadiumBorder(),
                          onPressed: () => _auth.signOut().then((message) {
                            print('_auth サインアウトしました');
                            _googleSignIn.signOut().then((message2) {
                              print('_googleSignIn サインアウトしました');
                              setState(() => _signing = true);
                              _signIn();
                            }).catchError((e) => print('_googleSignIn $e'));
                          }).catchError((e) => print('_auth $e')),
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
      ),
    );
  }

  void _onUnityCreated(controller) {
    print('unityがTitleで生成されました');
    _unityWidgetController = controller;
  }

  // サインイン関数
  void _signIn() {
    _handleSignIn().then((FirebaseUser user) {
      if (user != null)
        setState(() => _signing = false);
      else
        _showFailedSignIn();
    }).catchError((e) => print(e));
  }

  // ハンドルサインイン
  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth =
          await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print('signed in ${user.displayName}');

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // サインイン失敗時のダイアログ
  void _showFailedSignIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'サインインに失敗しました',
          style: TextStyle(color: Colors.red),
        ),
        content: Text('下のボタンを押してもう一度サインインしてください'),
        actions: [
          FlatButton(
            child: Text('サインイン'),
            onPressed: () {
              Navigator.pop(context);
              _signIn();
            },
          ),
        ],
      ),
    );
  }
}
