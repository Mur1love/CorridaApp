import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class TimerScreen extends StatefulWidget {
  final int runTime;
  final int walkTime;

  TimerScreen({required this.runTime, required this.walkTime});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool isRunning = false;
  bool isWalking = false;
  int currentTime = 0;
  Timer? timer;
  bool isMale = true;

  @override
  void initState() {
    super.initState();
    isWalking = true;
    currentTime = widget.walkTime;
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (currentTime > 0) {
          currentTime--;
        } else {
          toggleActivity();
        }
      });
    });
  }

  void toggleActivity() async {
    if (await Vibration.hasVibrator() ?? false) {
      if (isWalking) {
        // Vibração para "Correr" (vibração curta e rápida)
        Vibration.vibrate(pattern: [200, 300, 200, 300, 200, 300]);
      } else {
        // Vibração para "Caminhar" (vibração longa)
        Vibration.vibrate(duration: 2000);
      }
    }

    setState(() {
      isWalking = !isWalking;
      currentTime = isWalking ? widget.walkTime : widget.runTime;
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetToRun() {
    setState(() {
      isWalking = false;
      currentTime = widget.runTime;
      if (isRunning) {
        stopTimer();
      }
    });
  }

  void resetToWalk() {
    setState(() {
      isWalking = true;
      currentTime = widget.walkTime;
      if (isRunning) {
        stopTimer();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Temporizador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  isMale = !isMale;
                });
              },
              child: Text(
                isMale
                    ? (isWalking ? '🚶‍♂️' : '🏃‍♂️')
                    : (isWalking ? '🚶🏽‍♀️' : '🏃🏽‍♀️'),
                style: TextStyle(fontSize: 80),
              ),
            ),
            Text(
              formatTime(currentTime),
              style: TextStyle(fontSize: 80),
            ),
            Text(
              isWalking ? 'Caminhar' : 'Correr',
              style: TextStyle(fontSize: 60),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRunning ? stopTimer : startTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: isRunning
                    ? (isDarkMode ? Colors.red : Colors.red)
                    : (isDarkMode ? Colors.green : Colors.green),
                foregroundColor: isRunning
                    ? (isDarkMode ? Colors.white : Colors.white)
                    : (isDarkMode ? Colors.white : Colors.white),
              ),
              child: Text(
                isRunning ? 'Parar' : 'Iniciar',
                style: TextStyle(fontSize: 40),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: resetToRun,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.white : Colors.black,
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                  ),
                  child: Text('Começar Corrida'),
                ),
                ElevatedButton(
                  onPressed: resetToWalk,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.white : Colors.black,
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                  ),
                  child: Text('Começar Caminhada'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
