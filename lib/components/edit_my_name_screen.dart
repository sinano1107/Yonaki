import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/services/firebase_service.dart';

class EditMyNameScreen extends StatefulWidget {
  @override
  _EditMyNameScreenState createState() => _EditMyNameScreenState();
}

class _EditMyNameScreenState extends State<EditMyNameScreen> {
  YonakiProvider _yonakiProvider;
  TextEditingController _textEditingController;
  String _newName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _yonakiProvider = Provider.of<YonakiProvider>(context, listen: false);
    _textEditingController = TextEditingController(text: _yonakiProvider.myAccountData['name']);
    _newName = _yonakiProvider.myAccountData['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              autofocus: true,
              maxLines: 1,
              maxLength: 10,
              textAlign: TextAlign.center,
              onChanged: (val) => setState(() => _newName = val),
              style: TextStyle(color: Colors.white),
            ),
            MaterialButton(
              textColor: Theme.of(context).accentColor,
              child: Icon(Icons.edit),
              onPressed: _editMyName,
            ),
          ],
        ),
      ),
    );
  }

  // 名前を変更
  void _editMyName() {
    final newAccountData = _yonakiProvider.myAccountData;
    newAccountData['name'] = _newName;
    FirebaseService()
        .editMyAccountData(_yonakiProvider.uid, newAccountData)
        .then((_) {
          _yonakiProvider.editMyAccountData(newAccountData);
          Navigator.pop(context);
        });
  }
}
