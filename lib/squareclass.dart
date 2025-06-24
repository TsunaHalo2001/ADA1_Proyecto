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
      RecursionClass.recursiveMap(
        RecursionClass.recursiveWhere(
          rects,
          (rect) =>
            rect.topRight.x - rect.topLeft.x == rect.topRight.y - rect.bottomRight.y).toList(),
        (rect) =>
          SquareClass(
            topLeft: rect.topLeft,
            bottomRight: rect.bottomRight,
            topRight: rect.topRight,
            bottomLeft: rect.bottomLeft,
          )
      )
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

  static LineSeries<PointClass, double> toLineSeries(List<SquareClass> squares) {
    final List<PointClass> points = squares.expand((rect) => [
      rect.topLeft, rect.topRight, rect.bottomRight, rect.bottomLeft, rect.topLeft
    ]).toList();

    return LineSeries<PointClass, double>(
      dataSource: points,
      xValueMapper: (PointClass point, _) => point.x,
      yValueMapper: (PointClass point, _) => point.y,
      name: 'Squares',
      color: Colors.indigo,
      markerSettings: MarkerSettings(isVisible: true),
    );
  }

  @override
  String toString() => 'Square: [TopLeft: $topLeft, BottomRight: $bottomRight, TopRight: $topRight, BottomLeft: $bottomLeft]';
}