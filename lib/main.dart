import 'package:flutter/material.dart';
import 'package:homeaccountantapp/screen/subcategory.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'screen/homepage.dart';
import 'screen/transactions.dart';
import 'screen/transaction_info.dart';
import 'screen/categories.dart';
import 'screen/category_info.dart';
import 'screen/graphs.dart';
import 'screen/charts.dart';
import 'screen/about.dart';
import 'navigation/app_routes.dart';
import 'navigation/route_aware_widget.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'redux/models/models.dart';
import 'redux/reducers/app_reducer.dart';
import 'redux/middleware/navigation_middleware.dart';
import 'const.dart';

///
/// This is the entry point of the application.
///


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> initializeDatabase() async {
  // TO REMOVE:
  await deleteDatabase(join(await getDatabasesPath(), 'home_accountant.db'));

  await databaseClient.create();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDatabase();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState(
      accountId: 1,
      transactionName: TextEditingController(),
      transactionDate: TextEditingController(),
      categorySubcategoryText: TextEditingController(),
      transactionSubcategoryText: TextEditingController(),
      transactionAmount: TextEditingController(),
      transactionDescription: TextEditingController(),
      dateRangeType: 'Year',
      selectedDate: DateTime.now(),
      dateRange: dateToDateRange(null, null),
      route: [AppRoutes.home],
      visibility: true, /// Visibility of the floating button for sliding up panel
      isCreating: false, /// If we are creating a transaction or not
      isSelectingSubcategory: false, /// If we are currently selecting a subcategory from the transactions page
    ),
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
      case AppRoutes.transaction:
        return AddRoute(TransactionInfoPage(), settings: settings);
      case AppRoutes.category:
        return AddRoute(CategoryInfoPage(), settings: settings);
      case AppRoutes.subcategory:
        return AddRoute(SubcategoryPage(), settings: settings);
      default:
        return MainRoute(MyHomePage(), settings: settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        Locale('en', 'GB'),
      ],
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
      title: 'Home Accountant',
      theme: ThemeData(
        primaryColor: baseColors.mainColor,
        accentColor: baseColors.mainColor
      ),
      home: MyHomePage(),
    );
  }
}

/// Defines a fade transition when routing.
/// This is the default transition.
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

/// Defines a slide transition when routing.
/// It is particularly used when creating/updating a category or a transaction.
class AddRoute<T> extends MaterialPageRoute<T> {
  AddRoute(Widget widget, {RouteSettings settings}) :
        super(
          builder: (_) => RouteAwareWidget(child: widget),
          settings: settings
      );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animatable<Offset> tween = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.ease));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
