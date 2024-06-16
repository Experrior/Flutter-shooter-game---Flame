// import 'dart:async';
// import 'package:archerer/main.dart';
// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';

// import 'package:flame/events.dart';

// class Bow extends SpriteComponent with CollisionCallbacks, TapCallbacks, HasGameRef<BowGame> {

  
//   Bow()
//       : super(
//           size: Vector2(100, 50),
//           position: Vector2(350, 550),
//         );

//   late Timer _shootTimer;

//   @override
//   Future<void> onLoad() async {
//     sprite = await Sprite.load('bow.png');
//     add(RectangleHitbox()..collisionType = CollisionType.passive);

//     // Initialize and start the timer to shoot every 1 second
//     Timer timer1 = Timer(1.0,);
//     timer1.onTick = () {
//         shoot();
//       };
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     // No need to manually update the timer since Timer.periodic handles it
//   }

//   void shoot() {
//     final projectile = Projectile(position.clone() + Vector2(45, -30));
//     game.add(projectile);
//   }
// }
