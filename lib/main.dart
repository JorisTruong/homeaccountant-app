import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'homepage.dart';
import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/redux/reducers/app_reducer.dart';


void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(dateRange: "ALL")
  );

  print('Initial state: ${store.state}');

  runApp(StoreProvider(store: store, child: MyApp()));
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
