import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Accountant',
      theme: ThemeData(
        primaryColor: Colors.grey[850],
        accentColor: Colors.grey[900]
      ),
      home: MyHomePage(title: 'Home Accountant'),
    );
  }
}
