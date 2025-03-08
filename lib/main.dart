import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'timer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Running Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SettingsScreen(),
      routes: {
        '/timer': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return TimerScreen(
            runTime: args['runTime'],
            walkTime: args['walkTime'],
          );
        },
      },
    );
  }
}
