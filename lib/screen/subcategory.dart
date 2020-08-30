import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/categories_card.dart';
import 'package:homeaccountantapp/components/generic_header.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/queries/queries.dart';
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
            resizeToAvoidBottomPadding: false,
            body: Center(
              child: Column(
                children: [
                  GenericHeader('Subcategory', true, () {
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
                                      future: Future.wait(
                                        [
                                          subcategoriesFromCategoryId(databaseClient.db, _store.state.categoryIndex),
                                          categoryFromId(databaseClient.db, _store.state.categoryIndex)
                                        ]
                                      ),
                                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          return CategoryCard(
                                            _store.state.categoryIndex,
                                            snapshot.data[1],
                                            snapshot.data[0],
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
                        ),
                      )
                    )
                  )
                ]
              )
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
              child: FloatingActionButton(
                heroTag: null,
                elevation: 0,
                backgroundColor: baseColors.mainColor,
                onPressed: () {
                  _store.dispatch(IsCreatingSubcategory(true));
                  _store.dispatch(IsSelectingSubcategory(true));
                  _store.dispatch(NavigatePushAction(AppRoutes.category));
                },
                child: Icon(Icons.add)
              )
            ),
          )
        );
      }
    );
  }
}