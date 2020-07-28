import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostProgramScreen extends StatelessWidget {
  static const String id = 'postProgram';

  @override
  Widget build(BuildContext context) {
    final PostProgramScreenArgument _arg = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('投稿画面'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_arg.program.toString()),
            MaterialButton(
              child: Text('投稿'),
              onPressed: () {
                Firestore.instance.collection('programs').document().setData({'program': _arg.program});
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PostProgramScreenArgument {
  final List<Map<String, dynamic>> program;

  PostProgramScreenArgument(this.program);
}
