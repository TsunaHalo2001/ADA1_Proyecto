Joan Esteban Villamil Largo - 2380466

# Informe de funcionamiento del Proyecto Final de Analisis y Diseño de Algoritmos
## 1. Tener varias listas con un conjunto de puntos a proyectar en un plano cartesiano

a. (1, 1) (2, 2) (1, 2) (2, 1)

b. (1, 1) (1, 5) (5, 1) (1, -2) (5, -2)

c. (1, 1) (2, 2) (3, 3) (4, 4) (5, 5)

d. (1, 1) (3, 1) (2, 3) (4, 3) (4, 1)

## 2. Determinar si con los puntos presentes en las listas se pueden formar Rectangulos, Cuadrados, Triangulo Acutangulo, Triangulo Rectangulo y 3. De las figuras indicadas, cuantas se pueden formar por cada una

Para determinar si los puntos pueden formar las figuras geométricas mencionadas, se diseñaron las funciones:

```dart
static Future<List<RectangleClass>> formRectangles(List<PointClass> points) async

static Future<List<SquareClass>> formSquares(List<PointClass> points) async

static Future<List<TriangleClass>> formAcuteTriangles(List<PointClass> points) async

static Future<List<TriangleClass>> formRectangleAngles(List<PointClass> points) async
```

Son funciones asincronas que reciben una lista de puntos como un tipo:

```dart
class PointClass {
  final double x;
  final double y;
  final String label;
}
```

Y retornan una lista de figuras, cada figura es del tipo:

### Rectángulo
```dart
class RectangleClass {
  final PointClass topLeft;
  final PointClass bottomRight;
  final PointClass topRight;
  final PointClass bottomLeft;

  double get area => _calculateArea();
}
```

La función `_calculateArea` esta definida como:

```dart
double _calculateArea() =>
  (bottomRight.x - bottomLeft.x).abs() * (topLeft.y - bottomLeft.y).abs();
```

### Cuadrado
```dart
class SquareClass extends RectangleClass
```

Al heredar de `RectangleClass`, posee las mismas propiedades

### Triángulo Acutángulo y Triángulo Rectángulo

Al pertenecer a la misma familia de figuras, se definieron como:

```dart
class TriangleClass {
  final PointClass pointA;
  final PointClass pointB;
  final PointClass pointC;

  int get angleA => _calculateAngle(pointB, pointC, pointA);
  int get angleB => _calculateAngle(pointA, pointC, pointB);
  int get angleC => _calculateAngle(pointA, pointB, pointC);
  double get area => _calculateArea();

  bool get isAcute => angleA < 90 && angleB < 90 && angleC < 90;
  bool get isRight => angleA == 90 || angleB == 90 || angleC == 90;
}
```

La función `_calculateAngle` esta definida como:

```dart
int _calculateAngle(PointClass p1, PointClass p2, PointClass p3) {
  final a = _distance(p2, p3);
  final b = _distance(p1, p3);
  final c = _distance(p1, p2);
  if ((a * a + b * b - c * c) / (2 * a * b) > 1 ||
      (a * a + b * b - c * c) / (2 * a * b) < -1) {
    return 0; // Invalid triangle, return 0 degrees
  }
  return ((180 / pi) * acos((a * a + b * b - c * c) / (2 * a * b))).round();
}
```

Esta función calcula el ángulo entre tres puntos utilizando la ley de cosenos.

La función `_distance` calcula la distancia entre dos puntos:

```dart
double _distance(PointClass p1, PointClass p2) =>
  sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
```

Esta función utiliza el teorema de Pitágoras para calcular la distancia entre dos puntos en un plano cartesiano.

La función `_calculateArea` para el triángulo se define como:

```dart
double _calculateArea() {
  final a = _distance(pointB, pointC);
  final b = _distance(pointA, pointC);
  final c = _distance(pointA, pointB);
  final s = (a + b + c) / 2;
  return sqrt(s * (s - a) * (s - b) * (s - c));
}
```

