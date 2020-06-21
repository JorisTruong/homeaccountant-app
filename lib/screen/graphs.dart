import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/bar_chart_dual.dart';
import 'package:homeaccountantapp/components/line_chart.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/components/pie_chart.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/queries/transactions.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the graphs page.
///


class GraphsPage extends StatefulWidget {
  GraphsPage({Key key}) : super(key: key);

  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> with TickerProviderStateMixin {

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
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: Platform.isAndroid ? 60 : 90),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: Future.wait([
                          getExpensesProportion(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                          getIncomeProportion(databaseClient.db, _store.state.dateRange, _store.state.accountId)
                        ]),
                        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            return PieChartCard(
                              expenses: snapshot.data[0],
                              income: snapshot.data[1],
                              title1: 'Expenses',
                              title2: 'Income'
                            );
                          } else {
                            return LoadingComponent();
                          }
                        }
                      ),
                      FutureBuilder(
                        future: getTransactionsAmount(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                          if (snapshot.hasData) {
                            return BarChartDualCard(title: 'Transactions', data: snapshot.data);
                          } else {
                            return LoadingComponent();
                          }
                        }
                      ),
                      FutureBuilder(
                        future: _store.state.dateRangeType == 'Year' ?
                        Future.wait(
                          List.generate(7, (int i) {
                            return getMonthlyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, i, 1);
                          })
                        )
                        : Future.wait(
                          List.generate(7, (int i) {
                            return getDailyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, i, 1);
                          })
                        ),
                        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            return LineChartCard(
                              title: 'Expenses',
                              durationType: _store.state.dateRangeType,
                              dateRange: _store.state.dateRange,
                              linesData: List.generate(snapshot.data.length, (int i) {
                                return snapshot.data[i].map((e) => e['totalAmount'] == 0 ? 0.0 : -e['totalAmount']).toList().cast<double>();
                              }),
                              colors: [
                                baseColors.category1,
                                baseColors.category2,
                                baseColors.category3,
                                baseColors.category4,
                                baseColors.category5,
                                baseColors.category6,
                                baseColors.category7
                              ],
                              willNegative: false,
                            );
                          } else {
                            return LoadingComponent();
                          }
                        },
                      ),
                      FutureBuilder(
                        future: _store.state.dateRangeType == 'Year' ?
                        Future.wait(
                          List.generate(7, (int i) {
                            return getMonthlyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, i, 0);
                          })
                        )
                        : Future.wait(
                          List.generate(7, (int i) {
                            return getDailyAmounts(databaseClient.db, _store.state.dateRange, _store.state.accountId, i, 0);
                          })
                        ),
                        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            return LineChartCard(
                              title: 'Income',
                              durationType: _store.state.dateRangeType,
                              dateRange: _store.state.dateRange,
                              linesData: List.generate(snapshot.data.length, (int i) {
                                return snapshot.data[i].map((e) => e['totalAmount']).toList().cast<double>();
                              }),
                              colors: [
                                baseColors.category1,
                                baseColors.category2,
                                baseColors.category3,
                                baseColors.category4,
                                baseColors.category5,
                                baseColors.category6,
                                baseColors.category7
                              ],
                              willNegative: false,
                            );
                          } else {
                            return LoadingComponent();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ]
            ),
          )
        );
      }
    );
  }
}