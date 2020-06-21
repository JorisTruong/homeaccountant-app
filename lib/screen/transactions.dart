import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/components/transaction_card.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/transactions.dart' as transactions;
import 'package:homeaccountantapp/database/queries/transactions.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the transactions page.
/// It is where all the transactions from the selected date range are displayed.
///


class TransactionsPage extends StatefulWidget {
  TransactionsPage({Key key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with TickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

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
          /// The GestureDetector is for removing the speed dial when tapping the screen.
          child: GestureDetector(
            onTap: () {
              if (!_controller.isDismissed) {
                _controller.reverse();
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 40),
                    /// Display all the transactions
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: getTransactions(databaseClient.db, _store.state.dateRangeType, _store.state.dateRange, _store.state.accountId),
                          builder: (BuildContext context, AsyncSnapshot<Map<String, List<transactions.Transaction>>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  String month = snapshot.data.keys.elementAt(index);
                                  if (snapshot.data[month].length > 0) {
                                    return TransactionCard(month, snapshot.data[month]);
                                  }
                                  else {
                                    return Container();
                                  }
                                }
                              );
                            } else {
                              return LoadingComponent();
                            }
                          }
                        )
                      ]
                    ),
                  )
                ]
              ),
              floatingActionButton: Visibility(
                visible: _store.state.visibility,
                child: Padding(
                  padding: EdgeInsets.only(bottom: Platform.isAndroid ? 60 : 90),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      _store.dispatch(IsCreatingTransaction(true));
                      _store.dispatch(NavigatePushAction(AppRoutes.transaction));
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            )
          )
        );
      }
    );
  }
}