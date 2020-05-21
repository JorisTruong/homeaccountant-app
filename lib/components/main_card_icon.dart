import 'package:flutter/material.dart';

import 'package:homeaccountantapp/const.dart';


///
/// This is the main card icon.
/// It is used for displayed an icon or a text.
///


class MainCardIcon extends StatelessWidget {
  final dynamic icon;
  final dynamic color;

  MainCardIcon(this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(22.5))
      ),
      child: Center(
        child: (icon is String) ? Text(
          icon,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: baseFontSize.title)
        ) : Icon(
          icon,
          color: Colors.white,
          size: 30.0,
        )
      )
    );
  }
}