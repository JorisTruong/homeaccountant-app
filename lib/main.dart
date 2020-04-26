import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'homepage.dart';
import 'screen/transactions.dart';
import 'screen/categories.dart';
import 'screen/graphs.dart';
import 'screen/charts.dart';
import 'screen/about.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/navigation/route_aware_widget.dart';
import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/redux/reducers/app_reducer.dart';
import 'package:homeaccountantapp/redux/middleware/navigation_middleware.dart';


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(account: 'Account 1', dateRange: "ALL", route: [AppRoutes.home]),
    middleware: createNavigationMiddleware()
  );

  runApp(StoreProvider(store: store, child: MyApp()));
}

class MyApp extends StatelessWidget {
  MaterialPageRoute _getRoute(RouteSettings settings) {
    switch(settings.name) {
      case AppRoutes.home:
        return MainRoute(MyHomePage(), settings: settings);
      case AppRoutes.transactions:
        return MainRoute(TransactionsPage(), settings: settings);
      case AppRoutes.categories:
        return MainRoute(CategoriesPage(), settings: settings);
      case AppRoutes.graphs:
        return MainRoute((GraphsPage()), settings: settings);
      case AppRoutes.charts:
        return MainRoute(ChartsPage(), settings: settings);
      case AppRoutes.about:
        return MainRoute(AboutPage(), settings: settings);
      default:
        return MainRoute(MyHomePage(), settings: settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
      title: 'Home Accountant',
      theme: ThemeData(
        primaryColor: Colors.grey[850],
        accentColor: Colors.grey[900]
      ),
      home: MyHomePage(),
    );
  }
}

class MainRoute<T> extends MaterialPageRoute<T> {
  MainRoute(Widget widget, {RouteSettings settings}) :
      super(
        builder: (_) => RouteAwareWidget(child: widget),
        settings: settings
      );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
