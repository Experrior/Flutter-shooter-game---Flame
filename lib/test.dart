


import 'package:archerer/main.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  static const id = 'GameOver';
  final BowGame game;

  const GameOver(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    print('building');
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(100),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$context'),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.resumeEngine();
                  game.removeAll(game.children);
                },
                child: const Text('Restart'),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.resumeEngine();
                  game.removeAll(game.children);
                },
                child: const Text('Exit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
