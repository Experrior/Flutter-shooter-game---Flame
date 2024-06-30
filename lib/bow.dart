import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'projectile.dart';
import 'dart:async' as asyncer;
import 'package:archerer/main.dart';

class Bow extends SpriteComponent with TapCallbacks, HasGameRef<BowGame> {
  Bow(double width, double height)
      : super(
          size: Vector2(200, 100),
          position: Vector2(width/2 - 100, height-75),
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
      position.clone() + Vector2(85, -10),
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

