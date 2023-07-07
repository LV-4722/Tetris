import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tetris/board.dart';

import 'value.dart';

class Piece {
  // type of tetris piece
  Tetromino type;

  Piece({required this.type});

  // the piece is just a list of integers
  List<int> position = [];

  // color of tetris piece
  Color get color {
    return tetrominoColors[type] ??
        const Color(0xFFFFFFFF); //default to white if no color is found
  }

  // generate the integers
  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [
          -26,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.J:
        position = [
          -25,
          -15,
          -5,
          -6,
        ];
        break;
      case Tetromino.I:
        position = [
          -4,
          -5,
          -6,
          -7,
        ];
        break;
      case Tetromino.O:
        position = [
          -15,
          -16,
          -5,
          -6,
        ];
        break;
      case Tetromino.S:
        position = [
          -15,
          -14,
          -6,
          -5,
        ];
        break;
      case Tetromino.Z:
        position = [
          -17,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.T:
        position = [
          -26,
          -16,
          -6,
          -15,
        ];
        break;
      default:
    }
  }

  // move piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  // rotate piece
  int rotationState = 1;
  void rotatePiece() {
    // new position
    List<int> newPosition = [];

    //rotate the piece based on it's type
    switch (type) {

      case Tetromino.L:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState =  0;  // reset rotation to 0
            }
            break;
        }
        break;

      case Tetromino.J:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLength + 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;  // reset rotation to 0
            }
            break;
        }
        break;
      
      case Tetromino.I: 
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[1]  + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - 2 * rowLength,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState =  0;  // reset rotation to 0
            }
            break;
        }
        break;

        case Tetromino.O:
        // the O termino does not need to be rotated
        break;

        case Tetromino.S:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState =  0;  // reset rotation to 0
            }
            break;
        }
        break;

        case Tetromino.Z:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState =  0;  // reset rotation to 0
            }
            break;
        }
        break;

        case Tetromino.T:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[2] + 1,
              position[2] + rowLength,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + rowLength,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[2] - rowLength,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            // check that this new position is a valid position before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState =  0;  // reset rotation to 0
            }
            break;
        }
        break;
      default:
    }
  }

  // check if valid position
  bool positionIsValid(int position) {
    // get the row and col of position
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    // if the position is taken, return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }

    // otherwise position is valid return true
    else {
      return true;
    }
  }

  //check if piece is valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      // return false if any position is already taken
      if (!positionIsValid(pos)) {
        return false;
      }

      //get the col of position
      int col = pos % rowLength;

      // check if the first or last column is occupied
      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    // if there is a piece in the first col and last col, it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }
}

// import 'dart:math';

// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:tetris/rotation.dart';
// import 'package:tetris/vector.dart';

// /// https://harddrop.com/wiki/Random_Generator
// List<Piece> get nextPieceBag => _tiles
//     .mapIndexed((index, element) => Piece(
//           center: _center[index],
//           color: _colors[index],
//           tiles: element,
//           offsets: _offsets[index],
//         ))
//     .toList()
//   ..shuffle(); // 7! permutations (5040)

// class Piece {
//   final Vector center;
//   final Color color;
//   final List<Vector> tiles = [];
//   final Map<String, List<Vector>> offsets;

//   Rotation rotation = Rotation.zero;

//   Piece({
//     required this.color,
//     required this.offsets,
//     required this.center,
//     required List<List<int>> tiles,
//   }) {
//     tiles = tiles.reversed.toList();
//     for (var yp = 0; yp < tiles.length; yp++) {
//       for (var xp = 0; xp < tiles.first.length; xp++) {
//         if (tiles[yp][xp] == 1) {
//           this.tiles.add(Vector(xp, yp));
//         }
//       }
//     }
//   }

//   Piece.empty()
//       : center = Vector.zero,
//         color = const Color(0xFF000000),
//         offsets = {};

//   void rotate({bool clockwise = true}) {
//     final angle = clockwise ? -pi / 2 : pi / 2;
//     for (var i = 0; i < tiles.length; i++) {
//       final p = tiles[i];
//       final px = cos(angle) * (p.x - center.x) -
//           sin(angle) * (p.y - center.y) +
//           center.x;
//       final py = sin(angle) * (p.x - center.x) +
//           cos(angle) * (p.y - center.y) +
//           center.y;
//       tiles[i] = Vector(px.round(), py.round());
//     }
//     rotation = _nextRotation(rotation, clockwise);
//   }

