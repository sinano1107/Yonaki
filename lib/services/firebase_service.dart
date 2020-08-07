import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Future<String> getUri(String name) async {
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child('prefabs/$name');
    return await storageRef.getDownloadURL();
  }

  Future<String> getCrc(String name) async {
    return (await Firestore.instance
        .collection('objects')
        .document(name)
        .get())['crc'];
  }
}
