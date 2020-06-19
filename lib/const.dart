import 'package:flutter/material.dart';

import 'package:homeaccountantapp/navigation/app_routes.dart';


/// Navigation options
List options = [
  {'name': 'Home', 'icon': Icons.home, 'route': AppRoutes.home},
  {'name': 'Accounts', 'icon': Icons.account_balance_wallet, 'route': AppRoutes.accounts},
  {'name': 'Transactions', 'icon': Icons.done_all, 'route': AppRoutes.transactions},
  {'name': 'Categories', 'icon': Icons.category, 'route': AppRoutes.categories},
  {'name': 'Graphs', 'icon': Icons.pie_chart, 'route': AppRoutes.graphs},
  {'name': 'About us', 'icon': Icons.info_outline, 'route': AppRoutes.about}
];

class BaseColors {
  Color mainColor = Colors.grey[850];
  Color secondaryColor = Colors.grey[650];
  Color blue = Colors.blueAccent;
  Color red = Colors.redAccent;
  Color yellow = Colors.amberAccent;
  Color green = Colors.green;
  Color transparent = Colors.transparent;
  Color category1 = Color(0xff025fee);
  Color category2 = Color(0xfff8b250);
  Color category3 = Color(0xff845bef);
  Color category4 = Color(0xff13d38e);
  Color category5 = Color(0xffec2b2b);
  Color category6 = Color(0xfff293ee);
  Color category7 = Color(0xff9c9492);
  Color borderColor = Colors.grey[400];
  Color errorColor = Colors.red[700];
}

class BaseFontSize {
  double bigTitle = 24;
  double title = 18;
  double title2 = 16;
  double subtitle = 14;
  double text = 12;
  double text2 = 10;
  double selected = 24;
  double legend = 8;
}

final baseColors = BaseColors();
final baseFontSize = BaseFontSize();