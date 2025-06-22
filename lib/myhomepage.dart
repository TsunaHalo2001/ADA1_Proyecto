part of 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var index = 0;

  void setIndex(int newIndex) => setState(() => index = newIndex);

  @override
  Widget build(BuildContext context) {
    Widget page;
    var appState = context.watch<MyAppState>();
    appState.loadData();
    Size size = MediaQuery.of(context).size;
    double minSize = size.width < size.height ? size.width : size.height;
    double maxSize = size.width > size.height ? size.width : size.height;

    switch (index) {
      case 0:
        page = PointLists();
        break;
      case 1:
        page = CartesianChart();
        break;
      default:
        throw UnimplementedError('State ${appState.state} is not implemented');
    }

    if (size.width > size.height) {
      return MyHomePageH(
        index: index,
        setIndex: setIndex,
        page: page,
        minSize: minSize,
        maxSize: maxSize,
      );
    }

    return MyHomePageV(
      index: index,
      setIndex: setIndex,
      page: page,
      minSize: minSize,
      maxSize: maxSize,
    );
  }
}

class MyHomePageH extends StatelessWidget {
  const MyHomePageH({
    super.key,

    required this.index,
    required this.setIndex,
    required this.page,
    required this.minSize,
    required this.maxSize,
  });

  final int index;
  final void Function(int) setIndex;
  final Widget page;
  final double minSize;
  final double maxSize;

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: minSize * 0.3,
            child: NavigationRail(
              selectedIndex: index,
              onDestinationSelected: setIndex,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.list),
                  label: Text('Puntos'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text('Gráfico'),
                ),
              ],
            ),
          ),
          SizedBox(
            width: maxSize * 0.7,
            child: page,
          ),
        ],
      ),
    );
}

class MyHomePageV extends StatelessWidget {
  const MyHomePageV({
    super.key,

    required this.index,
    required this.setIndex,
    required this.page,
    required this.minSize,
    required this.maxSize,
  });

  final int index;
  final void Function(int) setIndex;
  final Widget page;
  final double minSize;
  final double maxSize;

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: setIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: 'Puntos',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: 'Gráfico',
          ),
        ],
      ),
    );
}