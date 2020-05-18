import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/components/account_panel.dart';
import 'package:homeaccountantapp/components/bar_chart_dual.dart';
import 'package:homeaccountantapp/components/bar_chart_multi_types.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/components/pie_chart.dart';
import 'package:homeaccountantapp/components/speed_dial.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


final expenses = [
  {'name': 'Category 1', 'percentage': 40},
  {'name': 'Category 2', 'percentage': 10},
  {'name': 'Category 3', 'percentage': 17},
  {'name': 'Category 4', 'percentage': 13},
  {'name': 'Category 5', 'percentage': 20}
];

final revenue = [
  {'name': 'Category 1', 'percentage': 90},
  {'name': 'Category 2', 'percentage': 10},
  {'name': 'Category 3', 'percentage': 0},
  {'name': 'Category 4', 'percentage': 0},
  {'name': 'Category 5', 'percentage': 0}
];

final transactionsDetailed = [
  {'revenue': [120000.0, 5000.0, 24000.0, 0.0, 51000.0], 'expenses': [50000.0, 0.0, 0.0, 0.0, 0.0]},
  {'revenue': [20000.0, 20000.0, 20000.0, 20000.0, 20000.0], 'expenses': [13000.0, 7000.0, 0.0, 30000.0, 17000.0]},
  {'revenue': [0.0, 0.0, 30000.0, 0.0, 0.0], 'expenses': [0.0, 10000.0, 0.0, 0.0, 10000.0]},
  {'revenue': [54000.0, 0.0, 6000.0, 28000.0, 32000.0], 'expenses': [0.0, 100000.0, 80000.0, 0.0, 0.0]},
  {'revenue': [0.0, 0.0, 60000.0, 60000.0, 60000.0], 'expenses': [7500.0, 0.0, 500.0, 10.0, 6990.0]},
  {'revenue': [20000.0, 0.0, 0.0, 0.0, 10000.0], 'expenses': [10.0000, 10000.0, 10000.0, 10000.0, 10000.0]},
  {'revenue': [1000.0, 1000.0, 8000.0, 0.0, 10000.0], 'expenses': [500.0, 500.0, 6500.0, 1500.0, 1000.0]}
];

class GraphsPage extends StatefulWidget {
  GraphsPage({Key key}) : super(key: key);

  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> with TickerProviderStateMixin {

  AnimationController _controller;
  PanelController _pcAccount = new PanelController();
  PanelController _pcDate = new PanelController();

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, List<String>>(
        converter: (Store<AppState> store) => store.state.route,
        builder: (BuildContext context, List<String> route) {
          return WillPopScope(
            onWillPop: () {
              StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
              print(StoreProvider.of<AppState>(context).state);
              return new Future(() => true);
            },
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
                        child: new AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, Widget child) {
                            return new Icon(Icons.more_vert);
                          }
                        )
                      )
                    )
                  ],
                ),
                drawer: NavigationDrawer(),
                body: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          PieChartCard(expenses: expenses, revenue: revenue, title1: 'Expenses', title2: 'Revenue'),
                          BarChartDualCard(title: 'Transactions', durationType: 'week', data: transactionsDetailed),
                          BarChartMultiTypesCard(durationType: 'week', data: transactionsDetailed)
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
                      panel: Center(child: Text("This is the sliding Widget for Date Range"),),
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