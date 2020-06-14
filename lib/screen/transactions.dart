import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/account_panel.dart';
import 'package:homeaccountantapp/components/date_range_panel.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/components/speed_dial.dart';
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
  PanelController _pcAccount = PanelController();
  PanelController _pcDate = PanelController();

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
              appBar: AppBar(
                title: Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: baseFontSize.title
                  ),
                ),
                centerTitle: true,
                /// 'actions' on the AppBar is what appears on the top right side.
                /// This is for the speed dial.
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: baseColors.transparent,
                      onPressed: () {
                        if (_controller.isDismissed) {
                          _controller.forward();
                        } else {
                          _controller.reverse();
                        }
                      },
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget child) {
                          return Icon(Icons.more_vert);
                        }
                      )
                    )
                  )
                ],
              ),
              /// This is the drawer accessible from a left-to-right swipe or the top left icon.
              drawer: NavigationDrawer(),
              body: Stack(
                children: [
                  SingleChildScrollView(
                  /// Display all the transactions
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: getTransactions(databaseClient.db, _store.state.dateRangeType, _store.state.dateRange, _store.state.accountId),
                          builder: (BuildContext context, AsyncSnapshot<Map<String, List<transactions.Transaction>>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
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
                  ),
                  SpeedDialButton(_controller, _pcAccount, _pcDate),
                  SlidingUpPanel(
                    controller: _pcAccount,
                    panel: AccountPanel(_pcAccount),
                    backdropEnabled: true,
                    minHeight: 0.0,
                    maxHeight: 0.8 * MediaQuery.of(context).size.height,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)
                    ),
                    onPanelSlide: (value) {
                      if (value == 2.086162576020456e-9) _store.dispatch(ChangeVisibility(false));
                    },
                    onPanelClosed: () {
                      _store.dispatch(ChangeVisibility(true));
                    },
                  ),
                  SlidingUpPanel(
                    controller: _pcDate,
                    panel: DateRangePanel(_pcDate),
                    backdropEnabled: true,
                    minHeight: 0.0,
                    maxHeight: 0.8 * MediaQuery.of(context).size.height,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)
                    ),
                    onPanelSlide: (value) {
                      if (value == 2.086162576020456e-9) _store.dispatch(ChangeVisibility(false));
                    },
                    onPanelClosed: () {
                      _store.dispatch(ChangeVisibility(true));
                    },
                  )
                ]
              ),
              floatingActionButton: Visibility(
                visible: _store.state.visibility,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    _store.dispatch(IsCreatingTransaction(true));
                    _store.dispatch(NavigatePushAction(AppRoutes.transaction));
                  },
                  child: Icon(Icons.add),
                ),
              ),
            )
          )
        );
      }
    );
  }
}