part of 'main.dart';

class SquareClass extends RectangleClass {
  const SquareClass({
    required super.topLeft,
    required super.bottomRight,
    required super.topRight,
    required super.bottomLeft
  });

  static Future<List<SquareClass>> formSquares(List<PointClass> points) async {
    return RectangleClass.formRectangles(points).then((rects) =>
    rects.where((rect) =>
      rect.topRight.x - rect.topLeft.x == rect.topRight.y - rect.bottomRight.y
    ).map((rect) => SquareClass(
        topLeft: rect.topLeft,
        bottomRight: rect.bottomRight,
        topRight: rect.topRight,
        bottomLeft: rect.bottomLeft,
      )).toList()
    );
  }

  static List<SquareClass> removeDuplicates(List<SquareClass> squares) {
    final Set<String> seen = {};
    final List<SquareClass> uniqueSquares = [];

    for (final square in squares) {
      final key = '${square.topLeft.x},${square.topLeft.y},'
                  '${square.bottomRight.x},${square.bottomRight.y}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueSquares.add(square);
      }
    }

    return uniqueSquares;
  }

  @override
  String toString() => 'Square: [TopLeft: $topLeft, BottomRight: $bottomRight, TopRight: $topRight, BottomLeft: $bottomLeft]';
}