import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/components/main_card.dart';
import 'package:homeaccountantapp/components/line_chart.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/components/speed_dial.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


final String currency = 'HKD';
final String balance = '250,000';
final String expenses = '80,000';
final String revenue = '330,000';
final String transactionNumber = '42';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

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
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Home Accountant',
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
                    backgroundColor: baseColors.mainColor,
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
            body: Center(
              child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainCard('Balance', currency, balance, baseColors.blue, 'left'),
                      MainCard('Revenue', Icons.call_made, revenue, baseColors.green, 'right'),
                      MainCard('Expenses', Icons.call_received, expenses, baseColors.red, 'left'),
                      MainCard('Number of\ntransactions', currency, transactionNumber, baseColors.yellow, 'right'),
                      LineChartCard(title: 'Transactions', durationType: 'week')
                    ],
                  )
                ),
                SpeedDialButton(_controller, _pcAccount, _pcDate),
                SlidingUpPanel(
                  controller: _pcAccount,
                  panel: Center(child: Text("This is the sliding Widget for Account"),),
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
              ])
            ),
          )
        );
      }
    );
  }
}