import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:homeaccountantapp/redux/models/models.dart';


List<Map<String, dynamic>> buttons = [
  {'name': 'Account', 'icon': Icons.account_balance_wallet},
  {'name': 'Date range', 'icon': Icons.date_range}
];

class SpeedDialButton extends StatefulWidget {
  final AnimationController _controller;
  final PanelController _pcAccount;
  final PanelController _pcDate;

  SpeedDialButton(this._controller, this._pcAccount, this._pcDate);

  @override
  _SpeedDialButtonState createState() => _SpeedDialButtonState();
}

class _SpeedDialButtonState extends State<SpeedDialButton> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: List.generate(buttons.length, (int index) {
                Widget child = Container(
                  height: 70.0,
                  width: 200.0,
                  alignment: FractionalOffset.bottomCenter,
                  child: ScaleTransition(
                    alignment: Alignment.centerRight,
                    scale: CurvedAnimation(
                      parent: widget._controller,
                      curve: Interval(
                        0.0,
                        1.0 - index / buttons.length / 2.0,
                        curve: Curves.bounceOut
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                          margin: EdgeInsets.only(right: 15.0),
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
                          child: Icon(buttons[index]['icon']),
                          onPressed: () {
                            if (buttons[index]['name'] == 'Account') {
                              if (widget._pcAccount.isAttached) {
                                if (widget._pcAccount.isPanelOpen) {
                                  widget._pcAccount.close();
                                } else {
                                  widget._pcAccount.open();
                                }
                              } else {
                                print(widget._pcAccount.isAttached);
                              }
                            }
                            if (buttons[index]['name'] == 'Date range') {
                              if (widget._pcDate.isAttached) {
                                if (widget._pcDate.isPanelOpen) {
                                  widget._pcDate.close();
                                } else {
                                  widget._pcDate.open();
                                }
                              } else {
                                print(widget._pcDate.isAttached);
                              }
                            }
                            if (!widget._controller.isDismissed) {
                              widget._controller.reverse();
                            }
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