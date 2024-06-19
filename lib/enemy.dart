// import 'package:archerer/main.dart';
// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flame/flame.dart';
// import 'package:gif/gif.dart';


// enum State { idle, run, hit }

// class Enemy extends SpriteAnimationGroupComponent with CollisionCallbacks, HasGameRef<BowGame>  {
//   late ShapeHitbox hitbox;
//   late double heightLimit;
//   late final SpriteAnimation _idleAnimation;
  
//   Enemy(Vector2 position, this.heightLimit)
//       : super(
//           size: Vector2(60, 50),
//           position: position,

//         );

//   @override
//   Future<void> onLoad() async {
//     GifController _controller = GifController(vsync: );
//     Gif(image: AssetImage("output-onlinegiftools.gif"), controller: _controller),

//     _idleAnimation = SpriteAnimation(frames);
//     animations = {
//       State.idle: _idleAnimation,
//       State.run: _idleAnimation,
//       State.hit: _idleAnimation,
//     };

//     current = State.idle;
    
//     var sprite = Sprite(await Flame.images.load('output-onlinegiftools.gif'));
//     animation = SpriteAnimation(sprite, 
//     );
//     // Image image = await Image.asset('output-onlinegiftools.gif');
//     // sprite = await Sprite(image);
//     hitbox = RectangleHitbox(
//           collisionType: CollisionType.active
//     );
//     add(hitbox);
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     position.y+= 75 * dt;
//     if (position.y > heightLimit) {
//       removeFromParent();
//       gameRef.hpDown();
//     }
//   }

//     @override
//   void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
//     super.onCollisionStart(intersectionPoints, other);
//       other.removeFromParent();
//       removeFromParent();
//       gameRef.increaseScore();
    
//   }
// }
