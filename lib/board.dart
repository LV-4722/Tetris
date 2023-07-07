import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/value.dart';

// import 'Value.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:tetris/level.dart';
// import 'package:tetris/piece.dart';
// import 'package:tetris/rotation.dart';
// import 'package:tetris/touch.dart';
// import 'package:tetris/vector.dart';

/* 

GAME BOARD

This is a 2x2 grid  with null representing an empty space.
A non empty space will have the color to represent the landed pieces

*/

// create game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  // current score
  int currentScore = 0;

  //game over status
  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    // start game when app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    //frame refresh rate
    Duration frameRate = const Duration(milliseconds: 400);
    gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        // clear lines
        clearLines();

        // check landing
        checkLanding();

        // check if game is over
        if (gameOver == true) {
          timer.cancel();
          showGameOverDialog();
        }

        // move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  //game over message
  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text("Your score is: $currentScore"),
        actions: [
          TextButton(
              onPressed: () {
                // reset the game
                resetGame();

                Navigator.pop(context);
              },
              child: const Text('Play Again')
            )
        ],
      ),
    );
  }

  // reset game
  void resetGame() {
    // clear the game board
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    // new game
    gameOver = false;
    currentScore = 0;

    // create new piece
    createPiece();

    //start game again
    startGame();
  }

  // check for collision in a future position
  // return true -> there is a collision
  // return false -> there is no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of the current piece
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }
      // check if the piece is out of bounds (either too low or too far to the left or right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }

    // if no collisions are detected, return false
    return false;
  }

  void checkLanding() {
    // if going down is occupied
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      // once landed, create the next piece
      createPiece();
    }
  }

  void createPiece() {
    // create a random object to generate random tetromino types
    Random rand = Random();

    // create a new piece with random type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    /*
    Since our game over condition is if there is a piece at the top level,
    you want to check if the game is over when you create a new piece,
    instead of checking every frame, because new pieces are still allowed to go through the top level,
    but if there is already a piece in the top level when the new piece is created,
    then game is over
    */
  }

  // move left
  void moveLeft() {
    // make sure the move is valid before moving there
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // move right
  void moveRight() {
    // make sure the move is valid before moving there
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  // rotate piece
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // clear lines
  void clearLines() {
    // step 1: loop through each row of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // step 2: initialize a variable to track if the row is full
      bool rowIsFull = true;

      // step 3: check if the row is full (all columns in the row are filled with pieces)
      for (int col = 0; col < rowLength; col++) {
        // if there's an empty column, set rowIsFull to false and break the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      //step 4: if the row is full, clear the row and shift rows down
      if (rowIsFull) {
        // step 5: move all rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          // copy the above row to the current row
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        // step 6: set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);

        // step 7:  increase the score!
        currentScore++;
      }
    }
  }

  //GAME OVER METHOD
  bool isGameOver() {
    // check if any columns in the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    // if the top row is empty, the game is not over
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // GAME GRID
            Expanded(
              child: GridView.builder(
                itemCount: rowLength * colLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength),
                itemBuilder: (context, index) {
                  // get row and col of each index
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;

                  // current piece
                  if (currentPiece.position.contains(index)) {
                    return Pixel(
                      color: currentPiece.color,
                      // child: index,
                    );
                  }

                  // landed pieces
                  else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(
                        color: tetrominoColors[tetrominoType], 
                        // child: '',
                      );
                  }

                  // blank pixel
                  else {
                    return Pixel(
                      color: Colors.grey[900],
                      // child: index,
                    );
                  }
                },
              ),
            ),

            // SCORE
            Text(
              'Score: $currentScore',
              style: TextStyle(color: Colors.white),
            ),

            // GAME CONTROLS
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // left
                  IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back_ios),
                  ),

                  // rotate
                  IconButton(
                      onPressed: rotatePiece,
                      color: Colors.white,
                      icon: Icon(Icons.rotate_right)),

                  // right
                  IconButton(
                      onPressed: moveRight,
                      color: Colors.white,
                      icon: Icon(Icons.arrow_forward_ios)),
                ],
              ),
            )
          ],
        ));
  }
}

