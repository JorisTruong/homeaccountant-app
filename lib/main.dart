import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import 'components/navigation_bar.dart';
import 'screen/homepage.dart';
import 'screen/accounts.dart';
import 'screen/account_info.dart';
import 'screen/graphs.dart';
import 'screen/transaction_info.dart';
import 'screen/categories.dart';
import 'screen/category_info.dart';
import 'screen/subcategory.dart';
import 'screen/main_currency.dart';
import 'screen/exchange_rates.dart';
import 'navigation/app_routes.dart';
import 'navigation/route_aware_widget.dart';
import 'database/database.dart';
import 'database/queries/main_currency.dart';
import 'redux/models/models.dart';
import 'redux/reducers/app_reducer.dart';
import 'redux/middleware/navigation_middleware.dart';
import 'const.dart';
import 'utils.dart';

///
/// This is the entry point of the application.
///


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> initializeDatabase() async {
  // TO REMOVE:
  // await deleteDatabase(join(await getDatabasesPath(), 'home_accountant.db'));

  await databaseClient.create();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await initializeDatabase();
  TextEditingController showTransactionDate = TextEditingController();
  showTransactionDate.text = DateTime.now().toString().substring(0, 7);
  Map<String, dynamic> mainCurrency = await readMainCurrency(databaseClient.db);
  TextEditingController mainCurrencyText = TextEditingController();
  mainCurrencyText.text = '${mainCurrency["currency"]} (${mainCurrency["country_iso"]})';

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

  final initialState = await persistor.load();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState(
      accountId: initialState == null ? [1] : initialState.accountId,
      accountInfoName: TextEditingController(),
      accountInfoAcronym: TextEditingController(),
      mainCountryIso: mainCurrency["country_iso"],
      mainCurrencyText: mainCurrencyText,
      transactionName: TextEditingController(),
      transactionDate: TextEditingController(),
      categorySubcategoryText: TextEditingController(),
      transactionSubcategoryText: TextEditingController(),
      transactionAmount: TextEditingController(),
      transactionDescription: TextEditingController(),
      dateRangeType: 'Month',
      selectedDate: DateTime.now(),
      dateRange: dateToDateRange('Month', DateTime.now()),
      route: [AppRoutes.home],
      showTransactionType: 'All',
      showTransactionDate: showTransactionDate,
      isCreatingAccount: false, /// If we are creating an account or not
      isCreatingTransaction: false, /// If we are creating a transaction or not
      isCreatingSubcategory: false, /// If we are creating a subcategory or not
      isSelectingSubcategory: false, /// If we are currently selecting a subcategory from the transactions page
    ),
    middleware: createNavigationMiddleware(persistor)
  );

  runApp(StoreProvider(store: store, child: MyApp()));
}

class MyApp extends StatelessWidget {
  MaterialPageRoute _getRoute(RouteSettings settings) {
    switch(settings.name) {
      case AppRoutes.home:
        return MainRoute(MyHomePage(), settings: settings);
      case AppRoutes.accounts:
        return RightToLeftRoute(AccountsPage(), settings: settings);
      case AppRoutes.transactions:
        return MainRoute(TransactionsPage(), settings: settings);
      case AppRoutes.categories:
        return RightToLeftRoute(CategoriesPage(), settings: settings);
      case AppRoutes.account:
        return BottomToTopRoute(AccountInfoPage(), settings: settings);
      case AppRoutes.transaction:
        return BottomToTopRoute(TransactionInfoPage(), settings: settings);
      case AppRoutes.category:
        return BottomToTopRoute(CategoryInfoPage(), settings: settings);
      case AppRoutes.subcategory:
        return BottomToTopRoute(SubcategoryPage(), settings: settings);
      case AppRoutes.mainCurrency:
        return RightToLeftRoute(MainCurrencyPage(), settings: settings);
      case AppRoutes.exchangeRates:
        return RightToLeftRoute(ExchangeRatesPage(), settings: settings);
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
        accentColor: baseColors.mainColor,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: NavigationBar(),
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

/// Defines a right-to-left slide transition when routing.
/// It is particularly used when creating/updating a category or a transaction.
class RightToLeftRoute<T> extends MaterialPageRoute<T> {
  RightToLeftRoute(Widget widget, {RouteSettings settings}) :
    super(
      builder: (_) => RouteAwareWidget(child: widget),
      settings: settings
    );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animatable<Offset> tween = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.ease));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}

/// Defines a bottom-to-top slide transition when routing.
/// It is particularly used when creating/updating a category or a transaction.
class BottomToTopRoute<T> extends MaterialPageRoute<T> {
  BottomToTopRoute(Widget widget, {RouteSettings settings}) :
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