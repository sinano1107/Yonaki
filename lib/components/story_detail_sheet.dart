import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yonaki/screens/ar_screen.dart';

class StoryDetailSheet extends StatelessWidget {
  final DocumentSnapshot story;

  StoryDetailSheet(this.story);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 500,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                story['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
              Divider(
                height: 20,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      story['content'],
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
            userProgram: story['program'].cast<Map<String, dynamic>>(),
            isLocation: true,
          ),
        ),
      ),
    );
  }
}
