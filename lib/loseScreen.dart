
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:archerer/router.dart';

class LoseScreenComponent extends PositionComponent with TapCallbacks {
  final int score;
  final Vector2 screenSize;
  final double ellipseWidth;
  final double ellipseHeight;

  LoseScreenComponent(this.score, this.screenSize, {this.ellipseWidth = 200, this.ellipseHeight = 100}) {
    size = Vector2(ellipseWidth, ellipseHeight);
    position = Vector2(0,0);
  }

  @override
  void render(Canvas canvas) {
    // Draw semi-transparent background
    Paint paintBackground = Paint()..color = Colors.black.withOpacity(0.4);
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.x, screenSize.y), paintBackground);

    // Draw red ellipse
    Paint paintEllipse = Paint()..color = Colors.red;
    Rect ellipseRect = Rect.fromLTWH((screenSize.x - ellipseWidth) / 2, (screenSize.y - ellipseHeight) / 2, ellipseWidth, ellipseHeight);
    canvas.drawOval(ellipseRect, paintEllipse);

    // Draw text
    TextSpan span = TextSpan(
      text: 'You Lost!\nScore: $score',
      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    Offset textPosition = Offset(
      (screenSize.x - ellipseWidth) / 2 + (ellipseWidth - tp.width) / 2,
      (screenSize.y - ellipseHeight) / 2 + (ellipseHeight - tp.height) / 2,
    );
    tp.paint(canvas, textPosition);
  }

  @override
  void update(double dt) {
    // Implement update logic if needed
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Handle the tap event here
    print('Lose screen tapped');
    // Remove the component or handle the tap as needed
    gameRouter.go('/home');
  }
}