import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:redux/redux.dart';
import 'dart:math';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/components/categories_card.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


final random = new Random();

var categories = {
  'Category 1': [
    {'name': 'Subcategory 1', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 2', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 3', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 4', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 5', 'icon_id': random.nextInt(985)}
  ],
  'Category 2': [
    {'name': 'Subcategory 1', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 2', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 3', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 4', 'icon_id': random.nextInt(985)}
  ],
  'Category 3': [
    {'name': 'Subcategory 1', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 2', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 3', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 4', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 5', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 6', 'icon_id': random.nextInt(985)}
  ],
  'Category 4': [
    {'name': 'Subcategory 1', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 2', 'icon_id': random.nextInt(985)},
    {'name': 'Subcategory 3', 'icon_id': random.nextInt(985)}
  ],
  'Category 5': []
};


class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
            print(StoreProvider.of<AppState>(context).state);
            return new Future(() => true);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Categories',
                style: TextStyle(
                  fontSize: baseFontSize.title
                ),
              ),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: baseColors.transparent,
                    onPressed: () {
                      StoreProvider.of<AppState>(context).dispatch(NavigatePushAction(AppRoutes.category));
                    },
                    child: Icon(Icons.add)
                  )
                )
              ],
            ),
            drawer: NavigationDrawer(),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: new List.generate(categories.length, (int index) {
                      var category = categories.keys.toList()[index];
                      var subcategories = categories.values.toList()[index];
                      var color = getCategoryColor(index);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: CategoryCard(category, subcategories, color)
                      );
                    })
                  ),
                ]
              )
            )
          )
        );
      }
    );
  }
}