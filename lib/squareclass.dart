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

  static List<LineSeries<PointClass, double>> toLineSeries(List<SquareClass> squares) {
    final List<List<PointClass>> pointsList = squares.map((square) => [
      square.topLeft,
      square.topRight,
      square.bottomRight,
      square.bottomLeft,
      square.topLeft // Closing the square
    ]).toList();

    final areas = RecursionClass.recursiveMap(
      squares, 
      (square) => num.parse(square.area.toStringAsFixed(2))
    );
    
    return RecursionClass.recursiveMap(
      pointsList,
      (points) => LineSeries<PointClass, double>(
        dataSource: points,
        xValueMapper: (point, _) => point.x,
        yValueMapper: (point, _) => point.y,
        name: 'S${pointsList.indexOf(points)}: ${areas[pointsList.indexOf(points)]}',
        dataLabelSettings: DataLabelSettings(isVisible: true),
      )
    );
  }

  @override
  String toString() => 'Square: [TopLeft: $topLeft, BottomRight: $bottomRight, TopRight: $topRight, BottomLeft: $bottomLeft]';
}