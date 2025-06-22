part of 'main.dart';

class CartesianChart extends StatelessWidget {
  const CartesianChart({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return LayoutBuilder(builder: (context, constraints) =>
      Scaffold(
        appBar: AppBar(
          title: const Text('Plano Cartesiano'),
        ),
        body: Center(
          child: Container(
            child: SfCartesianChart(
              primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional,),
              primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional,),
              series: [
                ScatterSeries<PointClass, double>(
                  dataSource: appState.data[appState.currentLabel] ?? [],
                  xValueMapper: (PointClass point, _) => point.x,
                  yValueMapper: (PointClass point, _) => point.y,
                  name: 'Puntos',
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}