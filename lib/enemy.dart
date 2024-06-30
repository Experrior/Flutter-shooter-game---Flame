
import 'package:archerer/main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Enemy extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<BowGame>  {
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
    var sprite = await Sprite.load('output-onlinegiftools.gif');

     final List<SpriteAnimationFrame> frames = [];

    final assetPaths = [];
    for (int i = 1; i <= 28; i++) {
      assetPaths.add('enemy_frames/frame$i.png');
    }

    for (final assetPath in assetPaths) {
      final sprite = Sprite(await Flame.images.load(assetPath));
      final animationFrame = SpriteAnimationFrame(sprite, 0.25);
      frames.add(animationFrame);
    }

    animation = SpriteAnimation(frames);

    hitbox = RectangleHitbox(
          collisionType: CollisionType.active
    );
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y+= 75 * dt;
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
