import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/data.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/categories_card.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/subcategories.dart';
import 'package:homeaccountantapp/database/queries/subcategories.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the categories page.
///


class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            _store.dispatch(NavigatePopAction());
            print(_store.state);
            return Future(() => true);
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
              /// 'actions' on the AppBar is what appears on the top right side.
              /// This is for adding a new subcategory.
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: baseColors.transparent,
                    onPressed: () {
                      _store.dispatch(IsCreating(true));
                      _store.dispatch(NavigatePushAction(AppRoutes.category));
                    },
                    child: Icon(Icons.add)
                  )
                )
              ],
            ),
            /// This is the drawer accessible from a left-to-right swipe or the top left icon.
            drawer: NavigationDrawer(),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    /// The body contains as much cards as the number of categories.
                    children: List.generate(categories_.length, (int index) {
                      String category = categories_[index]['category_name'];
                      Color color = getCategoryColor(index);
                      return FutureBuilder(
                        future: subcategoriesFromCategoryId(databaseClient.db, index),
                        builder: (BuildContext context, AsyncSnapshot<List<Subcategory>> snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: CategoryCard(index, category, snapshot.data, color, false)
                            );
                          } else {
                            return Container();
                          }
                        }
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