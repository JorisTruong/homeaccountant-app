import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/account_panel.dart';
import 'package:homeaccountantapp/components/bar_chart_dual.dart';
import 'package:homeaccountantapp/components/date_range_panel.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/components/line_chart.dart';
import 'package:homeaccountantapp/components/pie_chart.dart';
import 'package:homeaccountantapp/components/speed_dial.dart';
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
                    'Graphs',
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
                  children: <Widget>[
                    SingleChildScrollView(
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
                                return Container();
                              }
                            }
                          ),
                          FutureBuilder(
                            future: getTransactionsAmount(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                              if (snapshot.hasData) {
                                return BarChartDualCard(title: 'Transactions', data: snapshot.data);
                              } else {
                                return Container();
                              }
                            }
                          ),
                          LineChartCard(title: 'Transactions', durationType: 'Week'),
                        ],
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
                    )
                  ]
                ),
              )
            )
          );
        }
    );
  }
}