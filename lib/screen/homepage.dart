import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/data.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/main_card.dart';
import 'package:homeaccountantapp/components/line_chart.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/queries/transactions.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the home page.
///


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

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
            child: Center(
              child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: getTotalBalance(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                          if (snapshot.hasData) {
                            return MainCard('Balance', currency, snapshot.data.toStringAsFixed(2), baseColors.blue, 'left');
                          } else {
                            return MainCard('Balance', currency, '', baseColors.blue, 'left');
                          }
                        },
                      ),
                      FutureBuilder(
                        future: getTotalIncome(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                          if (snapshot.hasData) {
                            return MainCard('Income', Icons.call_made, snapshot.data.toStringAsFixed(2), baseColors.green, 'right');
                          } else {
                            return MainCard('Income', Icons.call_made, '', baseColors.green, 'right');
                          }
                        },
                      ),
                      FutureBuilder(
                        future: getTotalExpense(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                          if (snapshot.hasData) {
                            return MainCard('Expenses', Icons.call_received, snapshot.data.toStringAsFixed(2), baseColors.red, 'left');
                          } else {
                            return MainCard('Expenses', Icons.call_received, '', baseColors.red, 'left');
                          }
                        },
                      ),
                      FutureBuilder(
                        future: getTransactionsCount(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          if (snapshot.hasData) {
                            return MainCard('Number of\ntransactions', currency, snapshot.data.toString(), baseColors.yellow, 'right');
                          } else {
                            return MainCard('Number of\ntransactions', currency, '', baseColors.yellow, 'right');
                          }
                        },
                      ),
                      FutureBuilder(
                        future: _store.state.dateRangeType == 'Year' ?
                        Future.wait(
                          [
                            getMonthlyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, -1, 0),
                            getMonthlyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, -1, 1),
                            getMonthlyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, -1, -1)
                          ]
                        )
                        : Future.wait(
                          [
                            getDailyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, -1, 0),
                            getDailyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, -1, 1),
                            getDailyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, -1, -1)
                          ]
                        ),
                        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            return LineChartCard(
                              title: 'Transactions',
                              durationType: _store.state.dateRangeType,
                              dateRange: _store.state.dateRange,
                              linesData: [
                                snapshot.data[0].map((e) => e['totalAmount']).toList().cast<double>(),
                                snapshot.data[1].map((e) => e['totalAmount']).toList().cast<double>(),
                                cumulativeSum(snapshot.data[2].map((e) => e['totalAmount']).toList().cast<double>())
                              ],
                              colors: [baseColors.green, baseColors.red, baseColors.blue],
                              willNegative: true,
                            );
                          } else {
                            return LoadingComponent();
                          }
                        },
                      )
                    ],
                  )
                ),
              ])
            )
          )
        );
      }
    );
  }
}