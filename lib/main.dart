import 'package:flutter/material.dart';
import 'package:in_a_year/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Reqwired when using await in main(), ensure it is fully initialized beforerunning the app and also plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Hive This sets up Hive for use in a Flutter application, Required Before Using Hive: Before opening a box, Hive must be initialized.
  // await acts as a pause
  await Hive.initFlutter();
  await Hive.openBox('profileBox'); // Open the box for storing profile data

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
