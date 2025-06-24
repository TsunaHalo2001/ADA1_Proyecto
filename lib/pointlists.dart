part of 'main.dart';

class PointLists extends StatefulWidget {
  const PointLists({super.key});

  @override
  State<PointLists> createState() => _PointListsState();
}

class _PointListsState extends State<PointLists> {
  String currentLabel = '';
  var currentX = 0.0;
  var currentY = 0.0;

  final currentLabelController = TextEditingController();
  final currentXController = TextEditingController();
  final currentYController = TextEditingController();

  @override
  void dispose() {
    currentLabelController.dispose();
    currentXController.dispose();
    currentYController.dispose();
    super.dispose();
  }

  void setCurrentLabel(label) =>
    setState(() => currentLabel = label.toString());

  void setCurrentX(value) =>
    setState(() => currentX = double.tryParse(value.toString()) ?? 0.0);

  void setCurrentY(value) =>
    setState(() => currentY = double.tryParse(value.toString()) ?? 0.0);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    void addPuntos() {
      if (currentLabel.isNotEmpty) {
        appState.addPoint(PointClass(currentX, currentY, label: currentLabel));
        setState(() {
          currentLabel = '';
          currentX = 0.0;
          currentY = 0.0;
        });
        currentLabelController.clear();
        currentXController.clear();
        currentYController.clear();
      }
    }

    void setCurrentMap(value) =>
      setState(() => appState.setCurrentLabel(value.toString()));

    return LayoutBuilder(builder: (context, constraints) =>
      Scaffold(
        appBar: AppBar(
          title: const Text('Listas de Puntos'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: currentLabelController,
                    decoration: const InputDecoration(
                      labelText: 'Etiqueta',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: setCurrentLabel,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: currentXController,
                    decoration: const InputDecoration(
                      labelText: 'Valor en X',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: setCurrentX,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: currentYController,
                    decoration: const InputDecoration(
                      labelText: 'Valor en Y',
                      border: OutlineInputBorder(),
                    ),
                    onChanged:  setCurrentY,
                  ),
                ),
                FloatingActionButton(
                  onPressed: addPuntos,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: RecursionClass.recursiveMapWidget(
                  appState.data.entries.toList(), (entry) =>
                    ListTile(
                      title: Text(entry.key + appState.data[entry.key].toString()),
                      leading: Radio<String>(
                        value: entry.key,
                        groupValue: appState.currentLabel,
                        onChanged: setCurrentMap,
                      ),
                    ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}