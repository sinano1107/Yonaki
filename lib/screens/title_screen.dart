import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:file_picker/file_picker.dart';

import 'package:yonaki/components/edit_my_name_screen.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/location_story_screen.dart';
import 'package:yonaki/screens/post_object_screen.dart';
import 'package:yonaki/screens/program_screen.dart';
import 'package:yonaki/screens/walk_screen.dart';
import 'package:yonaki/services/firebase_service.dart';

const double _width = 200;

class TitleScreen extends StatefulWidget {
  static const String id = 'title';

  @override
  _TitleScreenState createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  UnityWidgetController _unityWidgetController;
  YonakiProvider _yonakiProvider;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _signing = true;

  // アイコンURL
  String icon;

  bool isInitiated = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitiated) {
      isInitiated = true;
      _yonakiProvider = Provider.of<YonakiProvider>(context);
      _signIn(); // サインイン
    }
  }

  @override
  void dispose() {
    super.dispose();
    _unityWidgetController.pause();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: _signing,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(top: 40),
                height: 150,
                color: Colors.blueGrey,
                child: _yonakiProvider.myAccountData != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              width: 60,
                              height: 60,
                              child: _yonakiProvider.myIcon != null
                                  ? GestureDetector(
                                      onTap: _yonakiProvider
                                              .myAccountData['defaultIcon']
                                          ? () => _uploadIcon(true)
                                          : () => showDialog(
                                              context: context,
                                              builder: (_) => SimpleDialog(
                                                    title: Text('アイコンを変更'),
                                                    children: [
                                                      SimpleDialogOption(
                                                        onPressed: () {
                                                          _uploadIcon(false);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            'ライブラリからアップロード'),
                                                      ),
                                                      SimpleDialogOption(
                                                        onPressed: () {
                                                          _changeDefaultIcon();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            'デフォルトのアイコンに戻す'),
                                                      ),
                                                    ],
                                                  )),
                                      child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              _yonakiProvider.myIcon)),
                                    )
                                  : CircleAvatar(),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: EditMyNameScreen(),
                                  ),
                                ),
                              ),
                              child: Text(
                                _yonakiProvider.myAccountData['name'],
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height,
                width: size.width,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 100, bottom: 100),
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
                        child: Text('心霊体験を調べる'),
                        minWidth: _width,
                        color: Colors.red,
                        shape: StadiumBorder(),
                        onPressed: () => Navigator.pushNamed(
                            context, LocationStoryScreen.id),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        child: Text('心霊体験を投稿する'),
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
                        onPressed: () async {
                          await _auth.signOut();
                          print('サインアウトしました');
                          setState(() => _signing = true);
                          _signIn();
                        }
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
      ),
    );
  }

  void _onUnityCreated(controller) {
    print('unityがTitleで生成されました');
    _unityWidgetController = controller;
  }

  // サインイン関数
  void _signIn() {
    _handleSignIn().then((FirebaseUser user) async {
      if (user != null) {
        setState(() => _signing = false);
        _yonakiProvider.editUid(user.uid);
        _yonakiProvider
            .editMyAccountData(await FirebaseService().getUserData(user.uid));
        _yonakiProvider.editMyIcon();
      } else
        _showFailedSignIn();
    }).catchError((e) => print(e));
  }

  // ハンドルサインイン
  Future<FirebaseUser> _handleSignIn() async {
    try {
      // サインイン済みの場合
      FirebaseUser user = await _auth.currentUser();
      if (user != null) return user;

      final result = await AppleSignIn.performRequests([
        AppleIdRequest(
          requestedScopes: [Scope.fullName],
          requestedOperation: OpenIdOperation.operationLogin,
        ),
      ]);
      if (result == null) return null;

      const oAuthProvider = OAuthProvider(providerId: 'apple.com');

      final credential = oAuthProvider.getCredential(
        idToken: String.fromCharCodes(result.credential.identityToken),
        accessToken: String.fromCharCodes(result.credential.authorizationCode),
      );
      user = (await _auth.signInWithCredential(credential)).user;
      print('サインインしました ${user.uid}');

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
      barrierDismissible: false,
    );
  }

  // アイコンを編集
  void _uploadIcon(bool defaultIcon) async {
    final File file = await FilePicker.getFile(
      type: FileType.image,
    );
    if (file != null) {
      if (defaultIcon) {
        // 今デフォルトのアイコンかどうか
        // そうだったらfalseにする
        Map<String, dynamic> newAccountData = _yonakiProvider.myAccountData;
        newAccountData['defaultIcon'] = false;
        await FirebaseService()
            .editMyAccountData(_yonakiProvider.uid, newAccountData)
            .then((_) => _yonakiProvider.editMyAccountData(newAccountData));
      }
      // 写真を変更・更新する
      await FirebaseService()
          .putFile('users/${_yonakiProvider.uid}/icon', file)
          .then((_) => _yonakiProvider.editMyIcon());
    }
  }

  // アイコンをデフォルトに変更
  void _changeDefaultIcon() async {
    Map<String, dynamic> newAccountData = _yonakiProvider.myAccountData;
    newAccountData['defaultIcon'] = true;
    await FirebaseService()
        .editMyAccountData(_yonakiProvider.uid, newAccountData)
        .then((_) {
      _yonakiProvider.editMyAccountData(newAccountData);
      _yonakiProvider.editMyIcon();
    });
  }
}
