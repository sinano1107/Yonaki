import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:yonaki/services/firebase_service.dart';

class CommentCard extends StatefulWidget {
  final DocumentSnapshot comment;

  CommentCard(this.comment);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  String _name;
  String _icon;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Container(
      width: _size.width - 40,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Card(
          color: Colors.white70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: _name != null ? [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 10,
                        left: 10,
                        top: 5,
                      ),
                      child: Container(
                        width: 40,
                        height: 40,
                        child: _icon != null ? CircleAvatar(
                          backgroundImage: NetworkImage(_icon),
                        ) : CircleAvatar(),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        _name,
                        maxLines: 1,
                      ),
                    ),
                  ] : [
                    SizedBox(width: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    widget.comment.data['comment'],
                    maxLines: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadUserData() async {
    final firebaseService = FirebaseService();
    final uid = widget.comment.documentID;
    final userData = await firebaseService.getUserData(uid);
    setState(() => _name = userData['name']);
    final icon = await firebaseService.getIcon(uid, userData['defaultIcon']);
    setState(() => _icon = icon);
  }
}
