import 'package:archerer/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp.router(
      routerConfig: gameRouter,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class HighScore {
  final DateTime dateTime;
  final int score;

  const HighScore({
    required this.dateTime,
    required this.score,
  });

  Map<String, Object?> toMap() {
    return {
      'dateTime': dateTime.toString(),
      'score': score,
    };
  }

  @override
  String toString() {
    return 'HighScore{dateTime: $dateTime, score: $score}';
  }

  factory HighScore.fromMap(Map<String, dynamic> map) {
    return HighScore(
      dateTime: DateTime.parse(map['dateTime']),
      score: map['score'],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Archerer game'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quo vadis?',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  context.push('/game');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Start Game'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.push('/scores');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Check Records'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
