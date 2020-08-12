import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:yonaki/components/higanbana.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/ar_screen.dart';
import 'package:yonaki/services/japanese_service.dart';
import 'package:yonaki/services/lat_lng_service.dart';
import 'package:yonaki/parameter.dart';
import 'package:yonaki/story.dart';

class WalkScreen extends StatefulWidget {
  static const String id = 'walk';

  @override
  _WalkScreenState createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  YonakiProvider _yonakiProvider;
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
    _yonakiProvider = Provider.of<YonakiProvider>(context, listen: false);
    // ストーリが表示されていない、もしくはストーリーが終了している場合
    if (_yonakiProvider.story == null || _yonakiProvider.story.program == null)
      _yonakiProvider.editStory(getRandomStory());

    return Scaffold(
      appBar: AppBar(
        title: Text('散歩モード'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 450,
            child: Column(
              children: [
                Text(
                  JapaneseService().japanesePercent(_total / _eventDistance),
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                LinearPercentIndicator(
                  width: 300.0,
                  lineHeight: 25,
                  percent:
                      _total / _eventDistance > 1 ? 1 : _total / _eventDistance,
                  progressColor: Colors.red,
                ),
              ],
            ),
          ),
          Higanbana(3, 0, -100),
          Higanbana(2.5, -20, -50),
          Higanbana(1.6, 0, -590),
          Higanbana(1.6, -50, 50),
          Positioned(
            bottom: 10,
            left: 10,
            child: MaterialButton(
              child: Text('テスト用ARボタン'),
              onPressed: () => Navigator.pushReplacementNamed(
                  context, ARScreen.id,
                  arguments:
                      ARScreenArgument(userProgram: null, isLocation: false)),
            ),
          ),
        ],
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

    await Future.delayed(Duration(seconds: 10));

    while (!_isDisposed) {
      final _newLocation = await _getLocation();
      print('今の座標: $_newLocation');

      final _distance = _latLngService.getDistance(
          data1: _beforeLocation, data2: _newLocation);
      print('移動した距離 $_distance m');

      // totalに追加
      setState(() {
        _total += _distance;
      });
      print('total: $_total');

      // 鈴の音を再生
      final player = AudioCache();
      player.play('bell.mp3');

      // 指定メートル以上移動した場合
      if (_total >= _eventDistance) {
        // 立ち止まったまま誤差で稼いだりしていないか確認
        final first2NowDistance = _latLngService.getDistance(
            data1: _firstLocation, data2: _newLocation);
        if (first2NowDistance > _eventDistance / 2) {
          print('$_eventDistance m移動しました');
          Navigator.pushReplacementNamed(context, ARScreen.id,
              arguments:
                  ARScreenArgument(userProgram: null, isLocation: false));
        }

        print('立ち止まったままの可能性があります');
      }

      await Future.delayed(Duration(seconds: 10));
    }
  }
}
