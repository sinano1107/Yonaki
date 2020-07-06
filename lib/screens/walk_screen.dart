import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:yonaki/screens/ar_screen.dart';
import 'package:yonaki/services/lat_lng_service.dart';
import 'package:yonaki/parameter.dart';

class WalkScreen extends StatefulWidget {
  static const String id = 'walk';

  @override
  _WalkScreenState createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  Location _locationService = Location();
  LatLngService _latLngService = LatLngService();
  final _eventDistance = Parameter.kEventDistance;

  // 一番最初の座標
  LocationData _firstLocation;

  // 判定する際の一つ前の指定時間前の座標
  LocationData _beforeLocation;

  // 指定時間ごとの移動した距離を足していく変数
  double _total = 0;

  // widgetがdisposeされたかどうか
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    print('walk_screen起動');
    _loop();
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('歩く画面(仮デザイン)'),
            MaterialButton(
              child: Text('テスト用AR起動ボタン'),
              onPressed: () => Navigator.pushReplacementNamed(context, ARScreen.id),
            ),
          ],
        ),
      ),
    );
  }

  Future<LocationData> _getLocation() async {
    return await _locationService.getLocation();
  }

  void _loop() async {
    // 初期代入
    await Future.delayed(Duration(seconds: 5));
    _firstLocation = await _getLocation();
    _beforeLocation = _firstLocation;
    print('初期座標: $_beforeLocation');

    while (!_isDisposed) {
      print('10秒待ちます');
      await Future.delayed(Duration(seconds: 10));
      final _newLocation = await _getLocation();
      print('今の座標: $_newLocation');

      final _distance = _latLngService.getDistance(data1: _beforeLocation, data2: _newLocation);
      print('移動した距離 $_distance m');

      // totalに追加
      _total += _distance;
      print('total: $_total');

      // 指定メートル以上移動した場合
      if (_total >= _eventDistance) {
        // 立ち止まったまま誤差で稼いだりしていないか確認
        final first2NowDistance = _latLngService.getDistance(data1: _firstLocation, data2: _newLocation);
        if (first2NowDistance > _eventDistance/2) {
          print('$_eventDistance m移動しました');
          Navigator.pushReplacementNamed(context, ARScreen.id);
        }

        print('立ち止まったままの可能性があります');
      }
    }
  }
}
