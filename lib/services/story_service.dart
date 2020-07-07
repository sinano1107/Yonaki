import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class StoryService {
  void showStory(BuildContext context, List<dynamic> stories) {
    _showDialog(context, stories, 0);
  }

  void _showDialog(BuildContext context, List<dynamic> stories, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: TyperAnimatedTextKit(
          text: [stories[index].toString()],
          textAlign: TextAlign.center,
          isRepeatingAnimation: false,
        ),
        actions: _buildActions(context, stories, index),
        backgroundColor: Colors.transparent,
      ),
      barrierDismissible: false,
    );
  }

  List<Widget> _buildActions(BuildContext context, List<dynamic> stories, int index) {
    final button = stories.length-1 > index
        ? FlatButton(
            child: Text('次へ'),
            onPressed: () {
              Navigator.pop(context);
              _showDialog(context, stories, index+1);
            },
          )
        : FlatButton(
            child: Text('閉じる'),
            onPressed: () => Navigator.pop(context),
          );

    return [button];
  }
}
