part of 'main.dart';

class CartesianChart extends StatefulWidget {
  const CartesianChart({super.key});

  @override
  State<CartesianChart> createState() => _CartesianChartState();
}

class _CartesianChartState extends State<CartesianChart> {
  var indexFigures = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

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

    return LayoutBuilder(builder: (context, constraints) =>
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
                      onTap: () {
                        setState(() {
                          indexFigures = 1;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(squares.length.toString()),
                      trailing: Icon(Icons.square),
                      onTap: () {
                        setState(() {
                          indexFigures = 2;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(rectTriangle.length.toString()),
                      trailing: Icon(Icons.network_cell),
                      onTap: () {
                        setState(() {
                          indexFigures = 3;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(acute.length.toString()),
                      trailing: Icon(Icons.play_arrow),
                      onTap: () {
                        setState(() {
                          indexFigures = 4;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}