import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';

class LatLngService {
  // ある座標とある座標の直線距離(メートル)を算出
  double getDistance({
    @required LocationData data1,
    @required LocationData data2,
  }) {
    return Distance()(LatLng(data1.latitude, data1.longitude),
        LatLng(data2.latitude, data2.longitude));
  }
}