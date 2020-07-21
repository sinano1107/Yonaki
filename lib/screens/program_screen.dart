import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
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
  List<Widget> programList;

  @override
  void initState() {
    super.initState();
    _buildProgramList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ReorderableColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          children: programList,
          onReorder: (int oldIndex, int newIndex) {
            final row = programs.removeAt(oldIndex);
            programs.insert(newIndex, row);
            _buildProgramList();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.description),
        onPressed: () => _encode(),
      ),
    );
  }

  void _buildProgramList() {
    List<Widget> answer = [];

    programs.asMap().forEach((index, element) {
      answer.add(
        element.program.generateWidget(
            () {
              setState(() {
                programs.removeAt(index);
                _buildProgramList();
              });
            },
            ValueKey(index),
        ),
      );
    });

    setState(() {
      programList = answer;
    });
  }

  void _encode() {
    List<Map<String, String>> answer = [];

    programs.forEach((element) {
      answer.add(
        element.program.encode(),
      );
    });

    print(answer);
    Navigator.pushNamed(context, ARScreen.id, arguments: ARScreenArgument(answer));
  }
}
