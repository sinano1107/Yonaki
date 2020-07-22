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
      body: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.blue,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Draggable<dynamic>(
                      data: SetObject(),
                      child: Card(child: Text('setObject')),
                      feedback: Icon(Icons.add),
                    ),
                    Draggable<dynamic>(
                      data: ShowStory(),
                      child: Card(child: Text('showStory')),
                      feedback: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReorderableColumn(
                      children: programList,
                      onReorder: (int oldIndex, int newIndex) {
                        final row = programs.removeAt(oldIndex);
                        programs.insert(newIndex, row);
                        _buildProgramList();
                      },
                    ),
                    DragTarget<dynamic>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 90,
                          height: 90,
                          color: Colors.red,
                        );
                      },
                      onAccept: (data) {
                        programs.add(data);
                        _buildProgramList();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
    Navigator.pushNamed(context, ARScreen.id,
        arguments: ARScreenArgument(answer));
  }
}
