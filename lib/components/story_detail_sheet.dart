import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:yonaki/components/post_comment_dialog.dart';
import 'package:yonaki/components/story_comments.dart';
import 'package:yonaki/screens/ar_screen.dart';
import 'package:yonaki/services/firebase_service.dart';

class StoryDetailSheet extends StatefulWidget {
  final DocumentSnapshot story;

  StoryDetailSheet(this.story);

  @override
  _StoryDetailSheetState createState() => _StoryDetailSheetState();
}

class _StoryDetailSheetState extends State<StoryDetailSheet> {
  Map<String, dynamic> _userData;
  String _userIcon;

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  void asyncInit() async {
    final userData = await FirebaseService().getUserData(widget.story['uid']);
    final userIcon = await FirebaseService()
        .getIcon(widget.story['uid'], userData['defaultIcon']);
    setState(() {
      _userData = userData;
      _userIcon = userIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: _size.height * 0.55,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  widget.story['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _userData != null
                        ? [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '投稿者:',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              child: _userIcon != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(_userIcon),
                                    )
                                  : CircleAvatar(),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: Text(
                                _userData['name'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ]
                        : [CircularProgressIndicator()],
                  ),
                ),
                Divider(),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Text(
                      widget.story['content'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 2,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Expanded(child: StoryComments(widget.story)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        backgroundColor: Colors.red,
        onPressed: () async {
          final toTheLast = await Navigator.pushNamed(
            context,
            ARScreen.id,
            arguments: ARScreenArgument(
              userProgram: widget.story['program'].cast<Map<String, dynamic>>(),
              isLocation: true,
            ),
          );
          if (toTheLast)
            showDialog(
                context: context,
                builder: (_) => PostCommentDialog(widget.story));
        },
      ),
    );
  }
}
