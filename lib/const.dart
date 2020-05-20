import 'package:flutter/material.dart';

import 'package:homeaccountantapp/navigation/app_routes.dart';

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
  Color category5 = Color(0xfff293ee);
  Color borderColor = Colors.grey[400];
}

class BaseFontSize {
  double title = 18;
  double title2 = 16;
  double subtitle = 14;
  double text = 12;
  double text2 = 10;
  double selected = 24;
}

final baseColors = BaseColors();
final baseFontSize = BaseFontSize();

List options = [
  {'name': 'Home', 'icon': Icons.home, 'route': AppRoutes.home},
  {'name': 'Transactions', 'icon': Icons.done_all, 'route': AppRoutes.transactions},
  {'name': 'Categories', 'icon': Icons.category, 'route': AppRoutes.categories},
  {'name': 'Graphs', 'icon': Icons.pie_chart, 'route': AppRoutes.graphs},
  {'name': 'Charts', 'icon': Icons.show_chart, 'route': AppRoutes.charts},
  {'name': 'About us', 'icon': Icons.info_outline, 'route': AppRoutes.about}
];