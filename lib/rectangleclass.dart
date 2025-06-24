part of 'main.dart';

class RectangleClass {
  final PointClass topLeft;
  final PointClass bottomRight;
  final PointClass topRight;
  final PointClass bottomLeft;

  const RectangleClass({
    required this.topLeft,
    required this.bottomRight,
    required this.topRight,
    required this.bottomLeft,
  });

  double get area => _calculateArea();

  double _calculateArea() =>
    (bottomRight.x - bottomLeft.x).abs() * (topLeft.y - bottomLeft.y).abs();

  @override
  String toString() => 'Rectangle: [TopLeft: $topLeft, BottomRight: $bottomRight, TopRight: $topRight, BottomLeft: $bottomLeft]';

  static List<RectangleClass> generatePartialPermutations(Map<String, dynamic> params) {
    List<PointClass> partialStart = params['partialStart'];
    List<PointClass> remainingElements = params['remainingElements'];

    Set<PointClass> globalSet = Set.from(partialStart)..addAll(remainingElements);

    List<RectangleClass> result = [];

    void permute(List<PointClass> current, Set<PointClass> used) {
      if (current.length == 4) {
        result.add(RectangleClass(
          topLeft: current[0],
          bottomRight: current[1],
          topRight: current[2],
          bottomLeft: current[3],
        ));
        return;
      }

      for (PointClass item in globalSet.difference(used)) {
        current.add(item);
        used.add(item);
        permute(current, used);
        current.removeLast();
        used.remove(item);
      }
    }

    permute([], {});

    return result;
  }

  static Future<List<RectangleClass>> formRectangles(List<PointClass> points) async {
    int numWorkers = Platform.numberOfProcessors;
    int chunkSize = (points.length / numWorkers).ceil();

    List<List<PointClass>> chunks = [];

    for(int i = 0; i < points.length; i += chunkSize) {
      int end = i + chunkSize;
      if (end > points.length) end = points.length;
      chunks.add(points.sublist(i, end));
    }

    List<Future<List<RectangleClass>>> futures = [];
    for (int i = 0; i < chunks.length; i++) {
      final partialInput = chunks[i];
      final otherElements = RecursionClass.recursiveWhere(
        points,
        (p) => !partialInput.contains(p)).toList();

      futures.add(compute(generatePartialPermutations, <String, dynamic> {
        'partialStart': partialInput,
        'remainingElements': otherElements,
      }));
    }

    final results = await Future.wait(futures);

    return RecursionClass.recursiveWhere(
      results.expand((rects) => rects).toList(),
      (rect) => rect.topLeft.x == rect.bottomLeft.x &&
        rect.topLeft.y == rect.topRight.y &&
        rect.topRight.x == rect.bottomRight.x &&
        rect.bottomLeft.y == rect.bottomRight.y &&
        rect.bottomLeft.x < rect.bottomRight.x &&
        rect.topLeft.x < rect.topRight.x &&
        rect.bottomLeft.y < rect.topLeft.y &&
        rect.bottomRight.y < rect.topRight.y &&
        rect.topLeft != rect.topRight &&
        rect.topLeft != rect.bottomLeft &&
        rect.topLeft != rect.bottomRight &&
        rect.topRight != rect.bottomRight &&
        rect.topRight != rect.bottomLeft &&
        rect.bottomLeft != rect.bottomRight);
  }

  static List<RectangleClass> removeDuplicates(List<RectangleClass> rectangles) {
    final Set<String> seen = {};
    final List<RectangleClass> uniqueRectangles = [];

    for (final rect in rectangles) {
      final key = '${rect.topLeft.x},${rect.topLeft.y},'
                  '${rect.bottomRight.x},${rect.bottomRight.y}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueRectangles.add(rect);
      }
    }

    return uniqueRectangles;
  }

  static List<LineSeries<PointClass, double>> toLineSeries(List<RectangleClass> rectangles) {
    final List<List<PointClass>> pointsList = rectangles.map((rect) => [
      rect.topLeft,
      rect.topRight,
      rect.bottomRight,
      rect.bottomLeft,
      rect.topLeft // Closing the rectangle
    ]).toList();

    final areas = RecursionClass.recursiveMap(
      rectangles,
      (rect) => num.parse(rect.area.toStringAsFixed(2))
    );

    return RecursionClass.recursiveMap(
      pointsList,
      (points) => LineSeries<PointClass, double>(
        dataSource: points,
        xValueMapper: (point, _) => point.x,
        yValueMapper: (point, _) => point.y,
        name: 'R${pointsList.indexOf(points)}: Area:${areas[pointsList.indexOf(points)]} P1: ${points[0].toString()} P2: ${points[1].toString()} P3: ${points[2].toString()} P4: ${points[3].toString()}',
        dataLabelSettings: DataLabelSettings(isVisible: true),
      )
    );
  }
}