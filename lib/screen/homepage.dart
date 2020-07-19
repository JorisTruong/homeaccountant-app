import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/line_chart.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/components/point_tab_bar.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/transactions.dart' as transactions;
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

  AnimationController _animationController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _tabController = TabController(length: 3, vsync: this);
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
              if (!_animationController.isDismissed) {
                _animationController.reverse();
              }
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: baseColors.mainColor,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                              future: getTotalBalance(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.toStringAsFixed(2) + " €",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: baseFontSize.title
                                    )
                                  );
                                } else {
                                  return LoadingComponent();
                                }
                              },
                            )
                          ]
                        ),
                        SizedBox(
                          height: 6
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total balance",
                              style: TextStyle(
                                color: baseColors.borderColor,
                                fontSize: baseFontSize.subtitle
                              )
                            )
                          ]
                        ),
                        SizedBox(
                          height: 24
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FutureBuilder(
                                        future: getTotalIncome(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                                        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              "+" + snapshot.data.toStringAsFixed(2) + " €",
                                              style: TextStyle(
                                                  fontSize: baseFontSize.title2,
                                                  fontWeight: FontWeight.bold,
                                                  color: baseColors.green
                                              ),
                                            );
                                          } else {
                                            return LoadingComponent(size: 5);
                                          }
                                        },
                                      ),
                                      Text(
                                        "Income",
                                        style: TextStyle(
                                          fontSize: baseFontSize.text,
                                          color: baseColors.secondaryColor
                                        ),
                                      )
                                    ]
                                  )
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FutureBuilder(
                                        future: getTotalExpense(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                                        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              "-" + snapshot.data.toStringAsFixed(2) + " €",
                                              style: TextStyle(
                                                  fontSize: baseFontSize.title2,
                                                  fontWeight: FontWeight.bold,
                                                  color: baseColors.red
                                              ),
                                            );
                                          } else {
                                            return LoadingComponent(size: 5);
                                          }
                                        },
                                      ),
                                      Text(
                                        "Expenses",
                                        style: TextStyle(
                                          fontSize: baseFontSize.text,
                                          color: baseColors.secondaryColor
                                        ),
                                      )
                                    ]
                                  )
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
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
                        padding: EdgeInsets.only(top: 15, bottom: 30),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              PointTabBar(tabController: _tabController, length: 3, tabsName: ['Daily', 'Monthly', 'Yearly']),
                              Container(
                                height: 80.0,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: getTransactions(databaseClient.db, _store.state.dateRangeType, _store.state.dateRange, _store.state.accountId),
                                      builder: (BuildContext context, AsyncSnapshot<Map<String, List<transactions.Transaction>>> snapshot) {
                                        if (snapshot.hasData) {
                                          return Center(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                String month = snapshot.data.keys.elementAt(index);
                                                if (snapshot.data[month].length > 0) {
                                                  return Column(
                                                    children: [
                                                      Text("Placeholder")
                                                    ]
                                                  );
                                                }
                                                else {
                                                  return Column(
                                                    children: [
                                                      Text("There are no transactions yet.\nGo ahead a save some transactions!", textAlign: TextAlign.center)
                                                    ]
                                                  );
                                                }
                                              }
                                            )
                                          );
                                        } else {
                                          return LoadingComponent();
                                        }
                                      }
                                    ),
                                    FutureBuilder(
                                      future: getTransactions(databaseClient.db, _store.state.dateRangeType, _store.state.dateRange, _store.state.accountId),
                                      builder: (BuildContext context, AsyncSnapshot<Map<String, List<transactions.Transaction>>> snapshot) {
                                        if (snapshot.hasData) {
                                          return Center(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                String month = snapshot.data.keys.elementAt(index);
                                                if (snapshot.data[month].length > 0) {
                                                  return Column(
                                                    children: [
                                                      Text("Placeholder")
                                                    ]
                                                  );
                                                }
                                                else {
                                                  return Column(
                                                    children: [
                                                      Text("There are no transactions yet.\nGo ahead a save some transactions!", textAlign: TextAlign.center)
                                                    ]
                                                  );
                                                }
                                              }
                                            )
                                          );
                                        } else {
                                          return LoadingComponent();
                                        }
                                      }
                                    ),
                                    FutureBuilder(
                                      future: getTransactions(databaseClient.db, _store.state.dateRangeType, _store.state.dateRange, _store.state.accountId),
                                      builder: (BuildContext context, AsyncSnapshot<Map<String, List<transactions.Transaction>>> snapshot) {
                                        if (snapshot.hasData) {
                                          return Center(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                String month = snapshot.data.keys.elementAt(index);
                                                if (snapshot.data[month].length > 0) {
                                                  return Column(
                                                    children: [
                                                      Text("Placeholder")
                                                    ]
                                                  );
                                                }
                                                else {
                                                  return Column(
                                                    children: [
                                                      Text("There are no transactions yet.\nGo ahead a save some transactions!", textAlign: TextAlign.center)
                                                    ]
                                                  );
                                                }
                                              }
                                            )
                                          );
                                        } else {
                                          return LoadingComponent();
                                        }
                                      }
                                    ),
                                  ],
                                ),
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
                        )
                      ),
                    )
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