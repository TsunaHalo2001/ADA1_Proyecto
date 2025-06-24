part of 'main.dart';

class TriangleClass {
  final PointClass pointA;
  final PointClass pointB;
  final PointClass pointC;

  const TriangleClass(this.pointA, this.pointB, this.pointC);

  int get angleA => _calculateAngle(pointB, pointC, pointA);
  int get angleB => _calculateAngle(pointA, pointC, pointB);
  int get angleC => _calculateAngle(pointA, pointB, pointC);
  double get area => _calculateArea();

  bool get isAcute => angleA < 90 && angleB < 90 && angleC < 90;
  bool get isRight => angleA == 90 || angleB == 90 || angleC == 90;

  int _calculateAngle(PointClass p1, PointClass p2, PointClass p3) {
    final a = _distance(p2, p3);
    final b = _distance(p1, p3);
    final c = _distance(p1, p2);
    return ((180 / pi) * acos((a * a + b * b - c * c) / (2 * a * b))).round();
  }

  double _distance(PointClass p1, PointClass p2) =>
    sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));

  double _calculateArea() {
    final a = _distance(pointB, pointC);
    final b = _distance(pointA, pointC);
    final c = _distance(pointA, pointB);
    final s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }

  static List<TriangleClass> generatePartialPermutations(Map<String, dynamic> params) {
    List<PointClass> partialStart = params['partialStart'];
    List<PointClass> remainingElements = params['remainingElements'];

    Set<PointClass> globalSet = Set.from(partialStart)..addAll(remainingElements);

    List<TriangleClass> result = [];

    void permute(List<PointClass> current, Set<PointClass> used) {
      if (current.length == 3) {
        result.add(TriangleClass(current[0], current[1], current[2]));
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

  static Future<List<TriangleClass>> formTriangles(List<PointClass> points) async {
    int numWorkers = Platform.numberOfProcessors;
    int chunkSize = (points.length / numWorkers).ceil();

    List<List<PointClass>> chunks = [];

    for(int i = 0; i < points.length; i += chunkSize) {
      int end = i + chunkSize;
      if (end > points.length) end = points.length;
      chunks.add(points.sublist(i, end));
    }

    List<Future<List<TriangleClass>>> futures = [];
    for (int i = 0; i < chunks.length; i++) {
      final partialInput = chunks[i];
      final otherElements = RecursionClass.recursiveWhere(
        points,
        (p) => !partialInput.contains(p)
      ).toList();

      futures.add(compute(generatePartialPermutations, <String, dynamic> {
        'partialStart': partialInput,
        'remainingElements': otherElements,
      }));
    }

    final results = await Future.wait(futures);

    final objective = results.expand((triangles) => triangles).toList();

    return removeDuplicatesByPoints(objective);
  }

  static List<TriangleClass> removeDuplicates(List<TriangleClass> triangles) {
    final Set<String> seen = {};
    final List<TriangleClass> uniqueTriangles = [];

    for (final triangle in triangles) {
      final key = '${triangle.pointA.x},${triangle.pointA.y},'
                  '${triangle.pointB.x},${triangle.pointB.y},'
                  '${triangle.pointC.x},${triangle.pointC.y}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueTriangles.add(triangle);
      }
    }

    return uniqueTriangles;
  }

  static List<TriangleClass> removeDuplicatesByPoints(List<TriangleClass> triangles) {
    final Set<String> seen = {};
    final List<TriangleClass> uniqueTriangles = [];

    for (final triangle in triangles) {
      final pointsNS = [triangle.pointA, triangle.pointB, triangle.pointC];
      final points = RecursionClass.recursiveMergeSort(
        pointsNS,
        (a, b) => a.x.compareTo(b.x) == 0 ? a.y.compareTo(b.y) : a.x.compareTo(b.x)
      );
      final key = '${points[0].x},${points[0].y},'
                  '${points[1].x},${points[1].y},'
                  '${points[2].x},${points[2].y}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueTriangles.add(triangle);
      }
    }

    return uniqueTriangles;
  }

  static Future<List<TriangleClass>> formRectangleAngles(List<PointClass> points) async {
    return formTriangles(points).then((triangles) =>
      RecursionClass.recursiveWhere(
        triangles,
        (triangle) => triangle.isRight
      ).toList()
    );
  }

  static Future<List<TriangleClass>> formAcuteTriangles(List<PointClass> points) async {
    return formTriangles(points).then((triangles) =>
      RecursionClass.recursiveWhere(
        triangles,
        (triangle) => triangle.isAcute
      ).toList()
    );
  }

  @override
  String toString() {
    return 'Triangle: [A: $pointA, B: $pointB, C: $pointC, Angles: A=$angleA, B=$angleB, C=$angleC]';
  }

  static List<LineSeries<PointClass, double>> toLineSeries(List<TriangleClass> triangles) {
    final List<List<PointClass>> pointsList = triangles.map((triangle) => [
      triangle.pointA,
      triangle.pointB,
      triangle.pointC,
      triangle.pointA // Closing the triangle
    ]).toList();

    final areas = RecursionClass.recursiveMap(
      triangles,
      (triangle) => num.parse(triangle.area.toStringAsFixed(2))
    );

    return RecursionClass.recursiveMap(
      pointsList,
      (points) => LineSeries<PointClass, double>(
        dataSource: points,
        xValueMapper: (point, _) => point.x,
        yValueMapper: (point, _) => point.y,
        name: 'T${pointsList.indexOf(points)}: Area:${areas[pointsList.indexOf(points)]} P1:${points[0].toString()} P2:${points[1].toString()} P3:${points[2].toString()}',
        dataLabelSettings: DataLabelSettings(isVisible: true),
      )
    );
  }
}