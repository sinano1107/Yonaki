import 'package:flutter/material.dart';
import 'package:yonaki/screens/ar_screen.dart';
import 'package:yonaki/screens/walk_screen.dart';

void main() {
  runApp(Yonaki());
}

class Yonaki extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: WalkScreen.id,
      routes: {
        WalkScreen.id: (context) => WalkScreen(),
        ARScreen.id: (context) => ARScreen(),
      },
    );
  }
}
