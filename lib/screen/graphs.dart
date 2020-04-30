import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/speed_dial.dart';
import 'package:homeaccountantapp/components/pie_chart.dart';


final expenses = [
  {'name': 'Category 1', 'color': Color(0xff0293ee), 'percentage': 40},
  {'name': 'Category 2', 'color': Color(0xfff8b250), 'percentage': 10},
  {'name': 'Category 3', 'color': Color(0xff845bef), 'percentage': 17},
  {'name': 'Category 4', 'color': Color(0xff13d38e), 'percentage': 13},
  {'name': 'Category 5', 'color': Color(0xfff293ee), 'percentage': 20}
];

final revenue = [
  {'name': 'Category 1', 'color': Color(0xff0293ee), 'percentage': 90},
  {'name': 'Category 2', 'color': Color(0xfff8b250), 'percentage': 10},
  {'name': 'Category 3', 'color': Color(0xff845bef), 'percentage': 0},
  {'name': 'Category 4', 'color': Color(0xff13d38e), 'percentage': 0},
  {'name': 'Category 5', 'color': Color(0xfff293ee), 'percentage': 0}
];

class GraphsPage extends StatefulWidget {
  GraphsPage({Key key}) : super(key: key);

  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> with TickerProviderStateMixin {

  List options = [
    {'name': 'Home', 'icon': Icons.home, 'route': AppRoutes.home},
    {'name': 'Transactions', 'icon': Icons.done_all, 'route': AppRoutes.transactions},
    {'name': 'Categories', 'icon': Icons.category, 'route': AppRoutes.categories},
    {'name': 'Graphs', 'icon': Icons.pie_chart, 'route': AppRoutes.graphs},
    {'name': 'Charts', 'icon': Icons.show_chart, 'route': AppRoutes.charts},
    {'name': 'About us', 'icon': Icons.info_outline, 'route': AppRoutes.about}
  ];

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
                  'Graphs',
                  style: TextStyle(
                      fontSize: 24
                  ),
                ),
                centerTitle: true,
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
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
              drawer: Drawer(
                  child: ListView(
                      padding: const EdgeInsets.all(0.0),
                      children: <Widget>[
                        DrawerHeader(
                          child: null,
                          decoration: BoxDecoration(
                              color: Colors.grey[850]
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
                                    fontSize: 20,
                                  )
                              ),
                              onTap: () {
                                print('${item['name']} pressed');
                                Navigator.pop(context);
                                if (item['route'] != AppRoutes.graphs) {
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
              body: Stack(
                children: <Widget>[
                  Column(
                    children: [
                      PieChartCard(data: expenses, title: 'Expenses'),
                      PieChartCard(data: revenue, title: 'Revenue')
                    ],
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
                ]
              ),
            )
          );
        }
    );
  }
}