import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'timer_screen.dart';
import 'theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Running Timer',
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
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
