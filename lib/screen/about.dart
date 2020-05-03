import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/const.dart';


class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {

  List options = [
    {'name': 'Home', 'icon': Icons.home, 'route': AppRoutes.home},
    {'name': 'Transactions', 'icon': Icons.done_all, 'route': AppRoutes.transactions},
    {'name': 'Categories', 'icon': Icons.category, 'route': AppRoutes.categories},
    {'name': 'Graphs', 'icon': Icons.pie_chart, 'route': AppRoutes.graphs},
    {'name': 'Charts', 'icon': Icons.show_chart, 'route': AppRoutes.charts},
    {'name': 'About us', 'icon': Icons.info_outline, 'route': AppRoutes.about}
  ];

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
                  'About us',
                  style: TextStyle(
                      fontSize: baseFontSize.title
                  ),
                ),
                centerTitle: true,
                actions: <Widget>[
                ],
              ),
              drawer: Drawer(
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
              ),
              body: Center(
              ),
            )
          );
        }
    );
  }
}