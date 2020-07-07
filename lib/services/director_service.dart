import 'dart:convert';

import 'package:flutter/foundation.dart';

class DirectorService {
  final List<String> programList;
  int index = 0; // 現在処理している指示のインデックス

  DirectorService({
    @required this.programList,
  });

  void start() {
    _processing(json.decode(programList[0]));
  }

  void next() {
    _processing(json.decode(programList[index+=1]));
  }

  void _processing(Map<String, dynamic> program) {
    switch (program['process']) {

      // UnityのARオブジェクトを指定
      case 'setObject':
        print('UnityのARオブジェクト ${program['object']} に指定します');
        break;



      // エラー
      default:
        print('未知の処理を受け取りました。問題がないか確認してください\nprogram: $program');
    }
  }
}