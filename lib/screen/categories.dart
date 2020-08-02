import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/categories_card.dart';
import 'package:homeaccountantapp/components/generic_header.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/models.dart' as m;
import 'package:homeaccountantapp/database/queries/queries.dart';
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
            resizeToAvoidBottomPadding: false,
            body: Center(
              child: Column(
                children: [
                  GenericHeader('Categories', true, () {
                    Navigator.of(context).pop();
                  }),
                  Expanded(
                    child: Container(
                      color: baseColors.mainColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)
                          ),
                          color: Colors.white
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: readCategories(databaseClient.db),
                                builder: (BuildContext context, AsyncSnapshot<List<m.Category>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: List.generate(snapshot.data.length, (int index) {
                                          m.Category category = snapshot.data[index];
                                          Color color = getCategoryColor(index);
                                          return FutureBuilder(
                                            future: subcategoriesFromCategoryId(databaseClient.db, index),
                                            builder: (BuildContext context, AsyncSnapshot<List<m.Subcategory>> snapshot) {
                                              if (snapshot.hasData) {
                                                return Padding(
                                                  padding: EdgeInsets.only(bottom: 25.0),
                                                  child: CategoryCard(index, category, snapshot.data, color, false)
                                                );
                                              } else {
                                                return LoadingComponent();
                                              }
                                            }
                                          );
                                        })
                                      )
                                    );
                                  } else {
                                    return LoadingComponent();
                                  }
                                },
                              ),
                            ]
                          )
                        )
                      )
                    )
                  ),
                ]
              )
            ),
            floatingActionButton: Visibility(
              visible: _store.state.visibility,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    _store.dispatch(IsCreatingSubcategory(true));
                    _store.dispatch(NavigatePushAction(AppRoutes.category));
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
          )
        );
      }
    );
  }
}