// class Board extends ChangeNotifier {
//   static const Duration lockDelayTime = Duration(seconds: 1);
//   static const Duration animationTime = Duration(milliseconds: 600);
//   static const int x = 10;
//   static const int y = 2 * x;
//   static const bool isAnimationEnabled = true;

//   Ticker? _ticker;
//   int lastMovedTime = 0;

//   final List<Vector> _blocked;

//   Piece currentPiece;

//   Piece? holdPiece;

//   final List<Piece> _nextPieces = [];

//   List<Piece> get nextPieces => _nextPieces;

//   Vector _cursor;

//   Vector get cursor => _cursor;

//   int _clearedLines = 0;

//   int get clearedLines => _clearedLines;

//   List<AnimationController> animationController;

//   Board(TickerProvider tickerProvider)
//       : currentPiece = Piece.empty(),
//         _blocked = [],
//         _cursor = Vector.zero,
//         animationController = isAnimationEnabled
//             ? List.generate(
//                 x * y,
//                 (index) => AnimationController(
//                     duration: animationTime, vsync: tickerProvider),
//               )
//             : [] {
//     _ticker = tickerProvider.createTicker(onTick);
//     _ticker?.start();
//     startGame();
//   }

//   int ticks = 0;

//   void onTick(Duration elapsed) {
//     if (ticks % getLevel(clearedLines).speed == 0) {
//       move(const Vector(0, -1));
//     }
//     if (isBlockOut()) {
//       startGame();
//     } else if (!canMove(const Vector(0, -1)) && isLockDelayExpired()) {
//       merge();
//       clearRows();
//       spawn();
//     }
//     ticks++;
//   }

//   @override
//   void dispose() {
//     _ticker?.stop(canceled: true);
//     super.dispose();
//   }

//   bool isLockDelayExpired() =>
//       lastMovedTime <
//       DateTime.now().millisecondsSinceEpoch - lockDelayTime.inMilliseconds;

//   void hardDrop() {
//     while (move(const Vector(0, -1))) {}
//     lastMovedTime = 0;
//   }

//   void startGame() {
//     reset();
//   }

//   bool isBlocked(Vector v) => _blocked.contains(v);

//   bool isCurrentPieceTile(Vector v) => currentPiece.tiles.contains(v - _cursor);

//   bool isFree({Vector offset = Vector.zero}) => currentPiece.tiles
//       .where((v) => _blocked.contains(v + _cursor + offset))
//       .isEmpty;

//   bool inBounds({Vector offset = Vector.zero}) =>
//       currentPiece.tiles
//           .where((v) => v + _cursor + offset >= const Vector(x, y))
//           .isEmpty &&
//       currentPiece.tiles
//           .where((v) => v + _cursor + offset < Vector.zero)
//           .isEmpty;

//   bool move(Vector offset) {
//     if (canMove(offset)) {
//       _cursor += offset;
//       _notify();
//       return true;
//     }
//     return false;
//   }

//   bool canMove(Vector offset) =>
//       inBounds(offset: offset) && isFree(offset: offset);

//   bool rotate({bool clockwise = true}) {
//     final from = currentPiece.rotation;
//     currentPiece.rotate(clockwise: clockwise);
//     if (inBounds() && isFree()) {
//       // always apply first kick translation to correct o piece "wobble"
//       final kick =
//           currentPiece.getKicks(from: from, clockwise: clockwise).first;
//       if (canMove(kick)) {
//         _cursor += kick;
//       }
//       debugPrint('$from${currentPiece.rotation} rotated with first kick $kick');
//       _notify();
//       return true;
//     } else {
//       final kicks = currentPiece.getKicks(from: from, clockwise: clockwise);
//       for (final kick in kicks) {
//         if (inBounds(offset: kick) && isFree(offset: kick)) {
//           _cursor += kick;
//           debugPrint('$from${currentPiece.rotation} rotated with kick $kick');
//           _notify();
//           return true;
//         }
//       }
//     }
//     debugPrint('Rotation reverted');
//     currentPiece.rotate(clockwise: !clockwise);
//     return false;
//   }

