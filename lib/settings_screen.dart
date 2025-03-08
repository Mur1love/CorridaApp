import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timer_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController runMinutesController = TextEditingController();
  final TextEditingController runSecondsController = TextEditingController();
  final TextEditingController walkMinutesController = TextEditingController();
  final TextEditingController walkSecondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      runMinutesController.text = (prefs.getInt('runMinutes') ?? 1).toString();
      runSecondsController.text = (prefs.getInt('runSeconds') ?? 0).toString();
      walkMinutesController.text =
          (prefs.getInt('walkMinutes') ?? 3).toString();
      walkSecondsController.text =
          (prefs.getInt('walkSeconds') ?? 0).toString();
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'runMinutes', int.tryParse(runMinutesController.text) ?? 1);
    await prefs.setInt(
        'runSeconds', int.tryParse(runSecondsController.text) ?? 0);
    await prefs.setInt(
        'walkMinutes', int.tryParse(walkMinutesController.text) ?? 3);
    await prefs.setInt(
        'walkSeconds', int.tryParse(walkSecondsController.text) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeInput('Tempo de Corrida 🏃‍♂️', runMinutesController,
                runSecondsController),
            SizedBox(height: 20),
            _buildTimeInput('Tempo de Caminhada 🚶‍♂️', walkMinutesController,
                walkSecondsController),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _saveSettings();
                int runTime =
                    (int.tryParse(runMinutesController.text) ?? 0) * 60 +
                        (int.tryParse(runSecondsController.text) ?? 0);
                int walkTime =
                    (int.tryParse(walkMinutesController.text) ?? 0) * 60 +
                        (int.tryParse(walkSecondsController.text) ?? 0);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerScreen(
                      runTime: runTime,
                      walkTime: walkTime,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                textStyle: TextStyle(fontSize: 30),
              ),
              child: Text(
                'Iniciar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInput(String label, TextEditingController minutesController,
      TextEditingController secondsController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Minutos'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: secondsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Segundos'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
