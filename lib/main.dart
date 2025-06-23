import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

part 'pointclass.dart';
part 'rectangleclass.dart';
part 'squareclass.dart';
part 'triangleclass.dart';

part 'myapp.dart';
part 'myhomepage.dart';
part 'myappstate.dart';
part 'pointlists.dart';
part 'cartesianchart.dart';

void main() =>
  runApp(const MyApp());
