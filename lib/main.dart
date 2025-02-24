import 'package:flutter/material.dart';
import 'package:machine_test/di/injectionContainer.dart' as di;
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

