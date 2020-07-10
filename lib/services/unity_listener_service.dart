class UnityListenerService {
  Function next = () => print('nextを指示されましたが何も設定されていません');

  void listen(String message) {
    print(message);
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
