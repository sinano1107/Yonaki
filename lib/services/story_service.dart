import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class StoryService {
  final BuildContext context;
  final Function fade;
  final Function visible;

  StoryService({
    @required this.context,
    @required this.fade,
    @required this.visible,
  });

  Function next = () => print('ストーリーサービスからnextが呼び出されましたが、処理が設定されていません');

  void showStory(List<dynamic> stories, Function newNext) {
    next = newNext;
    fade();
    _showDialog(stories, 0);
  }

  void _showDialog(List<dynamic> stories, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Widget> _actions;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: TyperAnimatedTextKit(
                text: [stories[index].toString()],
                textStyle: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                isRepeatingAnimation: false,
                onFinished: () {
                  print('onFinished');
                  setState(() {
                    _actions = _buildActions(stories, index);
                  });
                },
              ),
              actions: _actions,
              backgroundColor: Colors.transparent,
            );
          },
        );
      },
      barrierDismissible: false,
    );
  }

  List<Widget> _buildActions(List<dynamic> stories, int index) {
    final button = stories.length - 1 > index
        ? FlatButton(
            child: Text('次へ'),
            onPressed: () {
              Navigator.pop(context);
              _showDialog(stories, index + 1);
            },
          )
        : FlatButton(
            child: Text('閉じる'),
            onPressed: () {
              Navigator.pop(context);
              visible();
              next();
            },
          );

    return [button];
  }
}
