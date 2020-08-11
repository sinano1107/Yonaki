import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Future<String> getUri(String path) async {
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(path);
    return await storageRef.getDownloadURL();
  }

  Future<String> getCrc(String name) async {
    return (await Firestore.instance
        .collection('objects')
        .document(name)
        .get())['crc'];
  }

  Future<Map<String, String>> getObjects() async {
    Map<String, String> answer = {};
    var objectsRef =
        await Firestore.instance.collection('objects').getDocuments();
    objectsRef.documents.forEach((object) {
      answer[object.data['name']] = object.documentID;
    });
    return answer;
  }

  // すでにその名前のオブジェクトが投稿されているか確かめる
  Future<bool> notContainsObjects(String id) async {
    final objectsRef =
        await Firestore.instance.collection('objects').getDocuments();
    return objectsRef.documents.every((object) => object.documentID != id);
  }

  // 新たなオブジェクトを投稿
  void postObject({File asset, String id, String name, String crc}) {
    Firestore.instance.collection('objects').document(id).setData({
      'name': name,
      'crc': crc,
    });
    FirebaseStorage.instance.ref().child('prefabs/$id').putFile(asset);
  }

  // uidからユーザー情報を取得
  Future<Map<String, dynamic>> getUserData(String uid) async {
    final ref =
        await Firestore.instance.collection('users').document(uid).get();
    return ref.data;
  }
}
