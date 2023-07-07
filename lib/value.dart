import 'package:flutter/material.dart';

// grid dimensions
int rowLength = 10;
int colLength = 15;

enum Direction {
  left,
  right,
  down,
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color(0xFFFFA500), // orange
  Tetromino.J: Color.fromARGB(255, 0, 102, 255), // blue
  Tetromino.I: Color.fromARGB(255, 242, 0, 255), // pink
  Tetromino.O: Color(0xFFFFFF00), // yellow
  Tetromino.S: Color(0xFF008000), // green
  Tetromino.Z: Color(0xFFFF0000), // red
  Tetromino.T: Color.fromARGB(255, 144, 0, 255), // purple
};

// import 'package:flutter/material.dart';

// @immutable
// class Vector {
//   final int x;
//   final int y;

//   const Vector(this.x, this.y);

//   static const zero = Vector(0, 0);

//   Vector operator +(Vector other) => Vector(x + other.x, y + other.y);

//   Vector operator -(Vector other) => Vector(x - other.x, y - other.y);

//   Vector operator *(Vector other) => Vector(x * other.x, y * other.y);

//   bool operator <(Vector other) => x < other.x || y < other.y;

//   bool operator >=(Vector other) => x >= other.x || y >= other.y;

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     return other is Vector && x == other.x && y == other.y;
//   }

//   @override
//   int get hashCode => Object.hash(x, y);

//   @override
//   String toString() => '$x,$y';
// }