Esta función utiliza la fórmula de Herón para calcular el área del triángulo.

---

La implementacion de `formRectangles`, `formSquares`, `formAcuteTriangles` y `formRectangleAngles` Requiere el uso de las funciones `map` y `where` de Dart para filtrar y transformar, debido a la prohibicion de usar este tipo de funciones, se opto por una imprementacion recursiva en la clase `RecursionClass`:

### `RecursionClass`

#### `recursiveWhere`
```dart
static List<T> recursiveWhere<T>(
    List<T> list,
    bool Function(T) test,
    [int index = 0,]
  ) {
  List<T> result = [];

  void helper(int index) {
    if (index >= list.length) return;
    if (test(list[index])) result.add(list[index]);
    helper(index + 1);
  }

  helper(0); 
  return result;
}
```

La función `recursiveWhere` toma una lista y una función de prueba, y devuelve una nueva lista que contiene solo los elementos que cumplen con la prueba. Utiliza una función auxiliar `helper` para recorrer la lista de manera recursiva.

##### Pseudocódigo

El pseudocódigo de la función `recursiveWhere` es el siguiente:

```Dart
recursiveWhere (lista, test) {      // Peor caso | Mejor caso
  resultado = []                    // 1

  helper(indice) {
    Si (indice >= lista.length)     // 1 + n
      retorna                       // 1
    Si (test(lista[indice]))        // n
      resultado.add(lista[indice])  // n         | 0
    helper(indice + 1)              
  }

  helper(0)                         // 2 + 3n    | 2 + 2n
  retorna resultado                 // 1
}                                   // 4 + 3n    | 4 + 2n
```

##### Costo computacional

El costo de ejecutar la función `recursiveWhere` es $O(n)$ en el peor caso, donde $n$ es el número de elementos en la lista. Esto se debe a que la función recorre cada elemento de la lista una vez.

$recursiveWhere.cost = 4 + 3n$ en el peor caso.

$recursiveWhere.cost = 4 + 2n$ en el mejor caso.

##### Prueba de escritorio

Para probar la función `recursiveWhere`, escojemos $lista = [1, 2, 3, 4, 5]$ y $test = (x) \rightarrow x.mod(2) == 0$.

| $lista$ | $test$ | $resultado$ | $indice$ | $indice >= lista.length$ |
| - | - | - | - | - |
| $[1, 2, 3, 4, 5]$ | $(1) \rightarrow 1.mod(2) == 0$ | $[]$ | $0$ | $0 >= 5$ |
| | $(2) \rightarrow 2.mod(2) == 0$ | $[2]$ | $1$ | $1 >= 5$ |
| | $(3) \rightarrow 3.mod(2) == 0$ | $[2]$ | $2$ | $2 >= 5$ |
| | $(4) \rightarrow 4.mod(2) == 0$ | $[2, 4]$ | $3$ | $3 >= 5$ |
| | $(5) \rightarrow 5.mod(2) == 0$ | $[2, 4]$ | $4$ | $4 >= 5$ |
| | | $[2, 4]$ | $5$ | $5 >= 5$ |

#### `recursiveMap`
```dart
static List<T> recursiveMap<T, K>(
    List<K> res,
    T Function(K) builder, [int index = 0,]
  ) {
  List<T> result = [];
  void helper(int index) {
    if (index >= res.length) return;
    result.add(builder(res[index]));
    helper(index + 1);
  }

  helper(0);
  return result;
}
```

La función `recursiveMap` toma una lista y una función de construcción, y devuelve una nueva lista que contiene los elementos transformados por la función de construcción. Utiliza una función auxiliar `helper` para recorrer la lista de manera recursiva.

##### Pseudocódigo

El pseudocódigo de la función `recursiveMap` es el siguiente:

```Dart
recursiveMap (lista, builder) {           
  resultado = []                          // 1

  helper(indice) {
    Si (indice >= lista.length)           // 1 + n
      retorna                             // 1
    resultado.add(builder(lista[indice])) // n
    helper(indice + 1)                
  }

  helper(0)                               // 2 + 2n
  retorna resultado                       // 1
}                                         // 4 + 2n
```

