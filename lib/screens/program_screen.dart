import 'package:flutter/material.dart';
import 'package:yonaki/models/program.dart';

class ProgramScreen extends StatelessWidget {
  static const String id = 'program';

  final List<dynamic> programs = [
    SetObject(),
    ShowStory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildProgramList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.description),
        onPressed: () => _encode(),
      ),
    );
  }

  List<Widget> _buildProgramList() {
    List<Widget> answer = [];

    programs.forEach((element) {
      answer.add(
        element.program.generateWidget(),
      );
    });

    return answer;
  }

  void _encode() {
    List<Map<String, String>> answer = [];

    programs.forEach((element) {
      answer.add(
        element.program.encode(),
      );
    });

    print(answer.toString());
  }
}
