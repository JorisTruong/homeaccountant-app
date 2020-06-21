import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/account_item.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/accounts.dart';
import 'package:homeaccountantapp/database/queries/accounts.dart';
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
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: Platform.isAndroid ? 60 : 90),
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
            )
          );
        }
    );
  }
}