##### Costo computacional

El costo de ejecutar la función `recursiveMap` es $O(n)$, donde $n$ es el número de elementos en la lista. Esto se debe a que la función recorre cada elemento de la lista una vez y aplica la función de construcción a cada uno.

$recursiveMap.cost = 4 + 2n$

Aunque el costo de `helper` es $O(n)$, todo depende de la función `builder` que se le pase, ya que esta puede ser una función costosa o no.

##### Prueba de escritorio

Para probar la función `recursiveMap`, escojemos $lista = [1, 2, 3, 4, 5]$ y $builder = (x) \rightarrow x * 2$.

| $lista$ | $builder$ | $resultado$ | $indice$ | $indice >= lista.length$ |
| - | - | - | - | - |
| $[1, 2, 3, 4, 5]$ |$(1) \rightarrow 1 * 2$ | $[2]$ | $0$ | $0 >= 5$ |
| |$(2) \rightarrow 2 * 2$ | $[2, 4]$ | $1$ | $1 >= 5$ |
| |$(3) \rightarrow 3 * 2$ | $[2, 4, 6]$ | $2$ | $2 >= 5$ |
| |$(4) \rightarrow 4 * 2$ | $[2, 4, 6, 8]$ | $3$ | $3 >= 5$ |
| |$(5) \rightarrow 5 * 2$ | $[2, 4, 6, 8, 10]$ | $4$ | $4 >= 5$ |
| | | $[2, 4, 6, 8, 10]$ | $5$ | $5 >= 5$ |

### `generatePartialPermutations`

```dart
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
```

La función `generatePartialPermutations` genera todas las permutaciones parciales de los puntos dados, formando rectángulos con cuatro puntos. Utiliza una función recursiva `permute` para construir las permutaciones.

##### Pseudocódigo

```Dart
generatePartialPermutations (params) {
  partialStart = params['partialStart']            // 1
  remainingElements = params['remainingElements']  // 1

  globalSet = Set.from(partialStart)               // n
  globalSet.addAll(remainingElements)              // m

  result = []                                      // 1

  permute(current, used) {                         // n + m = z
    Si (current.length == 4) {                     // 2 * z! + n - 1
      result.add(RectangleClass(...))              // 1         
      retorna                                      // 1         
    }

    Para (item en globalSet.difference(used)) {    // 7 * z! + n - 6
      current.add(item)                            // 2 * z! + n - 2
      used.add(item)                               // 2 * z! + n - 2
      permute(current, used)                       
      current.removeLast()                         // 2 * z! + n - 2
      used.remove(item)                            // 2 * z! + n - 2
    }
  }

  permute([], {})                                 // 17 * (n + m)! + 6 * (n + m) - 15

  retorna result                                  // 1
}                                                 // 17 * (n + m)! + 6 * (n + m) + n + m - 11
```

##### Costo computacional

El costo de ejecutar la función `generatePartialPermutations` es $O((n + m)!)$, donde $n$ es el número de elementos en `partialStart` y $m$ es el número de elementos en `remainingElements`. Esto se debe a que la función genera todas las permutaciones posibles de los puntos dados.

$generatePartialPermutations.cost = 17 * (n + m)! + 6 * (n + m) + n + m - 11$

##### Prueba de escritorio

Para probar la función `generatePartialPermutations`, escojemos $partialStart = [A]$ y $remainingElements = [B]$.

