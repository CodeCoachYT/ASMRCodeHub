// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const SnakeGame());

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnakeGame - Flutter',
      home: Scaffold(
        body: Builder(
          builder: (context) => const SnakeGameView(),
        ),
      ),
    );
  }
}

enum Direction { up, down, right, left }

class SnakeGameView extends StatefulWidget {
  const SnakeGameView({super.key});

  @override
  State<SnakeGameView> createState() => _SnakeGameViewState();
}

class _SnakeGameViewState extends State<SnakeGameView> {
  late List<Offset> snake;
  late Offset food;
  late Direction direction;

  bool gameOver = false;

  final double tileDimension = 20;
  final int gameSpeed = 8;

  late Timer timer;

  @override
  void initState() {
    super.initState();

    window.onKeyData = (final keyData) {
      if (keyData.logical == LogicalKeyboardKey.arrowRight.keyId) {
        setState(() => direction = Direction.right);
      }
      if (keyData.logical == LogicalKeyboardKey.arrowLeft.keyId) {
        setState(() => direction = Direction.left);
      }
      if (keyData.logical == LogicalKeyboardKey.arrowUp.keyId) {
        setState(() => direction = Direction.up);
      }
      if (keyData.logical == LogicalKeyboardKey.arrowDown.keyId) {
        setState(() => direction = Direction.down);
      }
      if (keyData.logical == LogicalKeyboardKey.space.keyId) {
        setState(() {
          gameOver = false;
          initGame();
        });
      }
      return false;
    };

    initGame();
  }

  bool snakeLeftViewport() {
    final head = snake[0];
    if (head.dx < 0 || head.dy < 0) return true;
    final width = html.window.innerWidth!;
    final height = html.window.innerHeight!;
    if (head.dx > width ~/ tileDimension || head.dy > height ~/ tileDimension) {
      return true;
    }
    return false;
  }

  void setGameOver() {
    setState(() {
      gameOver = true;
      timer.cancel();
    });
  }

  void initGame() {
    debugPrint('Game Over');
    setState(() {
      snake = [const Offset(10, 10)];
      food = const Offset(20, 20);
      direction = Direction.right;
    });

    timer = Timer.periodic(Duration(milliseconds: 1000 ~/ gameSpeed), (timer) {
      if (snakeLeftViewport()) {
        setGameOver();
      }

      setState(() {
        Offset head = snake.last;
        switch (direction) {
          case Direction.up:
            moveSnakeToOffset(offset: Offset(head.dx, head.dy - 1));
            break;
          case Direction.down:
            moveSnakeToOffset(offset: Offset(head.dx, head.dy + 1));
            break;
          case Direction.left:
            moveSnakeToOffset(offset: Offset(head.dx - 1, head.dy));
            break;
          case Direction.right:
            moveSnakeToOffset(offset: Offset(head.dx + 1, head.dy));
            break;
        }
        final Random random = Random();
        final width = html.window.innerWidth!;
        final height = html.window.innerHeight!;

        if (snake.last == food) {
          food = Offset(
            random.nextInt(width ~/ tileDimension).toDouble(),
            random.nextInt(height ~/ tileDimension).toDouble(),
          );
        } else {
          snake.removeAt(0);
        }
      });
    });
  }

  void moveSnakeToOffset({required Offset offset}) {
    if (snake.contains(offset)) {
      setGameOver();
      return;
    }
    snake.add(offset);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.black,
              child: CustomPaint(
                painter: SnakePainter(
                  snake,
                  food,
                  tileDimension,
                ),
              ),
            ),
            if (gameOver)
              Center(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    width: 300,
                    height: 250,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text(
                          'Game Over',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Press Enter to play again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Container()
          ],
        ),
      ),
    );
  }
}

class SnakePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;
  final double tileDimension;

  SnakePainter(
    this.snake,
    this.food,
    this.tileDimension,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final snakepaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final foodPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (int i = snake.length - 1; i >= 0; i--) {
      Offset offset = snake[i];
      canvas.drawRect(
        Rect.fromLTWH(
          offset.dx * tileDimension,
          offset.dy * tileDimension,
          tileDimension,
          tileDimension,
        ),
        snakepaint,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(
        food.dx * tileDimension,
        food.dy * tileDimension,
        tileDimension,
        tileDimension,
      ),
      foodPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
