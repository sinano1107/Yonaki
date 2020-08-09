import 'dart:convert';

class UnityListenerService {
  Function next = () => print('nextを指示されましたが何も設定されていません');
  Function pop = () => print('popを支持されましたが何も設定されていません');

  void listen(String message) {
    switch (message) {
      // 次へ移ってというメッセージ
      case 'next':
        next();
        break;

      case 'pop':
        print('popを受け取りました');
        pop();
        break;

      default:
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