| $partialStart$ | $remainingElements$ | $globalSet$ | $current$ | $used$ | $result$ | $current.length == 4$ | $globalSet.difference(used)$ |
| - | - | - | - | - | - | - | - |
| $[A]$ | $[B]$ | $(A, B)$ | $[]$ | $()$ | $[]$ | $0 == 4$ | $(A, B)$ |
| | | | $[A]$ | $(A)$ | $[]$ | $1 == 4$ | $(B)$ |
| | | | $[A, B]$ | $(A, B)$ | $[]$ | $2 == 4$ | $()$ |
| | | | $[A]$ | $(A)$ | $[]$ | | |
| | | | $[]$ | $()$ | $[]$ | | |
| | | | $[B]$ | $(B)$ | $[]$ | $1 == 4$ | $(A)$ |
| | | | $[B, A]$ | $(A, B)$ | $[]$ | $2 == 4$ | $()$ |
| | | | $[B]$ | $(B)$ | $[]$ | | |
| | | | $[]$ | $()$ | $[]$ | | |

### `formRectangles`

```dart
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
```

La función `formRectangles` divide la lista de puntos en partes iguales según el número de procesadores disponibles. Luego, utiliza la función `generatePartialPermutations` para generar todas las permutaciones parciales de los puntos y filtra los resultados para obtener solo los rectángulos válidos.

##### Pseudocódigo

```Dart
formRectangles (points) {
  numWorkers = _hilos                                                     // 1
  chunkSize = (points.length / numWorkers).ceil()                         // 1

  chunks = []                                                             // 1

  Para (i = 0; i < points.length; i += chunkSize) {                       // 1 + n / _hilos
    end = i + chunkSize                                                   // n / _hilos
    Si (end > points.length)                                              // n / _hilos
      end = points.length                                                 // 1
    chunks.add(points.sublist(i, end))                                    // n / _hilos
  }

  futures = []                                                            // 1

  Para (i = 0; i < chunks.length; i++) {                                  // 1 + n / _hilos
    partialInput = chunks[i]                                              // n / _hilos
    otherElements = recursiveWhere(
      points, (p) => !partialInput.contains(p)).toList()                  // 4n + 3n^2 / _hilos

    futures.add(compute(generatePartialPermutations, {
      'partialStart': partialInput,
      'remainingElements': otherElements,
    }))                                                                   // 17 * (n / _hilos)! + 7 * (n / _hilos) - 11
  }

  results = futures                                                       // 1

  retorna recursiveWhere(             
    results.expand((rects) => rects).toList(),      
    (rect) => rect.topLeft.x == rect.bottomLeft.x &&                      // _2
      rect.topLeft.y == rect.topRight.y &&                                // _2
      rect.topRight.x == rect.bottomRight.x &&                            // _2
      rect.bottomLeft.y == rect.bottomRight.y &&                          // _2
      rect.bottomLeft.x < rect.bottomRight.x &&                           // _2
      rect.topLeft.x < rect.topRight.x &&                                 // _2
      rect.bottomLeft.y < rect.topLeft.y &&                               // _2
      rect.bottomRight.y < rect.topRight.y &&                             // _2
      rect.topLeft != rect.topRight &&                                    // _2
      rect.topLeft != rect.bottomLeft &&                                  // _2
      rect.topLeft != rect.bottomRight &&                                 // _2
      rect.topRight != rect.bottomRight &&                                // _2
      rect.topRight != rect.bottomLeft &&                                 // _2
      rect.bottomLeft != rect.bottomRight);                               // 4 + 28n
}                                                                         // 17 * (n / _hilos)! + 3n^2 / _hilos + 32n + 11 * (n / _hilos) + 1
```

##### Costo computacional

El costo de ejecutar la función `formRectangles` es $O((2n - n / _hilos)!)$, donde $n$ es el número de puntos y `_hilos` es el número de procesadores disponibles. Esto se debe a que la función genera todas las permutaciones parciales de los puntos dados.

$formRectangles.cost = 17 * (n / hilos)! + 3n^2 / hilos + 32n + 11 * (n / hilos) + 1$

##### Prueba de escritorio

Para probar la función `formRectangles`, escojemos $points = [(1, 1), (2, 2), (1, 2), (2, 1)]$.

