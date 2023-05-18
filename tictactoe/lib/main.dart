// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(
    MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return const TicTacToeGame();
          },
        ),
      ),
    ),
  );
}

enum GameField {
  X('X', true, Colors.blue),
  O('O', true, Colors.red),
  xHover('X', false, Color.fromARGB(108, 33, 149, 243)),
  oHover('O', false, Color.fromARGB(103, 244, 67, 54)),
  none('', false, Colors.transparent);

  const GameField(this.represent, this.filled, this.color);

  final String represent;
  final bool filled;
  final Color color;
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  bool isNextPlayerX = true;
  bool tiedGame = false;
  GameField winner = GameField.none;
  List<List<GameField>> _board = List.generate(
    3,
    (index) => List.filled(3, GameField.none),
  );

  void onCellTap(int row, int col) {
    final field = _board[row][col];
    if (field.filled) return;

    setState(() {
      final nextMove = isNextPlayerX ? GameField.X : GameField.O;
      _board[row][col] = nextMove;
      isNextPlayerX = !isNextPlayerX;
      checkWin();
      if (winner == GameField.none) {
        final bool allFilled = !_board.expand((c) => c).any((cell) {
          return cell == GameField.none;
        });
        if (allFilled) {
          tiedGame = true;
        }
      }
    });
  }

  void checkWin() {
    // check for rows
    for (final row in _board) {
      checkSublist(row);
    }
    // check for columns filled by one player

    for (var i = 0; i < 3; i++) {
      List<GameField> seen = [];
      for (var j = 0; j < 3; j++) {
        seen.add(_board[j][i]);
      }
      checkSublist(seen);
    }

    // check for diagonal win
    checkSublist([_board[0][0], _board[1][1], _board[2][2]]);
    checkSublist([_board[0][2], _board[1][1], _board[2][0]]);
  }

  void checkSublist(List<GameField> sub) {
    if (winner != GameField.none) return;
    if (sub.every((element) => element == GameField.X)) {
      setState(() => winner = GameField.X);
    }
    if (sub.every((element) => element == GameField.O)) {
      setState(() => winner = GameField.O);
    }
  }

  void onHover(int row, int col) {
    final field = _board[row][col];
    if (field.filled) return;
    setState(() {
      final nextMove = isNextPlayerX ? GameField.xHover : GameField.oHover;
      _board[row][col] = nextMove;
    });
  }

  void onHoverExit(int row, int col) {
    final field = _board[row][col];
    if (field == GameField.oHover || field == GameField.xHover) {
      _board[row][col] = GameField.none;
    }
  }

  void replayGame() {
    setState(() {
      isNextPlayerX = true;
      tiedGame = false;
      winner = GameField.none;
      _board = List.generate(
        3,
        (index) => List.filled(3, GameField.none),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int row = 0; row < 3; row++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _board[row].mapIndexed(
                  (col, field) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GameCell(
                        field: field,
                        onTap: () => onCellTap(row, col),
                        onHover: () => onHover(row, col),
                        onHoverEnd: () => onHoverExit(row, col),
                      ),
                    );
                  },
                ).toList(),
              )
          ],
        ),
        if (winner != GameField.none || tiedGame)
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Container(
                color: Colors.black.withOpacity(0.85),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => replayGame(),
                  child: Text(
                    tiedGame ? 'Tied Game!' : 'Winner: ${winner.represent}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}

class GameCell extends StatelessWidget {
  const GameCell({
    super.key,
    required this.field,
    required this.onTap,
    required this.onHover,
    required this.onHoverEnd,
  });

  final GameField field;
  final VoidCallback onTap;
  final VoidCallback onHover;
  final VoidCallback onHoverEnd;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    return MouseRegion(
      onEnter: (_) => onHover(),
      onExit: (_) => onHoverEnd(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: mq.size.width / 5,
          height: mq.size.width / 5,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.5,
            ),
            color: field.color,
          ),
          child: Center(
            child: LayoutBuilder(builder: (context, box) {
              return ConstrainedBox(
                constraints: BoxConstraints.expand(
                    width: box.maxHeight * 0.7, height: box.maxHeight * 0.7),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Text(
                    field.represent,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.75),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
