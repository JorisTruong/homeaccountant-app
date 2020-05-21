import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/data.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/account_panel.dart';
import 'package:homeaccountantapp/components/date_range_panel.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/components/speed_dial.dart';
import 'package:homeaccountantapp/components/transaction_card.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


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
              drawer: NavigationDrawer(),
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: List.generate(transactions.length, (int index) {
                        String month = transactions.keys.elementAt(index);
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
                  )
                )
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  _store.dispatch(NavigatePushAction(AppRoutes.transaction));
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