| $points$ | $numWorkers$ | $chunkSize$ | $chunks$ | $partialInput$ | $otherElements$ | $futures$ | $results$ | $i$ | $i < chunks.length$ |
| - | - | - | - | - | - | - | - | - | - |
| $[(1, 1), (2, 2), (1, 2), (2, 1)]$ | $4$ | $[...]$$1$ | $[[(1, 1)], [(2, 2)], [(1, 2)], [(2, 1)]]$ | $[(1, 1)]$ | $[(2, 2), (1, 2), (2, 1)]$ | $[]$ | | $0$ | $0 < 4$ |
| | | | | $[(2, 2)]$ | $[(1, 1), (1, 2), (2, 1)]$ | | | $1$ | $1 < 4$ |
| | | | | $[(1, 2)]$ | $[(1, 1), (2, 2), (2, 1)]$ | | | $2$ | $2 < 4$ |
| | | | | $[(2, 1)]$ | $[(1, 1), (2, 2), (1, 2)]$ | | | $3$ | $3 < 4$ |
| | | | | | | $[...]$ | | $4$ | $4 < 4$ |
| | | | | | | | $[...]$ | | |

##### Version sin paralelizacion

```dart
static List<RectangleClass> formRectangles(List<PointClass> points) {
  final List<List<RectangleClass>> results = [];

  final partialInput = points;
  final otherElements = [];

  results.add(generatePartialPermutations( <String, dynamic> {
    'partialStart': partialInput,
    'remainingElements': otherElements,
  }));

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
```

La versión sin paralelización no divide la lista de puntos en partes iguales y no utiliza múltiples hilos para generar las permutaciones parciales. En su lugar, genera las permutaciones directamente a partir de todos los puntos disponibles.

##### Pseudocódigo

```Dart
formRectangles (points) {
  results = []                                                            // 1

  partialInput = points                                                   // 1
  otherElements = []                                                      // 1

  results.add(compute(generatePartialPermutations, {
    'partialStart': partialInput,
    'remainingElements': otherElements,
  }))                                                                   // 17 * n! + 7n - 11

  retorna recursiveWhere(             
    results.expand((rects) => rects).toList(),      
    (rect) => rect.topLeft.x == rect.bottomLeft.x &&                      // _2
      rect.topLeft.y == rect.topRight.y &&                                // _2
      rect.topRight.x == rect.bottomRight.x &&                            // _2
      rect.bottomLeft.y == rect.bottomRight.y &&                          // _2
      rect.bottomLeft.x < rect.bottomRight.x &&                           // _2
      rect.topLeft.x < rect.topRight.x &&                                 // _2
      rect.bottomLeft.y < rect.topLeft.y &&                               // _2
      rect.bottomRight.y < rect.topRight.y &&                             // _2
      rect.topLeft != rect.topRight &&                                    // _2
      rect.topLeft != rect.bottomLeft &&                                  // _2
      rect.topLeft != rect.bottomRight &&                                 // _2
      rect.topRight != rect.bottomRight &&                                // _2
      rect.topRight != rect.bottomLeft &&                                 // _2
      rect.bottomLeft != rect.bottomRight);                               // 4 + 28n
}                                                                         // 17 * n! + 35n - 4 
```

##### Costo computacional

$formRectanglesNoPar.cost = 17 * n! + 35n - 4$

Como se puede observar, el costo computacional de la versión sin paralelización es significativamente mayor que la versión con paralelización, especialmente para listas grandes de puntos. Esto se debe a que la versión sin paralelización no aprovecha los recursos del sistema para dividir el trabajo entre múltiples hilos.

Puede verse como $O(n!)$ es mayor a $O(n! / hilos)$.

### `formSquares`

```dart
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
```

La función `formSquares` utiliza la función `formRectangles` para obtener todos los rectángulos y luego filtra aquellos que cumplen con la condición de ser cuadrados. Utiliza `recursiveMap` para transformar los rectángulos en cuadrados.

##### Pseudocódigo

