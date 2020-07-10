import 'dart:convert';

class UnityListenerService {
  Function next = () => print('nextを指示されましたが何も設定されていません');

  void listen(String message) {
    // 次へ移ってというメッセージ
    if (message == 'next')
      next();
    else {
      final program = jsonDecode(message);
      switch (program['process']) {
        // ログ
        case 'log':
          print('unityからのログ: ${program['log']}');
          break;

        // エラー
        default:
          print('未知のUnityからのメッセージです。\nmessage: $message');
      }
    }
  }
}
