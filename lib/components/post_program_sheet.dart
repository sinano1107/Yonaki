import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yonaki/screens/title_screen.dart';
import 'package:yonaki/services/address_service.dart';

class PostProgramSheet extends StatefulWidget {
  final List<Map<String, dynamic>> program;
  final LatLng selectedLocation;
  final Function showLoading;

  PostProgramSheet({
    @required this.program,
    @required this.selectedLocation,
    @required this.showLoading,
  });

  @override
  _PostProgramSheetState createState() => _PostProgramSheetState();
}

class _PostProgramSheetState extends State<PostProgramSheet> {
  String title = '';
  String content = '';
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  enabled: !sending,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'タイトル',
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  enabled: !sending,
                  decoration: InputDecoration(
                    labelText: 'コンテンツの説明',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      content = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  textColor: Theme.of(context).accentColor,
                  child: Icon(Icons.send),
                  onPressed:
                      (title.length != 0 && content.length != 0 && !sending)
                          ? () => _postProgram()
                          : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _postProgram() async {
    widget.showLoading();
    setState(() => sending = true);

    var address = await AddressService().getAddress(
        widget.selectedLocation.latitude, widget.selectedLocation.longitude);

    print(address);

    FirebaseAuth.instance.currentUser().then(
          (user) => Firestore.instance
              .collection('allStories')
              .document(address['prefecture'])
              .collection('cities')
              .document(address['city'])
              .collection('stories')
              .document()
              .setData(
            {
              'program': widget.program,
              'lat': widget.selectedLocation.latitude,
              'lng': widget.selectedLocation.longitude,
              'title': title,
              'content': content,
              'uid': user.uid,
            },
          ).then((value) => Navigator.pushNamedAndRemoveUntil(
                  context, TitleScreen.id, (route) => false)),
        );
  }
}
