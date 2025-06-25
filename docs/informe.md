# Informe de funcionamiento del Proyecto Final de Analisis y Diseño de Algoritmos
## 1. Tener varias listas con un conjunto de puntos a proyectar en un plano cartesiano

a. (1, 1) (2, 2) (1, 2) (2, 1)

b. (1, 1) (1, 5) (5, 1) (1, -2) (5, -2)

c. (1, 1) (2, 2) (3, 3) (4, 4) (5, 5)

d. (1, 1) (3, 1) (2, 3) (4, 3) (4, 1)

## 2. Determinar si con los puntos presentes en las listas se pueden formar Rectangulos, Cuadrados, Triangulo Acutangulo, Triangulo Rectangulo

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

### RecursionClass

#### RecursiveWhere
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

El costo de ejecutar la función `recursiveWhere` es $O(n)$ en el peor caso, donde $n$ es el número de elementos en la lista. Esto se debe a que la función recorre cada elemento de la lista una vez.

$recursiveWhere.cost = 4 + 3n$ en el peor caso.

$recursiveWhere.cost = 4 + 2n$ en el mejor caso.

#### RecursiveMap
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

El costo de ejecutar la función `recursiveMap` es $O(n)$, donde $n$ es el número de elementos en la lista. Esto se debe a que la función recorre cada elemento de la lista una vez y aplica la función de construcción a cada uno.

$recursiveMap.cost = 4 + 2n$

Aunque el costo de `helper` es $O(n)$, todo depende de la función `builder` que se le pase, ya que esta puede ser una función costosa o no.