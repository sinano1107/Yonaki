import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/ar_screen.dart';
import 'package:yonaki/screens/loading_screen.dart';
import 'package:yonaki/screens/program_screen.dart';
import 'package:yonaki/screens/walk_screen.dart';

void main() {
  runApp(Yonaki());
}

class Yonaki extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => YonakiProvider(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        initialRoute: LoadingScreen.id,
        routes: {
          ARScreen.id: (context) => ARScreen(),
          LoadingScreen.id: (context) => LoadingScreen(),
          ProgramScreen.id: (context) => ProgramScreen(),
          WalkScreen.id: (context) => WalkScreen(),
        },
      ),
    );
  }
}