//   void spawn() {
//     if (_nextPieces.length <= 3) {
//       _nextPieces.addAll(nextPieceBag);
//     }
//     currentPiece = _nextPieces[0];
//     _nextPieces.removeAt(0);
//     _cursor = currentPiece.spawnOffset(x, y);
//     _notify();
//   }

//   void merge() {
//     for (final element in currentPiece.tiles) {
//       _blocked.add(element + _cursor);
//     }
//   }

//   void clearRows() {
//     var clearedRows = 0;
//     var blocked = List.of(_blocked);
//     for (var yp = y - 1; yp >= 0; yp--) {
//       final result = _blocked.where((element) => element.y == yp);
//       if (result.length == x) {
//         clearedRows++;
//         final belowVectors = blocked.where((element) => element.y < yp);
//         final aboveVectors = blocked
//             .where((element) => element.y > yp)
//             .map((e) => e + const Vector(0, -1));
//         blocked = [...belowVectors, ...aboveVectors];
//         debugPrint('Cleared row $yp');
//         if (isAnimationEnabled) {
//           for (var x = 0; x < Board.x; x++) {
//             final index = (Board.y - yp - 1) * Board.x + x;
//             animationController[index]
//               ..forward()
//               ..addStatusListener((status) {
//                 if (status == AnimationStatus.dismissed ||
//                     status == AnimationStatus.completed) {
//                   _blocked
//                     ..clear()
//                     ..addAll(blocked);
//                   _notify();
//                   animationController[index].reset();
//                 }
//               });
//           }
//         }
//       }
//     }
//     if (!isAnimationEnabled) {
//       _blocked
//         ..clear()
//         ..addAll(blocked);
//     }
//     _clearedLines += clearedRows;
//   }

//   void hold() {
//     final tmp = currentPiece;
//     while (tmp.rotation != Rotation.zero) {
//       tmp.rotate();
//     }
//     if (holdPiece == null) {
//       holdPiece = tmp;
//       spawn();
//     } else {
//       currentPiece = holdPiece!;
//       holdPiece = tmp;
//     }
//     _cursor = currentPiece.spawnOffset(x, y);
//     _notify();
//   }

//   void reset() {
//     spawn();
//     _blocked
//       ..clear()
//       ..addAll(getPredefinedBlockedTiles());
//     _clearedLines = 0;
//     holdPiece = null;
//   }

//   /// https://harddrop.com/wiki/Top_out
//   bool isBlockOut() => _blocked.where((e) => e.y == y - 1).isNotEmpty;

//   // Map grid tile index to a vector.
//   // ignore: unused_element
//   Vector _tileVectorFromIndex(int index) {
//     final xp = index % x;
//     final yp = y - ((index - index % x) / x).round() - 1;
//     return Vector(xp, yp);
//   }

//   void _notify() {
//     lastMovedTime = DateTime.now().millisecondsSinceEpoch;
//     notifyListeners();
//   }

//   bool isGhostTile(Vector v) {
//     var offset = const Vector(0, -1);
//     while (canMove(offset)) {
//       offset += const Vector(0, -1);
//     }
//     return currentPiece.tiles
//         .contains(v - _cursor - offset - const Vector(0, 1));
//   }

//   Tile _getTile(Vector vector) {
//     if (isBlocked(vector)) {
//       return Tile.blocked;
//     } else if (isCurrentPieceTile(vector)) {
//       return Tile.piece;
//     } else if (isGhostTile(vector)) {
//       return Tile.ghost;
//     }
//     return Tile.blank;
//   }

