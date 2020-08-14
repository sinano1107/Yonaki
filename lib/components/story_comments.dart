import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:yonaki/components/comment_card.dart';
import 'package:yonaki/services/firebase_service.dart';

class StoryComments extends StatefulWidget {
  final DocumentSnapshot story;

  StoryComments(this.story);

  @override
  _StoryCommentsState createState() => _StoryCommentsState();
}

class _StoryCommentsState extends State<StoryComments> {
  List<Widget> _comments;

  @override
  Widget build(BuildContext context) {
    _buildCommentCards();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _comments == null
            ? [
                Container(
                  width: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ]
            : _comments,
      ),
    );
  }

  void _buildCommentCards() async {
    List<Widget> answer = [];

    final comments = await FirebaseService().getComments(widget.story.reference);

    comments.forEach((comment) {
      answer.add(CommentCard(comment));
    });

    if (answer.length == 0) {
      answer.add(
        Container(
          width: 200,
          child: Center(
            child: Text('コメントがありません'),
          ),
        ),
      );
    }

    setState(() => _comments = answer);
  }
}
