import 'package:flutter/material.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:homeaccountantapp/redux/models/models.dart';

const List buttons = [
  {'name': 'All', 'icon': Icons.visibility},
  {'name': 'Month', 'icon': Icons.date_range}
];

class SpeedDialButton extends StatefulWidget {
  AnimationController _controller;

  SpeedDialButton(this._controller);

  @override
  _SpeedDialButtonState createState() => new _SpeedDialButtonState();
}

class _SpeedDialButtonState extends State<SpeedDialButton> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, String>(
      converter: (Store<AppState> store) => store.state.dateRange,
      builder: (BuildContext context, String dateRange) {
        return Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: new List.generate(buttons.length, (int index) {
                Widget child = new Container(
                  height: 70.0,
                  width: 150.0,
                  alignment: FractionalOffset.bottomCenter,
                  child: new ScaleTransition(
                      alignment: Alignment.centerRight,
                      scale: new CurvedAnimation(
                        parent: widget._controller,
                        curve: new Interval(
                          0.0,
                          1.0 - index / buttons.length / 2.0,
                          curve: Curves.bounceOut
                        ),
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                            margin: EdgeInsets.only(right: 18.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(6.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  offset: Offset(0.8, 0.8),
                                  blurRadius: 2.4,
                                )
                              ],
                            ),
                            child: Text(buttons[index]['name']),
                          ),
                          FloatingActionButton(
                            heroTag: null,
                            mini: true,
                            child: new Icon(buttons[index]['icon']),
                            onPressed: () {
                              StoreProvider.of<AppState>(context).dispatch(UpdateDateRange(buttons[index]['name']));
                              print("${StoreProvider.of<AppState>(context).state.dateRange} pressed");
                            },
                          )
                        ],
                      )
                  ),
                );
                return child;
              }).toList()
            )
          )
        );
      }
    );
  }
}