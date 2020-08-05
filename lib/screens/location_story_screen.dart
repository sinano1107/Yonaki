import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:yonaki/components/story_detail_sheet.dart';
import 'package:yonaki/services/address_service.dart';
import 'package:yonaki/parameter.dart';

class LocationStoryScreen extends StatefulWidget {
  static const String id = 'locationStory';

  @override
  _LocationStoryScreenState createState() => _LocationStoryScreenState();
}

class _LocationStoryScreenState extends State<LocationStoryScreen> {
  GoogleMapController _controller;
  Location _locationService = Location();
  Map<String, String> _beforeAddress = {'city': null, 'prefecture': null};
  List _stories = [];

  // 現在位置
  LocationData _yourLocation;

  // 現在位置の監視状況
  StreamSubscription _locationChangedListen;

  // ストーリーの監視状況
  StreamSubscription _storiesListen;

  @override
  void initState() {
    super.initState();

    // 現在位置の取得
    _getLocation();

    // 位置情報観測頻度の設定
    _locationService.changeSettings(
      distanceFilter: 20,
    );

    // 現在位置の変化を監視
    _locationChangedListen = _locationService.onLocationChanged.listen(
      (LocationData result) async {
        setState(
          () {
            _yourLocation = result;
          },
        );

        if (_controller != null) {
          _controller.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(_yourLocation.latitude, _yourLocation.longitude),
                zoom: 18.0,
              ),
            ),
          );
        }

        var newAddres = await AddressService()
            .getAddress(_yourLocation.latitude, _yourLocation.longitude);
        print(newAddres);

        if (_beforeAddress['city'] != newAddres['city'] ||
            _beforeAddress['prefecture'] != newAddres['prefecture']) {
          // 新しい街に移動した場合
          setState(
            () {
              _beforeAddress['city'] = newAddres['city'];
              _beforeAddress['prefecture'] = newAddres['prefecture'];
            },
          );
          _storiesListen?.cancel();
          loadStories();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    // 監視を終了
    _locationChangedListen?.cancel();
    _storiesListen?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('位置情報ベースの体験'),
      ),
      body: Stack(
        children: [
          _makeGoogleMap(context),
          MaterialButton(
            child: Text(_beforeAddress.toString()),
            onPressed: () {
              setState(() {
                _beforeAddress['city'] = '栃木市';
                _beforeAddress['prefecture'] = '栃木県';
              });
              _storiesListen?.cancel();
              loadStories();
            },
          ),
        ],
      ),
    );
  }

  Widget _makeGoogleMap(BuildContext context) {
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
          _controller.setMapStyle(Parameter.kGoogleMapStyle);
        },

        // マーカー
        markers: buildMarkers(context),

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
    var res = await AddressService()
        .getAddress(_yourLocation.latitude, _yourLocation.longitude);

    setState(() {
      _beforeAddress['city'] = res['city'];
      _beforeAddress['prefecture'] = res['prefecture'];
    });

    loadStories();
  }

  void loadStories() {
    _storiesListen = Firestore.instance
        .collection('allStories')
        .document(_beforeAddress['prefecture'])
        .collection('cities')
        .document(_beforeAddress['city'])
        .collection('stories')
        .snapshots()
        .listen(
      (stories) {
        setState(
          () {
            _stories = stories.documents;
          },
        );
      },
    );
  }

  Set<Marker> buildMarkers(BuildContext context) {
    List<Marker> answer = [];
    _stories.asMap().forEach(
      (index, story) {
        answer.add(
          Marker(
            markerId: MarkerId(index.toString()),
            position: LatLng(story['lat'], story['lng']),
            consumeTapEvents: true,
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => StoryDetailSheet(story),
            ),
          ),
        );
      },
    );
    return Set.from(answer);
  }
}
