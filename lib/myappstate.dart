part of 'main.dart';

class MyAppState extends ChangeNotifier {
  var state = 0;
  String currentLabel = '';

  Map<String, List<PointClass>> data = {};
  List<RectangleClass> rectangles = [];
  List<SquareClass> squares = [];
  List<TriangleClass> acute = [];
  List<TriangleClass> rectTriangle = [];

  void loadData() async {
    data = await getDBData();

    notifyListeners();
  }

  void addPoint(PointClass point) {
    final points = data.putIfAbsent(point.label, () => []);
    final exists = points.any((p) => p.x == point.x && p.y == point.y);
    if (!exists) {
      points.add(point);
      notifyListeners();
      _savePointToDB(point);
    }
  }

  void setCurrentLabel(String label) {
    currentLabel = label;
    if (data.containsKey(label)) {
      RectangleClass.formRectangles(data[label]!).then((rects) => rectangles = rects);
      SquareClass.formSquares(data[label]!).then((sqs) => squares = sqs);
      TriangleClass.formAcuteTriangles(data[label]!).then((tri) => acute = tri);
      TriangleClass.formRectangleAngles(data[label]!).then((tri) => rectTriangle = tri);
    } else {
      rectangles = [];
      squares = [];
      acute = [];
      rectTriangle = [];
    }
    rectangles = RectangleClass.removeDuplicates(rectangles);
    squares = SquareClass.removeDuplicates(squares);
    acute = TriangleClass.removeDuplicates(acute);
    rectTriangle = TriangleClass.removeDuplicates(rectTriangle);

    notifyListeners();
  }

  Future<Database> getDatabase() async =>
    openDatabase(
      join(await getDatabasesPath(), 'puntos.db'),
      onCreate: (db, version) => db.execute(
        'CREATE TABLE points(id INTEGER PRIMARY KEY, x REAL, y REAL, label TEXT)',
      ),
      version: 1,
    );

  Future<Map<String, List<PointClass>>> getDBData() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('points');

    final Map<String, List<PointClass>> data = {};
    for (var map in maps) {
      final point = PointClass(
        map['x'] as double,
        map['y'] as double,
        label: map['label'] as String,
      );
      if (!data.containsKey(point.label)) data[point.label] = [];
      data[point.label]!.add(point);
    }

    return data;
  }

  void _savePointToDB(PointClass point) async {
    final db = await getDatabase();
    await db.insert(
      'points',
      {
        'x': point.x,
        'y': point.y,
        'label': point.label,
      },
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }
}