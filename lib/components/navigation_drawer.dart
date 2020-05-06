import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/const.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0.0),
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
                      if (item['route'] != AppRoutes.about) {
                        StoreProvider.of<AppState>(context).dispatch(NavigatePushAction(item['route']));
                      }
                      print(StoreProvider.of<AppState>(context).state);
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