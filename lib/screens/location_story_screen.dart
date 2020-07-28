import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yonaki/screens/ar_screen.dart';

class LocationStoryScreen extends StatelessWidget {
  static const String id = 'locationStory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('位置情報ベースの体験'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('programs').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    title: Text(document['program'].toString()),
                    onTap: () => Navigator.pushNamed(context, ARScreen.id,
                        arguments: ARScreenArgument(
                            userProgram: document['program'].cast<Map<String, dynamic>>(),
                            isLocation: true)),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