//   List<Tile> getTiles() => List.generate(
//       Board.x * Board.y, (index) => _getTile(_tileVectorFromIndex(index)));

//   static List<Vector> getPredefinedBlockedTiles() {
//     final board = [
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],

//       // empty
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],

//       // clear rows test
//       //[1, 1, 1, 1, 1, 1, 1, 0, 0, 1],
//       //[1, 1, 1, 1, 1, 1, 0, 0, 1, 1],
//       //[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
//       //[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
//       //[0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//       //[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],

//       // j piece test
//       //[0, 0, 0, 0, 0, 0, 0, 1, 1, 1],
//       //[0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
//       //[0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
//       //[0, 0, 0, 0, 0, 1, 1, 0, 0, 1],
//       //[0, 0, 0, 0, 0, 1, 1, 0, 1, 1],
//       //[0, 0, 0, 0, 0, 1, 1, 0, 1, 1],

//       // t piece test
//       //[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       //[1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
//       //[1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       //[1, 0, 1, 1, 0, 0, 0, 0, 0, 0],
//       //[1, 0, 0, 1, 0, 0, 0, 0, 0, 0],
//       //[1, 0, 1, 1, 0, 0, 0, 0, 0, 0],

//       // i piece test
//       //[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       //[1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
//       //[1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
//       //[1, 1, 0, 1, 0, 0, 0, 0, 0, 0],
//       //[1, 1, 0, 1, 1, 1, 0, 0, 0, 0],
//       //[1, 1, 0, 1, 1, 1, 0, 0, 0, 0],

//       // i piece test
//       //[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       //[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//       //[0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
//       //[1, 1, 1, 0, 0, 0, 0, 1, 0, 0],
//       //[1, 1, 0, 0, 0, 0, 0, 1, 0, 0],
//       //[1, 0, 0, 0, 0, 1, 1, 1, 0, 0],
//     ].reversed.toList();
//     final blocked = <Vector>[];
//     for (var yp = 0; yp < board.length; yp++) {
//       for (var xp = 0; xp < board.first.length; xp++) {
//         if (board[yp][xp] == 1) {
//           blocked.add(Vector(xp, yp));
//         }
//       }
//     }
//     return blocked;
//   }

//   KeyEventResult onKey(FocusNode node, RawKeyEvent event) {
//     if (event is RawKeyDownEvent) {
//       if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
//         move(const Vector(-1, 0));
//       } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
//         move(const Vector(1, 0));
//       } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
//         hold();
//       } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
//         move(const Vector(0, -1));
//       } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
//         rotate(clockwise: false);
//       } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
//         rotate();
//       } else if (event.logicalKey == LogicalKeyboardKey.space) {
//         hardDrop();
//       } else if (event.logicalKey == LogicalKeyboardKey.escape) {
//         _nextPieces.clear();
//         startGame();
//       }
//     }
//     return KeyEventResult.handled;
//   }

//   void onTapUp(BuildContext context, TapUpDetails details) {
//     final box = context.findRenderObject() as RenderBox;
//     final localOffset = box.globalToLocal(details.globalPosition);
//     final x = localOffset.dx;
//     final clockwise = x >= box.size.width / 2;
//     rotate(clockwise: clockwise);
//   }

//   void onTouch(TouchAction action) {
//     switch (action) {
//       case TouchAction.right:
//         move(const Vector(1, 0));
//         break;
//       case TouchAction.left:
//         move(const Vector(-1, 0));
//         break;
//       case TouchAction.up:
//         break;
//       case TouchAction.down:
//         move(const Vector(0, -1));
//         break;
//       case TouchAction.upEnd:
//         hold();
//         break;
//       case TouchAction.downEnd:
//         hardDrop();
//         break;
//     }
//   }
// }

// enum Tile { blank, blocked, piece, ghost }
