import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the Navigation Drawer widget.
/// It is displayed when swiping from left to right or pressing the corresponding button in the app bar.
///


class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              DrawerHeader(
                child: null,
                decoration: BoxDecoration(
                  color: baseColors.mainColor
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  /// Navigation options
                  Map item = options[index];
                  return ListTile(
                    leading: Icon(item['icon']),
                    title: Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: baseFontSize.title2,
                      )
                    ),
                    onTap: () {
                      print('${item['name']} pressed');
                      Navigator.pop(context);
                      _store.dispatch(NavigatePushAction(item['route']));
                      print(_store.state);
                    },
                  );
                },
              )
            ]
          )
        );
      }
    );
  }
}