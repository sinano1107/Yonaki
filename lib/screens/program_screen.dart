import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:yonaki/models/program.dart';
import 'package:yonaki/screens/ar_screen.dart';
import 'package:yonaki/services/firebase_service.dart';

class ProgramScreen extends StatefulWidget {
  static const String id = 'program';

  @override
  _ProgramScreenState createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  final List<dynamic> programs = [];
  List<Widget> programList;
  // オブジェクト一覧
  Map<String, String> _objects;

  @override
  void initState() {
    super.initState();
    _buildProgramList();
    asyncInit();
  }

  void asyncInit() async {
    final objects = await FirebaseService().getObjects();
    setState(() => _objects = objects);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('心霊体験を作る'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _objects == null,
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blueGrey,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildDragList(),
                ),
              ),
            ),
            Expanded(
              child: DragTarget<dynamic>(
                builder: (context, candidateData, rejectedData) {
                  return Center(
                    child: ReorderableColumn(
                      children:
                          programList + [SizedBox(key: UniqueKey(), height: 50)],
                      onReorder: (int oldIndex, int newIndex) {
                        final row = programs.removeAt(oldIndex);
                        programs.insert(newIndex, row);
                        _buildProgramList();
                      },
                    ),
                  );
                },
                onAccept: (data) {
                  programs.add(data);
                  _buildProgramList();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.description),
        onPressed: programs.length != 0 ? () => _encode() : null,
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

  List<Widget> _buildDragList() {
    List<Widget> answer = [];
    allProgram.forEach((name) {
      answer.add(getNewProgram(name, _objects)
          .program
          .generateDrag(getNewProgram(name, _objects)));
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

    print(answer);
    Navigator.pushNamed(context, ARScreen.id,
        arguments: ARScreenArgument(userProgram: answer, isLocation: false));
  }
}
