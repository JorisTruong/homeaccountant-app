import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/generic_header.dart';
import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/screen/about.dart';


class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return Center(
            child: Column(
              children: [
                GenericHeader('Settings', false, () {}),
                Expanded(
                  child: Container(
                    color: baseColors.mainColor,
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.85,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)
                        ),
                        color: Colors.white
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 80.0),
                            child: Container(
                              child: Column(
                                  children: [
                                    ListView(
                                      padding: EdgeInsets.all(20.0),
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        Material(
                                          child: ListTile(
                                            title: Text('Accounts'),
                                            trailing: Icon(Icons.keyboard_arrow_right),
                                            onTap: () {
                                              print('Tap');
                                            },
                                          )
                                        ),
                                        Material(
                                          child: ListTile(
                                            title: Text('Categories'),
                                            trailing: Icon(Icons.keyboard_arrow_right),
                                            onTap: () {
                                              print('Tap');
                                            },
                                          )
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 32),
                                    AboutPage()
                                  ]
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  ),
              ]
            )
        );
      }
    );
  }
}