import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yonaki/models/yonaki_provider.dart';
import 'package:yonaki/screens/ar_screen.dart';
import 'package:yonaki/screens/loading_screen.dart';
import 'package:yonaki/screens/location_story_screen.dart';
import 'package:yonaki/screens/post_program_screen.dart';
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
        theme: ThemeData.dark().copyWith(
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Horror'),
          primaryTextTheme: Theme.of(context).textTheme.apply(fontFamily: 'Horror'),
          accentTextTheme: Theme.of(context).textTheme.apply(fontFamily: 'Horror'),
          primaryColor: Colors.blueGrey[600],
        ),
        initialRoute: LoadingScreen.id,
        routes: {
          ARScreen.id: (context) => ARScreen(),
          LoadingScreen.id: (context) => LoadingScreen(),
          LocationStoryScreen.id: (context) => LocationStoryScreen(),
          PostProgramScreen.id: (context) => PostProgramScreen(),
          ProgramScreen.id: (context) => ProgramScreen(),
          WalkScreen.id: (context) => WalkScreen(),
        },
      ),
    );
  }
}
