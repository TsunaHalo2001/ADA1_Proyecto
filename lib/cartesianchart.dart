part of 'main.dart';

class CartesianChart extends StatefulWidget {
  const CartesianChart({super.key});

  @override
  State<CartesianChart> createState() => _CartesianChartState();
}

class _CartesianChartState extends State<CartesianChart> {
  var indexFigures = 0;

  void setIndexFigures1() => setState(() => indexFigures = 1);
  void setIndexFigures2() => setState(() => indexFigures = 2);
  void setIndexFigures3() => setState(() => indexFigures = 3);
  void setIndexFigures4() => setState(() => indexFigures = 4);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    Size size = MediaQuery.of(context).size;

    final List<RectangleClass> nRectangles = RectangleClass.removeDuplicates(appState.rectangles);
    final List<SquareClass> nSquares = SquareClass.removeDuplicates(appState.squares);
    final List<TriangleClass> nAcute = TriangleClass.removeDuplicates(appState.acute);
    final List<TriangleClass> nRectTriangle = TriangleClass.removeDuplicates(appState.rectTriangle);

    final List<RectangleClass> rectangles = RecursionClass.recursiveMergeSort(
      nRectangles,
      (a, b) => a.area.compareTo(b.area),
    );

    final List<SquareClass> squares = RecursionClass.recursiveMergeSort(
      nSquares,
      (a, b) => a.area.compareTo(b.area),
    );

    final List<TriangleClass> acute = RecursionClass.recursiveMergeSort(
      nAcute,
      (a, b) => a.area.compareTo(b.area),
    );

    final List<TriangleClass> rectTriangle = RecursionClass.recursiveMergeSort(
      nRectTriangle,
      (a, b) => a.area.compareTo(b.area),
    );

    List<LineSeries<PointClass, double>> figures = [];

    switch (indexFigures) {
      case 1:
        figures = RectangleClass.toLineSeries(rectangles);
        break;
      case 2:
        figures = SquareClass.toLineSeries(squares);
        break;
      case 3:
        figures = TriangleClass.toLineSeries(rectTriangle);
        break;
      case 4:
        figures = TriangleClass.toLineSeries(acute);
        break;
      default:
        figures = [
          ...RectangleClass.toLineSeries(rectangles),
          ...SquareClass.toLineSeries(squares),
          ...TriangleClass.toLineSeries(rectTriangle),
          ...TriangleClass.toLineSeries(acute),
        ];
    }

    if (size.width > size.height)
      return CartesianChartH(
        appState: appState,
        setIndexFigures1: setIndexFigures1,
        setIndexFigures2: setIndexFigures2,
        setIndexFigures3: setIndexFigures3,
        setIndexFigures4: setIndexFigures4,

        figures: figures,
        rectangles: rectangles,
        squares: squares,
        rectTriangle: rectTriangle,
        acute: acute,
      );

    return CartesianChartV(
      appState: appState,
      setIndexFigures1: setIndexFigures1,
      setIndexFigures2: setIndexFigures2,
      setIndexFigures3: setIndexFigures3,
      setIndexFigures4: setIndexFigures4,

      figures: figures,
      rectangles: rectangles,
      squares: squares,
      rectTriangle: rectTriangle,
      acute: acute,
    );
  }
}

class CartesianChartV extends StatelessWidget {
  const CartesianChartV({
    super.key,

    required this.appState,
    required this.setIndexFigures1,
    required this.setIndexFigures2,
    required this.setIndexFigures3,
    required this.setIndexFigures4,

    required this.figures,
    required this.rectangles,
    required this.squares,
    required this.rectTriangle,
    required this.acute,
  });

  final MyAppState appState;
  final void Function() setIndexFigures1;
  final void Function() setIndexFigures2;
  final void Function() setIndexFigures3;
  final void Function() setIndexFigures4;

  final List<LineSeries<PointClass, double>> figures;
  final List<RectangleClass> rectangles;
  final List<SquareClass> squares;
  final List<TriangleClass> rectTriangle;
  final List<TriangleClass> acute;

  @override
  Widget build(BuildContext context) =>
    LayoutBuilder(builder: (context, constraints) =>
      Scaffold(
        appBar: AppBar(
          title: const Text('Plano Cartesiano'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional,),
                  primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional,),
                  legend: Legend(isVisible: true),
                  series: <CartesianSeries>[
                    ScatterSeries<PointClass, double>(
                      dataSource: appState.data[appState.currentLabel] ?? [],
                      xValueMapper: (PointClass point, _) => point.x,
                      yValueMapper: (PointClass point, _) => point.y,
                      name: 'Puntos',
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                    ...figures,
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(rectangles.length.toString()),
                      trailing: Icon(Icons.rectangle),
                      onTap: setIndexFigures1,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(squares.length.toString()),
                      trailing: Icon(Icons.square),
                      onTap: setIndexFigures2,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(rectTriangle.length.toString()),
                      trailing: Icon(Icons.network_cell),
                      onTap: setIndexFigures3,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(acute.length.toString()),
                      trailing: Icon(Icons.play_arrow),
                      onTap: setIndexFigures4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
}

class CartesianChartH extends StatelessWidget {
  const CartesianChartH({
    super.key,

    required this.appState,
    required this.setIndexFigures1,
    required this.setIndexFigures2,
    required this.setIndexFigures3,
    required this.setIndexFigures4,

    required this.figures,
    required this.rectangles,
    required this.squares,
    required this.rectTriangle,
    required this.acute,
  });

  final MyAppState appState;
  final void Function() setIndexFigures1;
  final void Function() setIndexFigures2;
  final void Function() setIndexFigures3;
  final void Function() setIndexFigures4;

  final List<LineSeries<PointClass, double>> figures;
  final List<RectangleClass> rectangles;
  final List<SquareClass> squares;
  final List<TriangleClass> rectTriangle;
  final List<TriangleClass> acute;

  @override
  Widget build(BuildContext context) =>
    LayoutBuilder(builder: (context, constraints) =>
      Scaffold(
        appBar: AppBar(
          title: const Text('Plano Cartesiano'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional,),
                primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional,),
                legend: Legend(
                  isVisible: true,
                ),
                series: <CartesianSeries>[
                  ScatterSeries<PointClass, double>(
                    dataSource: appState.data[appState.currentLabel] ?? [],
                    xValueMapper: (PointClass point, _) => point.x,
                    yValueMapper: (PointClass point, _) => point.y,
                    name: 'Puntos',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                  ...figures,
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.2,
                  child: ListTile(
                    title: Text(rectangles.length.toString()),
                    trailing: Icon(Icons.rectangle),
                    onTap: setIndexFigures1,
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.2,
                  child: ListTile(
                    title: Text(squares.length.toString()),
                    trailing: Icon(Icons.square),
                    onTap: setIndexFigures2,
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.2,
                  child: ListTile(
                    title: Text(rectTriangle.length.toString()),
                    trailing: Icon(Icons.network_cell),
                    onTap: setIndexFigures3,
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.2,
                  child: ListTile(
                    title: Text(acute.length.toString()),
                    trailing: Icon(Icons.play_arrow),
                    onTap: setIndexFigures4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
}