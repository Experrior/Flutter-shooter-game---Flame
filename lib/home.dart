import 'package:archerer/main.dart';
import 'package:archerer/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:archerer/db_helper.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp.router(
      routerConfig: theRouter,
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

  @override
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

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {context.push('/game');}, child: Text('Start Game'),),
            ElevatedButton(onPressed: () {context.push('/scores');}, child: Text('Check records'),),
          ],
        ),
      ),
    );
  }
}

