import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final userIcon =
        await FirebaseService().getIcon(widget.story['uid'], userData['icon']);
    setState(() {
      _userData = userData;
      _userIcon = userIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              Divider(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (_userData != null && _userIcon != null)
                    ? [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '投稿者:',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(_userIcon),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: Text(
                            _userData['name'],
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ]
                    : [CircularProgressIndicator()],
              ),
              Divider(
                height: 40,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      widget.story['content'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 2,
                        color: Colors.red,
                      ),
                    ),
                    Divider(
                      height: 20,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        backgroundColor: Colors.red,
        onPressed: () => Navigator.pushNamed(
          context,
          ARScreen.id,
          arguments: ARScreenArgument(
            userProgram: widget.story['program'].cast<Map<String, dynamic>>(),
            isLocation: true,
          ),
        ),
      ),
    );
  }
}
