import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // ストレージのhファイルを取得するURIを取得
  Future<String> getUri(String path) async {
    StorageReference storageRef = FirebaseStorage.instance.ref().child(path);
    return await storageRef.getDownloadURL();
  }

  // objectの名前からcrcを取得
  Future<String> getCrc(String name) async {
    return (await Firestore.instance
        .collection('objects')
        .document(name)
        .get())['crc'];
  }

  // オブジェクト一覧を取得
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
    putFile('prefabs/$id', asset);
  }

  // uidからユーザー情報を取得
  Future<Map<String, dynamic>> getUserData(String uid) async {
    final ref =
        await Firestore.instance.collection('users').document(uid).get();
    return ref.data;
  }

  // アイコンのuriを取得
  Future<String> getIcon(String uid, bool defaultIcon) {
    final path = defaultIcon ? 'icon.png' : 'users/$uid/icon';
    return getUri(path);
  }

  // storageにファイルを保存
  Future<void> putFile(String path, File file) async {
    await FirebaseStorage.instance.ref().child(path).putFile(file).onComplete;
    return null;
  }

  // 自分のアカウントデータを編集
  Future<void> editMyAccountData(String uid, Map<String, dynamic> val) async {
    await Firestore.instance.collection('users').document(uid).setData(val);
    return null;
  }
}
