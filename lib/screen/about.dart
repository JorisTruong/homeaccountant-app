import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the about us page.
///


class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {

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
              /// This is the drawer accessible from a left-to-right swipe or the top left icon.
              drawer: NavigationDrawer(),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Home Accountant',
                          style: TextStyle(
                            fontSize: baseFontSize.bigTitle,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ]
                    ),
                    SizedBox(height: 32),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            'Home Accountant is a Free Open-Source Software (FOSS) built to manage bank accounts. It lets you create accounts, add transactions, organize them into categories and subcategories. It also provides various kinds of charts and graphs to help having a better understanding of your expenses. Our goal, as independent developers, was to create a free, simple, and user-friendly money managing application.',
                            style: TextStyle(
                              fontSize: baseFontSize.title
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Currently, Home Accountant does not use any Internet connection. As a result, it cannot share any of your data, especially the transactions you decided to save in this app. We care about your privacy.',
                            style: TextStyle(
                                fontSize: baseFontSize.title
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Home Accountant is licensed under the AGPL (Affero General Public License). The code is hosted at Codeberg; and also at Github and Gitlab, as mirrors. If you want to contribute, check out the links below!',
                            style: TextStyle(
                              fontSize: baseFontSize.title
                            ),
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: SvgPicture.asset('assets/codeberg.svg', width: MediaQuery.of(context).size.width * 0.15),
                          onTap: () async {
                            String codeberg = 'https://codeberg.org/joristruong/homeaccountant-app';
                            if (await canLaunch(codeberg)) {
                              await launch(codeberg);
                            } else {
                              throw 'Could not launch $codeberg';
                            }
                          },
                        ),
                        InkWell(
                          child: SvgPicture.asset('assets/github.svg', width: MediaQuery.of(context).size.width * 0.15),
                            onTap: () async {
                            String github = 'https://github.com/JorisTruong/homeaccountant-app';
                            if (await canLaunch(github)) {
                              await launch(github);
                            } else {
                              throw 'Could not launch $github';
                            }
                          }
                        ),
                        InkWell(
                          child: SvgPicture.asset('assets/gitlab.svg', width: MediaQuery.of(context).size.width * 0.15),
                          onTap: () async {
                            String gitlab = 'https://gitlab.com/joris.truong/homeaccountant-app';
                            if (await canLaunch(gitlab)) {
                              await launch(gitlab);
                            } else {
                              throw 'Could not launch $gitlab';
                            }
                          }
                        )
                      ],
                    )
                  ]
                )
              ),
            )
          );
        }
    );
  }
}