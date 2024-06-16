import 'dart:math';

import 'package:archerer/db_helper.dart';
import 'package:archerer/home.dart';
import 'package:archerer/router.dart';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'projectile.dart';
import 'dart:async' as asyncer;
import 'package:path/path.dart';


class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: BowGame()  // Wrap BowGame with a widget
    );
  }
}


class BowGame extends FlameGame with TapCallbacks, HasCollisionDetection, DragCallbacks, HasGameRef<BowGame> {
  late ScoreComponent scoreComponent;
  int score = 0;
  late Bow bow;
  int hp = 3;


  Future<void> insertRecord(HighScore highscore) async {
    await DatabaseHelper().insertHighScore(highscore);
  }



  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(resolution: Vector2(800, 600));
    add(Background());
    bow = Bow();
    add(bow);
    add(EnemySpawner());
    debugMode= true;
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
      pauseEngine();
      await insertRecord(HighScore(dateTime: DateTime.now(), score: score));
      theRouter.go('/home');
    }
      // pauseEngine();
    
    scoreComponent.display(score, hp);
  }
 
}
class Bow extends SpriteComponent with TapCallbacks, HasGameRef<BowGame> {
  Bow()
      : super(
          size: Vector2(100, 50),
          position: Vector2(400, 400),
        );

  late asyncer.Timer _shootTimer;
  double _lastAngle = 0;
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bow.png');
    _shootTimer = asyncer.Timer.periodic(const Duration(seconds: 1), (shootTimer) {
      shoot();
    });
  }

  void shoot() {
    final projectile = Projectile(
      position.clone() + Vector2(40, -30),
      calculateVelocity(_lastAngle),
    );
    game.add(projectile);
  }

  Vector2 calculateVelocity(double angle) {
    // Convert angle to radians
    final radianAngle = angle * pi / 180;
    final velocity = Vector2(cos(radianAngle), -sin(radianAngle)) * 300;
    return velocity;
  }

  void updateAngle(Vector2 newPosition) {
    final direction = (newPosition - position).normalized();
    _lastAngle = direction.angleTo(Vector2(1, 0)) * 180 / pi;
  }

  // @override
  // void onTapUp(TapUpEvent event) {
  //   final touchPosition = event.localPosition;
  //   final direction = (touchPosition - position).normalized();
  //   final angle = direction.angleTo(Vector2(1, 0)) * 180 / pi;

  //   if (angle.abs() <= 45) {
  //     shoot(angle: angle);
  //   }
  // }

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

// class Projectile extends SpriteComponent with CollisionCallbacks, HasGameRef<BowGame> {
//   Projectile(Vector2 position)
//       : super(
//           size: Vector2(10, 30),
//           position: position,
//         );

//   @override
//   Future<void> onLoad() async {
//     sprite = await Sprite.load('projectile.png');
//     add(RectangleHitbox()..collisionType = CollisionType.passive);
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     position.y += 225 * dt;
//     if (position.y < 0) {
//       removeFromParent();
//     }
//   }
// }

class Enemy extends SpriteComponent with CollisionCallbacks, HasGameRef<BowGame>  {
  late ShapeHitbox hitbox;

  
  Enemy(Vector2 position)
      : super(
          size: Vector2(60, 50),
          position: position,
        );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('enemy.png');
         hitbox = RectangleHitbox(
                collisionType: CollisionType.active
         );
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y+= 100 * dt;
    if (position.y > 600) {
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
  @override
  void onMount() {
    super.onMount();
    gameRef.add(TimerComponent(
      period: 1,
      repeat: true,
      onTick: () {
        final enemy = Enemy(Vector2(
          gameRef.size.x * (0.1 + 0.8 * Random().nextDouble()),
          0,
        ));
        gameRef.add(enemy);
      },
    ));
  }
}

class Background extends SpriteComponent with HasGameRef<BowGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load("background.png");
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
  LoseScreen()
      : super(
          text: 'Game Over',
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.red,
              fontSize: 48,
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    position = gameRef.size / 2;
    anchor = Anchor.center;
  }
}