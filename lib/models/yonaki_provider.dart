import 'package:flutter/foundation.dart';
import 'package:yonaki/services/unity_listener_service.dart';

class YonakiProvider extends ChangeNotifier {
  UnityListenerService unityListenerService = UnityListenerService();

  //-unityListenerService-------------------------------------------------------
  void editUnityListenerNext(Function newNext) {
    print('ListenerNextの変更を要請されました $newNext');

    unityListenerService.next = newNext;
    notifyListeners();
  }
}
