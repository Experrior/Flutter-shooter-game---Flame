import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'main.dart';

class Projectile extends SpriteComponent with CollisionCallbacks, HasGameRef<BowGame> {

  late ShapeHitbox hitbox;
  final double radianAngle;
  final Vector2 velocity;
  Projectile(Vector2 position, this.velocity, this.radianAngle)
      : super(
          size: Vector2(25, 75),
          position: position,
          anchor: Anchor.bottomLeft,
          angle: pi/2 - radianAngle*pi/180
        );

  @override
  Future<void> onLoad() async {

     hitbox = RectangleHitbox(
      collisionType: CollisionType.active,
      // anchor: Anchor.topRight
     );
      // ..renderShape = true;
    add(hitbox);
    sprite = await Sprite.load('poison_arrow.webp');
    // angle = radianAngle;
    
  }

 @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    if (position.y < 0 || position.x < 0 || position.x > gameRef.size.x) {
      removeFromParent();
    }
  }


  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
      other.removeFromParent();
      removeFromParent();
    
  }

}
