part of 'main.dart';

class PointClass {
  final double x;
  final double y;
  final String label;

  const PointClass(this.x, this.y, {this.label = ''});

  @override
  String toString() => '($x, $y)';
}