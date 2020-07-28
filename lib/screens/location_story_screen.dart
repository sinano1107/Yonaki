import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:yonaki/screens/ar_screen.dart';

class LocationStoryScreen extends StatefulWidget {
  static const String id = 'locationStory';

  @override
  _LocationStoryScreenState createState() => _LocationStoryScreenState();
}

class _LocationStoryScreenState extends State<LocationStoryScreen> {
  GoogleMapController _controller;
  Location _locationService = Location();

  // 現在位置
  LocationData _yourLocation;

  // 現在位置の監視状況
  StreamSubscription _locationChangedListen;

  @override
  void initState() {
    super.initState();

    // 現在位置の取得
    _getLocation();

    // 現在位置の変化を監視
    _locationChangedListen =
        _locationService.onLocationChanged.listen((LocationData result) async {
      setState(() {
        _yourLocation = result;
        if (_controller != null) {
          _controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(_yourLocation.latitude, _yourLocation.longitude),
            zoom: 18.0,
          )));
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    // 監視を終了
    _locationChangedListen?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('位置情報ベースの体験'),
      ),
      body: Stack(
        children: [
          _makeGoogleMap(),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('programs').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return ListTile(
                        title: Text(
                          document['program'].toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () => Navigator.pushNamed(context, ARScreen.id,
                            arguments: ARScreenArgument(
                                userProgram: document['program']
                                    .cast<Map<String, dynamic>>(),
                                isLocation: true)),
                      );
                    }).toList(),
                  );
              }
            },
          )
        ],
      ),
    );
  }

  Widget _makeGoogleMap() {
    if (_yourLocation == null) {
      // 現在位置が取れるまではローディング中
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Google Map ウィジェットを返す
      return GoogleMap(
        // 初期表示される位置情報を現在位置から設定
        initialCameraPosition: CameraPosition(
          target: LatLng(_yourLocation.latitude, _yourLocation.longitude),
          zoom: 18.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },

        // 現在位置にアイコン（青い円形のやつ）を置く
        myLocationEnabled: true,

        minMaxZoomPreference: MinMaxZoomPreference(18, 20),
        scrollGesturesEnabled: false,
        myLocationButtonEnabled: false,
      );
    }
  }

  void _getLocation() async {
    _yourLocation = await _locationService.getLocation();
  }
}
