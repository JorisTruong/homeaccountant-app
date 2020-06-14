import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/account_item.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/accounts.dart';
import 'package:homeaccountantapp/database/queries/accounts.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the accounts page.
///


class AccountsPage extends StatefulWidget {
  AccountsPage({Key key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> with TickerProviderStateMixin {

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
                  'Accounts',
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
                        _store.dispatch(IsCreatingAccount(true));
                        _store.dispatch(NavigatePushAction(AppRoutes.account));
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: readAccounts(databaseClient.db),
                      builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: List.generate(snapshot.data.length, (int i) {
                              return AccountItem(snapshot.data[i]);
                            })
                          );
                        } else {
                          return LoadingComponent();
                        }
                      }
                    )
                  ]
                )
              ),
            )
          );
        }
    );
  }
}