import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:math';

import 'package:homeaccountantapp/components/categories_card.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/const.dart';


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

  List options = [
    {'name': 'Home', 'icon': Icons.home, 'route': AppRoutes.home},
    {'name': 'Transactions', 'icon': Icons.done_all, 'route': AppRoutes.transactions},
    {'name': 'Categories', 'icon': Icons.category, 'route': AppRoutes.categories},
    {'name': 'Graphs', 'icon': Icons.pie_chart, 'route': AppRoutes.graphs},
    {'name': 'Charts', 'icon': Icons.show_chart, 'route': AppRoutes.charts},
    {'name': 'About us', 'icon': Icons.info_outline, 'route': AppRoutes.about}
  ];

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
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: const EdgeInsets.all(0.0),
                children: <Widget>[
                  DrawerHeader(
                    child: null,
                    decoration: BoxDecoration(
                      color: baseColors.mainColor
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map item = options[index];
                      return ListTile(
                        leading: Icon(item['icon']),
                        title: Text(
                          item['name'],
                          style: TextStyle(
                            fontSize: baseFontSize.title2,
                          )
                        ),
                        onTap: () {
                          print('${item['name']} pressed');
                          Navigator.pop(context);
                          if (item['route'] != AppRoutes.categories) {
                            StoreProvider.of<AppState>(context).dispatch(NavigatePushAction(item['route']));
                          }
                          print(StoreProvider.of<AppState>(context).state);
                        },
                      );
                    },
                  )
                ]
              )
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: new List.generate(categories.length, (int index) {
                  var category = categories.keys.toList()[index];
                  var subcategories = categories.values.toList()[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: CategoryCard(category, subcategories)
                  );
                })
              )
            )
          )
        );
      }
    );
  }
}