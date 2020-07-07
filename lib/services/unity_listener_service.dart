import 'package:flutter/foundation.dart';

class UnityListenerService {
  final Function next;

  UnityListenerService({
    @required this.next,
  });

  void listen(String message) {
    switch (message) {

      // 次へ移ってというメッセージ
      case 'next':
        next();
        break;


      // エラー
      default:
        print('未知のUnityからのメッセージです。\nmessage: $message');
    }
  }
}