import 'package:flutter/material.dart';

class Settings {
  static String difficulty = 'Sedang';
  static String backgroundColorName = 'Ungu';
  static String ballColorName = 'Kuning';
  static String paddleColorName = 'Merah';

  static final Map<String, Color> colorOptions = {
    'Biru': Colors.blue,
    'Hijau': Colors.green,
    'Ungu': Colors.deepPurple,
    'Merah': Colors.red,
    'Oranye': Colors.orange,
    'Putih': Colors.white,
    'Kuning': Colors.yellow,
    'Merah Muda': Colors.pink,
    'Hijau Muda': Colors.lightGreen,
    'Biru Muda': Colors.lightBlue,
    'Ungu Tua': Colors.purple,
  };

  static Color get backgroundColor => colorOptions[backgroundColorName]!;
  static Color get ballColor => colorOptions[ballColorName]!;
  static Color get paddleColor => colorOptions[paddleColorName]!;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedDifficulty = Settings.difficulty;
  String selectedBackgroundColor = Settings.backgroundColorName;
  String selectedBallColor = Settings.ballColorName;
  String selectedPaddleColor = Settings.paddleColorName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tingkat Kesulitan'),
              DropdownButton<String>(
                value: selectedDifficulty,
                items: ['Mudah', 'Sedang', 'Sulit']
                    .map((e) =>
                    DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedDifficulty = val!;
                    Settings.difficulty = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text('Warna Background'),
              DropdownButton<String>(
                value: selectedBackgroundColor,
                items: [
                  'Biru',
                  'Hijau',
                  'Ungu',
                  'Oranye',
                  'Putih',
                ]
                    .map((name) => DropdownMenuItem(
                  value: name,
                  child: Text(name),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedBackgroundColor = val!;
                    Settings.backgroundColorName = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text('Warna Paddle'),
              DropdownButton<String>(
                value: selectedPaddleColor,
                items: [
                  'Merah',
                  'Biru',
                  'Hijau',
                  'Ungu Tua',
                  'Oranye',
                ]
                    .map((name) => DropdownMenuItem(
                  value: name,
                  child: Text(name),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedPaddleColor = val!;
                    Settings.paddleColorName = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text('Warna Bola'),
              DropdownButton<String>(
                value: selectedBallColor,
                items: [
                  'Kuning',
                  'Putih',
                  'Merah Muda',
                  'Hijau Muda',
                  'Biru Muda',
                ]
                    .map((name) => DropdownMenuItem(
                  value: name,
                  child: Text(name),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedBallColor = val!;
                    Settings.ballColorName = val;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
