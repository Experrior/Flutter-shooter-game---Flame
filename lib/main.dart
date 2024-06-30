import 'dart:math';
import 'package:archerer/bow.dart';
import 'package:archerer/db_helper.dart';
import 'package:archerer/enemy.dart';
import 'package:archerer/home.dart';
import 'package:archerer/loseScreen.dart';
import 'package:archerer/router.dart';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'dart:async' as asyncer;
import 'package:audioplayers/audioplayers.dart';


class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    BowGame game = BowGame(width, height);
    return GameWidget(
      game: game,
    );
  }
}


class BowGame extends FlameGame with TapCallbacks, HasCollisionDetection, DragCallbacks, HasGameRef<BowGame> {
  late ScoreComponent scoreComponent;
  int score = 0;
  late Bow bow;
  late EnemySpawner enemySpawner;
  int hp = 3;
  late double width;
  late double height;
  late AudioPlayer audioPlayer;
  BowGame(this.width, this.height);


  Future<void> insertRecord(HighScore highscore) async {
    await DatabaseHelper().insertHighScore(highscore);
  }



  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(resolution: Vector2(width, height));
    add(Background());
    bow = Bow(width, height);
    add(bow);
    enemySpawner = EnemySpawner(height);
    add(enemySpawner);
    debugMode= false;
    scoreComponent = ScoreComponent();
    add(scoreComponent);

    audioPlayer = AudioPlayer();
    audioPlayer.play(AssetSource('audio/desert-voices-11468.mp3'), volume: .25);
  }

      @override
  void onTapUp(TapUpEvent event) {
    bow.updateAngle(event.localPosition);
  }

  void increaseScore() {
    score++;
     if (score % 10 == 0) {
      // showLevelUpPopup();
      hp += 1;
    }
    scoreComponent.display(score, hp);
  }

  void hpDown() async{
    hp--;
    if (hp <= 0) {
      audioPlayer.stop();
      remove(enemySpawner);
      remove(bow);
      await add(LoseScreenComponent(score, Vector2(width, height)));
      await Future.delayed(const Duration(seconds:1)); // added delay here, becuase otherwise LoseScreen didn't have time to load
      pauseEngine();
      await insertRecord(HighScore(dateTime: DateTime.now(), score: score));
      await Future.delayed(const Duration(seconds:2));
      gameRouter.go('/home');
    }
    scoreComponent.display(score, hp);
  }

  // void showLevelUpPopup() async {
  //   final popup = LevelUpPopup();
  //   add(popup);
  //   await Future.delayed(const Duration(seconds: 2));
  //   remove(popup);
  // }
 
}

class EnemySpawner extends Component with HasGameRef<BowGame> {
  late double heightLimit;
  EnemySpawner(double heightLimit)
  {
    this.heightLimit = heightLimit;
  }
  

  @override
  void onMount() {
    super.onMount();
    manageTimer();
  }

  void manageTimer() {
    gameRef.add(TimerComponent(
    period: 1,
    repeat: true,
    onTick: () {
      final enemy = Enemy(Vector2(
        gameRef.size.x * (0.1 + 0.8 * Random().nextDouble()),0),
        heightLimit,
      );
      gameRef.add(enemy);
      },)
    );
  }
}

class Background extends SpriteComponent with HasGameRef<BowGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load("background_new2.jpg");
    size = gameRef.size;
    sprite = Sprite(background);
  }
}

// class ScoreComponent extends TextComponent with HasGameRef<BowGame> {
//   int score = 0;
//   int hp = 3;
//   ScoreComponent()
//       : super(
//           text: 'Score: 0\n Hp: 3',
//           position: Vector2(10, 10),
//           textRenderer: TextPaint(
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//             ),
//           ),
//         );

//   void display(int score, int hp) {
//     text = 'Score: $score\nHp: $hp';
//   }
  
// }

class ScoreComponent extends PositionComponent with HasGameRef<BowGame> {
  int score = 0;
  int hp = 3;
  late TextComponent scoreText;
  List<SpriteComponent> hearts = [];

  ScoreComponent()
      : super(position: Vector2(10, 10));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Initialize score text
    scoreText = TextComponent(
      text: 'Score: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
    add(scoreText);

    // Load heart image and create heart components
    final heartSprite = await gameRef.loadSprite('hp heart.png');
    for (int i = 0; i < hp; i++) {
      final heart = SpriteComponent(
        sprite: heartSprite,
        size: Vector2(24, 24),
        position: Vector2(0 + i * 30, 40),
      );
      hearts.add(heart);
      add(heart);
    }
  }

  asyncer.Future<void> display(int newScore, int newHp) async {
    score = newScore;
    hp = newHp;

    // Update score text
    scoreText.text = 'Score: $score';

    // Update heart images
    for (int i = 0; i < hearts.length; i++) {
      hearts[i].removeFromParent();
    }
    hearts.clear();

    final heartSprite = await gameRef.loadSprite('hp heart.png');
    for (int i = 0; i < hp; i++) {
      final heart = SpriteComponent(
        sprite: heartSprite,
        size: Vector2(24, 24),
        position: Vector2(0 + i * 30, 40),
      );
      hearts.add(heart);
      add(heart);
    }
  }
}


class LoseScreen extends TextComponent with HasGameRef<BowGame> {

  final int score;
  LoseScreen(this.score)
      : super(
          text: 'Game Over\n  Final core: \n      $score',
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.red,
              fontSize: 62,
              fontWeight:FontWeight.bold
              
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    position = gameRef.size / 2;
    anchor = Anchor.center;
  }
}

// class LevelUpPopup extends PositionComponent with HasGameRef<BowGame>{
//   @override
//   Future<void> onLoad() async {
//     final heartSprite = await gameRef.loadSprite('hp up.png');

//     final heart = SpriteComponent(
//         sprite: heartSprite,
//         size: Vector2(24, 24),
//         position: Vector2( 30, 40),
//     );
//     add(heart);
//     anchor = Anchor.center;
//   }
// }