//   Vector spawnOffset(int w, int h) => Vector(
//         --w ~/ 2 - tiles.map((e) => e.x).reduce(max) ~/ 2,
//         --h - tiles.map((e) => e.y).reduce(max),
//       );

//   List<Vector> getKicks({required Rotation from, bool clockwise = true}) {
//     final fromOffsets = offsets['$from'];
//     final toOffsets = offsets['${_nextRotation(from, clockwise)}'];
//     final result = <Vector>[];
//     for (var index = 0; index < fromOffsets!.length + 1; index++) {
//       final fromOffset = fromOffsets[index % fromOffsets.length];
//       final toOffset = toOffsets![index % toOffsets.length];
//       if (clockwise || fromOffsets.length == 1) {
//         // o piece
//         result.add(fromOffset - toOffset);
//       } else {
//         result.add(toOffset - fromOffset);
//       }
//     }
//     return result;
//   }

//   Rotation _nextRotation(Rotation rotation, bool clockwise) => Rotation
//       .values[(rotation.index + (clockwise ? 1 : -1)) % Rotation.values.length];

//   int get width => tiles.reduce((a, b) => a.x > b.x ? a : b).x + 1;

//   int get height => tiles.reduce((a, b) => a.y > b.y ? a : b).y + 1;
// }

// const _tiles = [
//   [
//     [1, 1, 1, 1]
//   ],
//   [
//     [1, 1],
//     [1, 1],
//   ],
//   [
//     [0, 1, 0],
//     [1, 1, 1],
//   ],
//   [
//     [1, 0, 0],
//     [1, 1, 1],
//   ],
//   [
//     [0, 0, 1],
//     [1, 1, 1],
//   ],
//   [
//     [0, 1, 1],
//     [1, 1, 0],
//   ],
//   [
//     [1, 1, 0],
//     [0, 1, 1],
//   ],
// ];

// const _colors = [
//   Colors.teal,
//   Colors.yellow,
//   Colors.purple,
//   Colors.blue,
//   Colors.orange,
//   Colors.green,
//   Colors.red,
// ];

// const _center = [
//   Vector(1, 0),
//   Vector.zero,
//   Vector(1, 0),
//   Vector(1, 0),
//   Vector(1, 0),
//   Vector(1, 0),
//   Vector(1, 0),
// ];

// /// https://tetris.wiki/Super_Rotation_System#How_Guideline_SRS_Really_Works
// const _offsets = [
//   _iOffsetData,
//   _oOffsetData,
//   _jlstzOffsetData,
//   _jlstzOffsetData,
//   _jlstzOffsetData,
//   _jlstzOffsetData,
//   _jlstzOffsetData,
// ];

// const _jlstzOffsetData = {
//   '0': [Vector.zero, Vector.zero, Vector.zero, Vector.zero, Vector.zero],
//   'R': [Vector.zero, Vector(1, 0), Vector(1, -1), Vector(0, 2), Vector(1, 2)],
//   '2': [Vector.zero, Vector.zero, Vector.zero, Vector.zero, Vector.zero],
//   'L': [
//     Vector.zero,
//     Vector(-1, 0),
//     Vector(-1, -1),
//     Vector(0, 2),
//     Vector(-1, 2)
//   ],
// };

// const _iOffsetData = {
//   '0': [Vector.zero, Vector(-1, 0), Vector(2, 0), Vector(-1, 0), Vector(2, 0)],
//   'R': [Vector(-1, 0), Vector.zero, Vector.zero, Vector(0, 1), Vector(0, -2)],
//   '2': [
//     Vector(-1, 1),
//     Vector(1, 1),
//     Vector(-2, 1),
//     Vector(1, 0),
//     Vector(-2, 0)
//   ],
//   'L': [Vector(0, 1), Vector(0, 1), Vector(0, 1), Vector(0, -1), Vector(0, 2)],
// };

// const _oOffsetData = {
//   '0': [Vector.zero],
//   'R': [Vector(0, -1)],
//   '2': [Vector(-1, -1)],
//   'L': [Vector(-1, 0)],
// };