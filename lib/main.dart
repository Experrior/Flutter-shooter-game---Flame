import 'dart:math';

import 'package:archerer/db_helper.dart';
import 'package:archerer/home.dart';
import 'package:archerer/loseScreen.dart';
import 'package:archerer/router.dart';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'projectile.dart';
import 'dart:async' as asyncer;



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
  }

      @override
  void onTapUp(TapUpEvent event) {
    bow.updateAngle(event.localPosition);
  }

  void increaseScore() {
    score++;
    scoreComponent.display(score, hp);
  }

  void hpDown() async{
    hp--;
    if (hp <= 0) {
      // 
      await add(LoseScreenComponent(score, Vector2(width, height)));
      remove(enemySpawner);
      await Future.delayed(Duration(seconds:1));
      pauseEngine();
      await insertRecord(HighScore(dateTime: DateTime.now(), score: score));
      await Future.delayed(Duration(seconds:2));
      gameRouter.go('/home');
    }
    scoreComponent.display(score, hp);
  }
 
}
class Bow extends SpriteComponent with TapCallbacks, HasGameRef<BowGame> {
  Bow(double width, double height)
      : super(
          size: Vector2(100, 50),
          position: Vector2(width/2 - 50, height-30),
        );

  late asyncer.Timer _shootTimer;
  double _lastAngle = 0;
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('new_bow.png');
    _shootTimer = asyncer.Timer.periodic(const Duration(milliseconds: 850), (shootTimer) {
      shoot();
    });
  }

  void shoot() {
    final projectile = Projectile(
      position.clone() + Vector2(40, -30),
      calculateVelocity(_lastAngle), _lastAngle
    );
    game.add(projectile);

  }

  Vector2 calculateVelocity(double angle) {
    final radianAngle = angle * pi / 180;
    final velocity = Vector2(cos(radianAngle), -sin(radianAngle)) * 475;
    return velocity;
  }

  void updateAngle(Vector2 newPosition) {
    final direction = (newPosition - position).normalized();
    _lastAngle = direction.angleTo(Vector2(1, 0)) * 180 / pi;
  }

    @override
  void onTapUp(TapUpEvent event) {
    final touchPosition = event.localPosition;
    final direction = (touchPosition - position).normalized();
    _lastAngle = direction.angleTo(Vector2(1, 0)) * 180 / pi;
  }
      @override
  void onTapDown(TapDownEvent event) {
    final touchPosition = event.localPosition;
    final direction = (touchPosition - position).normalized();
    _lastAngle = direction.angleTo(Vector2(1, 0)) * 180 / pi;
  }
}


class Enemy extends SpriteComponent with CollisionCallbacks, HasGameRef<BowGame>  {
  late ShapeHitbox hitbox;
  late double heightLimit;

  
  Enemy(Vector2 position, this.heightLimit)
      : super(
          size: Vector2(60, 50),
          position: position,

        );

  @override
  Future<void> onLoad() async {
    // await Flame.images.load('output-onlinegiftools.gif');
    // Image image = await Image.asset('output-onlinegiftools.gif');
    sprite = await Sprite.load('output-onlinegiftools.gif');
    hitbox = RectangleHitbox(
          collisionType: CollisionType.active
    );
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y+= 250 * dt;
    if (position.y > heightLimit) {
      removeFromParent();
      gameRef.hpDown();
    }
  }

    @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
      other.removeFromParent();
      removeFromParent();
      gameRef.increaseScore();
    
  }
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
        this.heightLimit,
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
    final background = await Flame.images.load("background_new.jpg");
    size = gameRef.size;
    sprite = Sprite(background);
  }
}

class ScoreComponent extends TextComponent with HasGameRef<BowGame> {
  int score = 0;
  int hp = 3;
  ScoreComponent()
      : super(
          text: 'Score: 0\n Hp: 3',
          position: Vector2(10, 10),
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        );

  void display(int score, int hp) {
    text = 'Score: $score\nHp: $hp';
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
