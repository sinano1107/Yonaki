import 'package:flutter/foundation.dart';
import 'package:yonaki/services/firebase_service.dart';
import 'package:yonaki/services/unity_listener_service.dart';
import 'package:yonaki/story.dart';

class YonakiProvider extends ChangeNotifier {
  // サインイン中のアカウント
  Map<String, dynamic> _myAccountData;
  String _uid;
  String _myIcon;
  UnityListenerService _unityListenerService = UnityListenerService();
  Story _story;

  //-myAccountData--------------------------------------------------------------
  void editMyAccountData(Map<String, dynamic> newAccountData) {
    print('アカウントデータの変更を要請されました $newAccountData');
    _myAccountData = newAccountData;
    notifyListeners();
  }

  Map<String, dynamic> get myAccountData => _myAccountData;

  //-uid------------------------------------------------------------------------
  void editUid(String newUid) {
    print('uidの変更を要請されました $newUid');
    _uid = newUid;
  }

  String get uid => _uid;

  //-myIcon---------------------------------------------------------------------
  void editMyIcon() async {
    print('アイコンの変更を要請されました');
    _myIcon = await FirebaseService().getIcon(_uid, _myAccountData['icon']);
    notifyListeners();
  }

  String get myIcon => _myIcon;

  //-unityListenerService-------------------------------------------------------
  void editUnityListenerNext(Function newNext) {
    print('ListenerNextの変更を要請されました $newNext');
    _unityListenerService.next = newNext;
  }

  void editUnityListenerPop(Function newPop) {
    print('ListenerPopの変更を要請されました $newPop');
    _unityListenerService.pop = newPop;
  }

  UnityListenerService get unityListenerService => _unityListenerService;

  //-story----------------------------------------------------------------------
  void editStory(Story newStory) {
    print('ストーリーの変更を要請されました $newStory');
    _story = newStory;
  }

  Story get story => _story;
}
