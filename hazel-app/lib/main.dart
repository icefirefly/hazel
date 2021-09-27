import 'package:flutter/material.dart';
import 'package:hazel/screens/landing_page.dart';
import 'package:hazel/utils/consts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: HAZEL_MATERIAL_COLOR,
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: HAZEL_MATERIAL_COLOR,
                brightness: Brightness.light)),
        home: LandingPage());
  }
}
