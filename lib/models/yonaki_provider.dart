import 'package:flutter/foundation.dart';
import 'package:yonaki/services/unity_listener_service.dart';
import 'package:yonaki/story.dart';

class YonakiProvider extends ChangeNotifier {
  UnityListenerService unityListenerService = UnityListenerService();
  Story story;

  //-unityListenerService-------------------------------------------------------
  void editUnityListenerNext(Function newNext) {
    print('ListenerNextの変更を要請されました $newNext');

    unityListenerService.next = newNext;
    notifyListeners();
  }

  //-story----------------------------------------------------------------------
  void editStory(Story newStory) {
    print('ストーリーの変更を要請されました $newStory');

    story = newStory;
    notifyListeners();
  }
}
