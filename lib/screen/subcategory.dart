import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/data.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/categories_card.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/subcategories.dart';
import 'package:homeaccountantapp/database/queries/subcategories.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the subcategory page.
/// It is displayed when selecting a subcategory from the transaction info page.
///


class SubcategoryPage extends StatefulWidget {
  SubcategoryPage({Key key}) : super(key: key);

  @override
  _SubcategoryPageState createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return StoreConnector<AppState, int>(
      converter: (Store<AppState> store) => store.state.categoryIndex,
      builder: (BuildContext context, int categoryIndex) {
        return WillPopScope(
          onWillPop: () {
            _store.dispatch(NavigatePopAction());
            print(_store.state);
            return Future(() => true);
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _store.dispatch(NavigatePopAction());
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'Choose a subcategory',
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
                      _store.dispatch(IsCreatingSubcategory(true));
                      _store.dispatch(IsSelectingSubcategory(true));
                      _store.dispatch(NavigatePushAction(AppRoutes.category));
                    },
                    child: Icon(Icons.add)
                  )
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        /// Only show the subcategories of the selected category
                        child: FutureBuilder(
                          future: subcategoriesFromCategoryId(databaseClient.db, _store.state.categoryIndex),
                          builder: (BuildContext context, AsyncSnapshot<List<Subcategory>> snapshot) {
                            if (snapshot.hasData) {
                              return CategoryCard(
                                _store.state.categoryIndex,
                                categories[_store.state.categoryIndex]['category_name'],
                                snapshot.data,
                                getCategoryColor(_store.state.categoryIndex),
                                true
                              );
                            } else {
                              return Container();
                            }
                          }
                        )
                      )
                    ]
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