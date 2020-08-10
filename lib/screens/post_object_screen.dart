import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yonaki/services/firebase_service.dart';

class PostObjectScreen extends StatefulWidget {
  static const String id = 'postObject';

  @override
  _PostObjectScreenState createState() => _PostObjectScreenState();
}

class _PostObjectScreenState extends State<PostObjectScreen> {
  File _file;
  String _id;
  String _name;
  String _crc;
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('幽霊を投稿する'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialButton(
              child: Row(
                children: [
                  Expanded(
                    child: Icon(Icons.attach_file),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      _file == null ? 'Assetをアップロード' : _file.toString(),
                      maxLines: 1,
                    ),
                    flex: 5,
                  ),
                ],
              ),
              color: Colors.blueGrey,
              onPressed: () => getFile(),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              onChanged: (value) => setState(() => _name = value),
              decoration: InputDecoration(
                labelText: '名前',
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              onChanged: (value) => setState(() => _crc = value),
              decoration: InputDecoration(
                labelText: 'CRC',
              ),
            ),
            SizedBox(height: 10),
            Text(
              _message,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 10),
            MaterialButton(
              child: Text('投稿'),
              onPressed: (_file != null && _name != null && _crc != null)
                  ? () {
                      postObject();
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void getFile() async {
    final file = await FilePicker.getFile(
      type: FileType.any,
    );
    if (file != null) {
      final id = file.toString().split('/').last;
      setState(() {
        _file = file;
        _id = id.substring(0, id.length - 1);
      });
    }
  }

  void postObject() async {
    if (await FirebaseService().notContainsObjects(_id)) {
      FirebaseService().postObject(
        asset: _file,
        id: _id,
        name: _name,
        crc: _crc,
      );
      Navigator.pop(context);
    } else {
      setState(() {
        _file = null;
        _message =
            'すでに同じ名前のオブジェクトが存在します。\n異なるオブジェクトの場合オブジェクトの名前を変更して再度AssetBundleを生成してください';
      });
    }
  }
}
