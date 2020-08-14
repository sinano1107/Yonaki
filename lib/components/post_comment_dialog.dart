import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/services/firebase_service.dart';

class PostCommentDialog extends StatefulWidget {
  final DocumentSnapshot story;

  PostCommentDialog(this.story);

  @override
  _PostCommentDialogState createState() => _PostCommentDialogState();
}

class _PostCommentDialogState extends State<PostCommentDialog> {
  String _comment = '';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: AlertDialog(
        title: Text("コメントする"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'すでにこの体験にコメントしている場合上書きされます',
              style: TextStyle(color: Colors.red),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: 50,
              style: TextStyle(fontSize: 20),
              onChanged: (value) => setState(() => _comment = value),
            ),
            SizedBox(height: 20),
            MaterialButton(
              textColor: Theme.of(context).accentColor,
              child: Icon(Icons.send),
              onPressed: _comment.length != 0 ? () => _postComment() : null,
            ),
          ],
        ),
      ),
    );
  }

  void _postComment() async {
    setState(() => _loading = true);
    final uid = Provider.of<YonakiProvider>(context, listen: false).uid;
    await FirebaseService().postComment(widget.story.reference, uid, _comment);
    setState(() => _loading = false);
    Navigator.pop(context);
  }
}
