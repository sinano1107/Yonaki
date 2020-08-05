import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:yonaki/components/post_program_sheet.dart';
import 'package:yonaki/parameter.dart';

class PostProgramScreen extends StatefulWidget {
  static const String id = 'postProgram';

  @override
  _PostProgramScreenState createState() => _PostProgramScreenState();
}

class _PostProgramScreenState extends State<PostProgramScreen> {
  GoogleMapController _controller;
  Location _locationService = Location();
  LatLng _selectedLocation;

  bool _loading = false;

  // 現在位置
  LocationData _yourLocation;

  // 現在位置の監視状況
  StreamSubscription _locationChangedListen;

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
        setState(() {
          _yourLocation = result;
        });
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
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    // 監視を終了
    _locationChangedListen?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final PostProgramScreenArgument _arg =
        ModalRoute.of(context).settings.arguments;

    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('投稿画面'),
        ),
        body: Stack(
          children: [
            _makeGoogleMap(),
            Text(_selectedLocation.toString()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: PostProgramSheet(
                  program: _arg.program,
                  selectedLocation: _selectedLocation,
                  showLoading: () => setState(() => _loading = true),
                ),
              ),
            ),
          ),
        ),
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
      // Google Map Widgetを返す
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
        markers: Set.from([
          Marker(
            markerId: MarkerId('0'),
            position: _selectedLocation,
          ),
        ]),

        // 現在位置にアイコンをおく
        myLocationEnabled: true,

        minMaxZoomPreference: MinMaxZoomPreference(18, 20),
        scrollGesturesEnabled: false,
        myLocationButtonEnabled: false,

        onTap: (newLatLng) {
          setState(
            () {
              _selectedLocation = newLatLng;
            },
          );
        },
      );
    }
  }

  void _getLocation() async {
    _yourLocation = await _locationService.getLocation();
    setState(
      () {
        // 初期ターゲットを設定
        _selectedLocation =
            LatLng(_yourLocation.latitude, _yourLocation.longitude);
      },
    );
  }
}

class PostProgramScreenArgument {
  final List<Map<String, dynamic>> program;

  PostProgramScreenArgument(this.program);
}
