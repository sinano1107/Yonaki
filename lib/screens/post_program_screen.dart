import 'package:flutter/material.dart';

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
        child: Text(_arg.program.toString()),
      ),
    );
  }
}

class PostProgramScreenArgument {
  final List<Map<String, dynamic>> program;

  PostProgramScreenArgument(this.program);
}
