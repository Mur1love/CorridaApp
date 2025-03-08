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
    currentTime = widget.walkTime; // Começa com o tempo de caminhada
  }

  // Função para formatar o tempo no formato MM:SS
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

  // Função para resetar o timer para o tempo de corrida
  void resetToRun() {
    setState(() {
      isWalking = false;
      currentTime = widget.runTime;
      if (isRunning) {
        stopTimer();
      }
    });
  }

  // Função para resetar o timer para o tempo de caminhada
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
                  isMale = !isMale; // Alterna entre homem e mulher
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
              formatTime(currentTime), // Exibe o tempo no formato MM:SS
              style: TextStyle(fontSize: 80),
            ),
            Text(
              isWalking ? 'Caminhar' : 'Correr',
              style: TextStyle(fontSize: 60),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRunning ? stopTimer : startTimer,
              child: Text(
                isRunning ? 'Parar' : 'Iniciar',
                style: TextStyle(
                    fontSize: 40, color: isRunning ? Colors.red : Colors.green),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botão para resetar o timer para o tempo de corrida
                ElevatedButton(
                  onPressed: resetToRun,
                  child: Text(
                    'Começar Corrida',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                // Botão para resetar o timer para o tempo de caminhada
                ElevatedButton(
                  onPressed: resetToWalk,
                  child: Text('Começar Caminhada',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
