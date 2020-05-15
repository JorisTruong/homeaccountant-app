import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/categories_card.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';

import 'categories.dart';


class SubcategoryPage extends StatefulWidget {
  SubcategoryPage({Key key}) : super(key: key);

  @override
  _SubcategoryPageState createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, int>(
      converter: (Store<AppState> store) => store.state.categoryIndex,
      builder: (BuildContext context, int categoryIndex) {
        return WillPopScope(
          onWillPop: () {
            StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
            print(StoreProvider.of<AppState>(context).state);
            return new Future(() => true);
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
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
                      StoreProvider.of<AppState>(context).dispatch(NavigatePushAction(AppRoutes.category));
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
                        child: CategoryCard(
                          StoreProvider.of<AppState>(context).state.categoryIndex,
                          categories.keys.toList()[StoreProvider.of<AppState>(context).state.categoryIndex],
                          categories.values.toList()[StoreProvider.of<AppState>(context).state.categoryIndex],
                          getCategoryColor(StoreProvider.of<AppState>(context).state.categoryIndex),
                          true
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