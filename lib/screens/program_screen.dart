import 'package:flutter/material.dart';
import 'package:yonaki/models/program.dart';
import 'package:yonaki/screens/ar_screen.dart';

class ProgramScreen extends StatefulWidget {
  static const String id = 'program';

  @override
  _ProgramScreenState createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
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
        element.program.generateWidget(
            () {
              setState(() {
                programs.remove(element);
              });
            },
        ),
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

    Navigator.pushNamed(context, ARScreen.id, arguments: ARScreenArgument(answer));
  }
}
