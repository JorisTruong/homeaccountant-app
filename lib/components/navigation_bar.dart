import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-nav-bar-scaffold.widget.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/screen/homepage.dart';
import 'package:homeaccountantapp/screen/transactions.dart';
import 'package:homeaccountantapp/screen/categories.dart';
import 'package:homeaccountantapp/screen/graphs.dart';
import 'package:homeaccountantapp/screen/accounts.dart';


///
/// This is the Navigation bar widget.
/// It is displayed at the bottom of the screen.
/// It also manages navigation
///


class NavigationBar extends StatefulWidget {
  NavigationBar({Key key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return List.generate(5, (int index) {
      return PersistentBottomNavBarItem(
        icon: Icon(options[index]['icon']),
        title: options[index]['name'],
        activeColor: Colors.white,
        inactiveColor: Colors.white,
      );
    });
  }

  List<Widget> _buildScreens() {
    return [
      MyHomePage(),
      TransactionsPage(),
      CategoriesPage(),
      GraphsPage(),
      AccountsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      controller: _controller,
      items: _navBarsItems(),
      screens: _buildScreens(),
      showElevation: true,
      navBarCurve: NavBarCurve.upperCorners,
      navBarCurveRadius: 30,
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,
      iconSize: 28.0,
      navBarStyle: NavBarStyle.style1,
      backgroundColor: baseColors.mainColor,
      navBarHeight: 90,
    );
  }
}