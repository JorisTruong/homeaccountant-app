import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


class TransactionInfoPage extends StatefulWidget {
  TransactionInfoPage({Key key}) : super(key: key);

  @override
  _TransactionInfoPageState createState() => _TransactionInfoPageState();
}

class _TransactionInfoPageState extends State<TransactionInfoPage> with TickerProviderStateMixin {

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
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {Navigator.of(context).pop();},
              ),
              title: Text(
                'Transaction Info',
                style: TextStyle(
                  fontSize: baseFontSize.title
                ),
              ),
              centerTitle: true,
              actions: <Widget>[
              ],
            ),
            body: Center(
            ),
          )
        );
      }
    );
  }
}