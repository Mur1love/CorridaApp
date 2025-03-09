import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_provider.dart';
import 'timer_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay runTime = const TimeOfDay(hour: 0, minute: 1);
  TimeOfDay walkTime = const TimeOfDay(hour: 0, minute: 3);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      runTime = TimeOfDay(
        hour: 0,
        minute: prefs.getInt('runMinutes') ?? 1,
      );
      walkTime = TimeOfDay(
        hour: 0,
        minute: prefs.getInt('walkMinutes') ?? 3,
      );
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('runMinutes', runTime.minute);
    await prefs.setInt('walkMinutes', walkTime.minute);
  }

  Future<void> _selectTime(BuildContext context, bool isRunTime) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: isRunTime ? runTime : walkTime,
        cancelText: 'CANCELAR',
        hourLabelText: 'Minutos',
        minuteLabelText: 'Segundos',
        helpText: 'Digite o tempo',
        initialEntryMode: TimePickerEntryMode.dial);

    if (picked != null) {
      setState(() {
        if (isRunTime) {
          runTime = picked;
        } else {
          walkTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        actions: [
          Text('Dark/Light'),
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimePicker(
              'Tempo de Corrida 🏃‍♂️',
              runTime,
              () => _selectTime(context, true),
            ),
            SizedBox(height: 20),
            _buildTimePicker(
              'Tempo de Caminhada 🚶‍♂️',
              walkTime,
              () => _selectTime(
                context,
                false,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _saveSettings();
                int runDuration = (runTime.hour * 60) + runTime.minute;
                int walkDuration = (walkTime.hour * 60) + walkTime.minute;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerScreen(
                      runTime: runDuration,
                      walkTime: walkDuration,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                textStyle: TextStyle(fontSize: 40),
                backgroundColor: isDarkMode ? Colors.white : Colors.black,
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
              ),
              child: Text('Começar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onTap,
                child: Text(
                  '${time.hour} min ${time.minute} seg',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
