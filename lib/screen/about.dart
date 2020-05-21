import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return new StoreConnector<AppState, List<String>>(
        converter: (Store<AppState> store) => store.state.route,
        builder: (BuildContext context, List<String> route) {
          return WillPopScope(
            onWillPop: () {
              _store.dispatch(NavigatePopAction());
              print(_store.state);
              return new Future(() => true);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'About us',
                  style: TextStyle(
                      fontSize: baseFontSize.title
                  ),
                ),
                centerTitle: true,
                actions: <Widget>[
                ],
              ),
              drawer: NavigationDrawer(),
              body: Center(
              ),
            )
          );
        }
    );
  }
}