```Dart
formSquares (points) {
  retorna formRectangles(points).then((rects) =>           // 17 * (n / _hilos)! + 3n^2 / _hilos + 32n + 11 * (n / _hilos) + 1
    recursiveMap(
      recursiveWhere(
        rects, (rect) => 
          rect.topRight.x - rect.topLeft.x == 
          rect.topRight.y - rect.bottomRight.y).toList(), // 4 + 4n
      (rect) => SquareClass(
        topLeft: rect.topLeft, 
        bottomRight: rect.bottomRight, 
        topRight: rect.topRight, 
        bottomLeft: rect.bottomLeft,                      // 4 + 2n
      )
    )
  )
}                                                         // 17 * (n / _hilos)! + 3n^2 / _hilos + 38n + 9
```

##### Costo computacional

$formSquares.cost = 17 * (n / _hilos)! + 3n^2 / _hilos + 38n + 9$

Debido a que la funcion `formSquares` filtra los resultados de `formRectangles` omitimos la prueba de escritorio.

Se hará lo mismo con las funciones `formAcuteTriangles` y `formRectangleAngles` para evitar redundancia.

### `recursiveMergeSort`

```dart
static List<T> recursiveMergeSort<T> (
    List<T> list,
    int Function(T, T) compare, [
      int start = 0,
      int end = -1,
    ]) {
  if (end == -1) end = list.length - 1;

  if (list.isEmpty) return [];

  if (start >= end) return [list[start]];

  int mid = (start + end) ~/ 2;

  List<T> left = recursiveMergeSort(list, compare, start, mid);

  List<T> right = recursiveMergeSort(list, compare, mid + 1, end);

  List<T> merged = [];

  int i = 0, j = 0;

  while (i < left.length && j < right.length) {
    if (compare(left[i], right[j]) <= 0) {
      merged.add(left[i]);
      i++;
    } else {
      merged.add(right[j]);
      j++;
    }
  }

  while (i < left.length) {
    merged.add(left[i]);
    i++;
  }

  while (j < right.length) {
    merged.add(right[j]);
    j++;
  }

  return merged;
}
```

La función `recursiveMergeSort` implementa el algoritmo de ordenamiento por mezcla (merge sort) de manera recursiva. Toma una lista y una función de comparación, y devuelve una nueva lista ordenada usando divide y vencerás.

##### Pseudocódigo

```Dart
recursiveMergeSort (list, compare, start = 0, end = -1) {
  Si (end == -1)                                            // 2n + 1
    end = list.length - 1                                   // 1

  Si (list.isEmpty)                                         // 2n + 1         | 2n + 1
    retorna []                                              // n              | n

  Si (start >= end)                                         // 2n             | 2n + 1
    retorna [list[start]]                                   // 0              | n

  mid = (start + end) ~/ 2                                  // 2n

  left = recursiveMergeSort(list, compare, start, mid)      // 2n

  right = recursiveMergeSort(list, compare, mid + 1, end)   // 2n

  merged = []                                               // 2n

  i = j = 0                                                 // 4n + 2

  Mientras (i < left.length && j < right.length) {          // 1 + n * lg(n)
    Si (compare(left[i], right[j]) <= 0) {                  // n * lg(n)
      merged.add(left[i])                                   // n * lg(n)
      i++                                                   // n * lg(n)
    } Sino {
      merged.add(right[j])                                  // 0              | n * lg(n)
      j++                                                   // 0              | n * lg(n)
    }
  }

  Mientras (i < left.length) {                              // 1 + n * lg(n)
    merged.add(left[i])                                     // n * lg(n)
    i++                                                     // n * lg(n)
  }

  Mientras (j < right.length) {                             // 0              | 1 + n * lg(n)
    merged.add(right[j])                                    // 0              | n * lg(n)
    j++                                                     // 0              | n * lg(n)
  }

  retorna merged                                            // 1
}                                         // 7 * n * lg(n) + 19n + 8
```

##### Costo computacional

$recursiveMergeSort.cost = 7 * n * lg(n) + 19n + 8$

