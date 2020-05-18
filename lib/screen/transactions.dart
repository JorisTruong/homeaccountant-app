import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/components/account_panel.dart';
import 'package:homeaccountantapp/components/speed_dial.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/components/transaction_card.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


final transactions = {
  'March 2020': [
    {
      'id': 0,
      'transaction_name': 'Salary',
      'account_id': 0,
      'date': '2020-03-02',
      'is_expense': 0,
      'amount': 3000,
      'description': '',
      'category_id': 1,
      'subcategory_id': 0
    },
    {
      'id': 1,
      'transaction_name': 'Shoes',
      'account_id': 1,
      'date': '2020-03-31',
      'is_expense': 1,
      'amount': 80,
      'description': '',
      'category_id': 2,
      'subcategory_id': 3
    },
    {
      'id': 2,
      'transaction_name': 'Clothes',
      'account_id': 0,
      'date': '2020-03-31',
      'is_expense': 1,
      'amount': 200,
      'description': '',
      'category_id': 2,
    }
  ],
  'April 2020': [
    {
      'id': 3,
      'transaction_name': 'Pho',
      'account_id': 1,
      'date': '2020-04-01',
      'is_expense': 1,
      'amount': 10,
      'description': '',
      'category_id': 3,
      'subcategory_id': 1
    },
    {
      'id': 4,
      'transaction_name': 'KBBQ',
      'account_id': 1,
      'date': '2020-04-01',
      'is_expense': 1,
      'amount': 30,
      'description': '',
      'category_id': 4,
      'subcategory_id': 1
    },
    {
      'id': 5,
      'transaction_name': 'Sandwich',
      'account_id': 1,
      'date': '2020-04-01',
      'is_expense': 1,
      'amount': 5,
      'description': 'Triangle',
      'category_id': 1,
      'subcategory_id': 2
    },
  ]
};

class TransactionsPage extends StatefulWidget {
  TransactionsPage({Key key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with TickerProviderStateMixin {

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
                  'Transactions',
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
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: List.generate(transactions.length, (int index) {
                        var month = transactions.keys.elementAt(index);
                        return TransactionCard(month, transactions[month]);
                      })
                    )
                  ]..addAll(
                    [
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
                  )
                )
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(NavigatePushAction(AppRoutes.transaction));
                },
                child: Icon(Icons.add),
              ),
            )
          )
        );
      }
    );
  }
}