El costo de ejecutar la función `recursiveMergeSort` es $O(n * lg(n))$, donde $n$ es el número de elementos en la lista. Esto se debe a que el algoritmo divide la lista en mitades y luego combina los resultados, lo que da como resultado un tiempo de ejecución logarítmico.

##### Prueba de escritorio

Para probar la función `recursiveMergeSort`, escojemos $list = [5, 3, 8]$ y $compare = (a, b) \rightarrow a < b$.

| $list$ | $compare$ | $start$ | $end$ | $mid$ | $left$ | $right$ | $merged$ | $i$ | $j$ |
| - | - | - | - | - | - | - | - | - | - |
| $[5, 3, 8]$ | $(a, b) \rightarrow a < b$ | $0$ | $-1$ | $1$ | $[5]$ | $[3, 8]$ | $[]$ | $0$ | $0$ |
| | $(3, 8) \rightarrow 3 < 8$ | | | | | | $[3]$ | $0$ | $1$ |
| | | | | | | $[3, 8]$ | | $1$ | $0$ |
| | | | | | $[5]$ | $[3, 8]$ | | $0$ | $0$ |
| | | | | | | | $[3]$ | $1$ | $0$ |
| | | | | | | | $[3, 5]$ | | $1$ |
| | | | | | | | $[3, 5, 8]$ | | $2$ |

### `removeDuplicatesByPoints`

```dart
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
```

La función `removeDuplicatesByPoints` elimina los triángulos duplicados de una lista, considerando que dos triángulos son iguales si tienen los mismos puntos, independientemente del orden. Utiliza un conjunto para rastrear los triángulos únicos y una lista para almacenar los resultados.

##### Pseudocódigo

```Dart
removeDuplicatesByPoints (triangles) {
  seen = ()                                                         // 1
  uniqueTriangles = []                                              // 1

  Para (triangle en triangles) {                                    // n
    pointsNS = [triangle.pointA, triangle.pointB, triangle.pointC]  // n
    points = recursiveMergeSort(                                   
      pointsNS, (a, b) => a.x.compareTo(b.x) == 0 ?                
        a.y.compareTo(b.y) : a.x.compareTo(b.x))                    // 9 * n * lg(n) + 19n + 8

    key = '${points[0].x},${points[0].y},'                           
          '${points[2].x},${points[2].y}'                           // n

    Si (!seen.contains(key)) {                                      // n
      seen.add(key)                                                 // n
      uniqueTriangles.add(triangle)                                 // n
    }
  }

  retorna uniqueTriangles                                          // 1
}                                                                  // 9 * n * lg(n) + 25n + 11
```

##### Costo computacional

$removeDuplicatesByPoints.cost = 9 * n * lg(n) + 25n + 11$

El costo de ejecutar la función `removeDuplicatesByPoints` es $O(n * lg(n))$, donde $n$ es el número de triángulos en la lista. Esto se debe a que la función ordena los puntos de cada triángulo y utiliza un conjunto para rastrear los triángulos únicos, lo que da como resultado un tiempo de ejecución logarítmico.

Debido a que la implementacion de `removeDuplicatesByPoints` utiliza `recursiveMergeSort` y la complejidad propia por fuera del algoritmo de ordenamiento es lineal, omitimos la prueba de escritorio para evitar redundancia.

### `formAcuteTriangles`

```dart
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
```

La función `formTriangles` genera todos los triángulos posibles a partir de un conjunto de puntos. Divide la lista de puntos en partes iguales según el número de procesadores disponibles y utiliza la función `generatePartialPermutations` para generar todas las permutaciones parciales de los puntos. Luego, elimina los triángulos duplicados utilizando la función `removeDuplicatesByPoints`.

A diferencia de la funcion `formRectangles`, el filtro de salida posee una complejidad $O(n * lg (n))$ a diferencia de $O(n)$ del `recursiveWhere`, de resto la funcion es similar a `formRectangles`.

Por lo tanto, el pseudocódigo y el costo computacional son los mismos que los de `formRectangles`, con la diferencia de que se utiliza `removeDuplicatesByPoints` al final. asi que se omite el pseudocodigo y prueba de escritorio para evitar redundancia.

##### Costo computacional

$formAcuteTriangles.cost = 17 * (n / hilos)! + 9 * n * lg(n) + 3n^2 / hilos + 29n + 11 * (n / hilos) + 8$

### `formRectangleAngles` y `formAcuteTriangles`

```dart
bool get isAcute => angleA < 90 && angleB < 90 && angleC < 90;
bool get isRight => angleA == 90 || angleB == 90 || angleC == 90;

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
```

Las funciones `formRectangleAngles` y `formAcuteTriangles` utilizan la función `formTriangles` para obtener todos los triángulos y luego filtran aquellos que cumplen con las condiciones de ser ángulos rectos o agudos, respectivamente. Utilizan `recursiveWhere` para filtrar los triángulos.

La funcion utiliza `isAcute` e `isRight` para determinar si un triángulo es agudo o recto, respectivamente. Estas propiedades se basan en los ángulos de los triángulos.

Debido a la similitud con `formSquares`, se omite el pseudocódigo y la prueba de escritorio para evitar redundancia.

##### Costo computacional

$formRectangleAngles.cost = 17 * (n / hilos)! + 9 * n * lg(n) + 3n^2 / hilos + 34n + 11 * (n / hilos) + 12$

$formAcuteTriangles.cost = 17 * (n / hilos)! + 9 * n * lg(n) + 3n^2 / hilos + 34n + 11 * (n / hilos) + 12$

Debido a que la funcion filtro contiene el mismo numero de instrucciones el costo de ambas es igual.

## 4. Dibujar un plano cartesiano que permita visualizar los puntos

```dart
SfCartesianChart(
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
    ...,
  ],
),
```

La función `SfCartesianChart` de la biblioteca `syncfusion_flutter_charts` se utiliza para dibujar un plano cartesiano que permite visualizar los puntos. Se configura el eje X y el eje Y con un rango adicional para mejorar la visualización. Luego, se agrega una serie de puntos utilizando `ScatterSeries`, donde se mapean las coordenadas X e Y de cada punto.

## 5. Dibujar cada una de las figuras

```dart
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
```

La función `toLineSeries` convierte una lista de rectángulos en una lista de series de líneas (`LineSeries`) para ser utilizadas en el gráfico. Cada rectángulo se representa como una serie de líneas que conecta sus cuatro puntos y cierra el rectángulo. Además, se muestra el área del rectángulo y las coordenadas de sus puntos en la etiqueta de datos.

Debido a que la funcion utiliza la combinacion de 3 funciones ya vistas, se omite el pseudocódigo y la prueba de escritorio para evitar redundancia.

El costo computacional es aditivo con la funcion que se pasa como argumento asi que sigue siendo $O(n)$.

## 6. Determinar el área de cada figura y ordenarla de menor a mayor

```dart
final List<RectangleClass> rectangles = RecursionClass.recursiveMergeSort(
  nRectangles,
  (a, b) => a.area.compareTo(b.area),
);
```

La función `recursiveMergeSort` se utiliza para ordenar una lista de rectángulos por su área de menor a mayor. Se pasa una función de comparación que compara las áreas de los rectángulos.

Las demas figuras se ordenan de la misma manera, utilizando la misma función `recursiveMergeSort` y pasando la misma comparacion.

Su complejidad es la misma que la de `recursiveMergeSort`, por lo que se omite el pseudocódigo y la prueba de escritorio para evitar redundancia.

## Informacion a tener en cuenta

Durante la sustentacion se presento un error de ejecucion en el codigo debido a la falta del condicional en la funcion $arccos(x)$ que al evaluar todos los puntos posibles de un triangulo, se generaban valores fuera del rango de $[-1, 1]$.

Contrario a lo hablado la paralelizacion no era el problema. Los hilos adicionales que se encontraban con esa excepcion eran los responsables de la falta de figuras.