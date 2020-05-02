import 'package:flutter/material.dart';

class MainCardIcon extends StatelessWidget {
  final dynamic icon;
  final dynamic color;

  MainCardIcon(this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 60.0,
      width: 60.0,
      decoration: new BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(22.5))
      ),
      child: Center(
        child: (icon is String) ? Text(
          icon,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)
        ) : Icon(
          icon,
          color: Colors.white,
          size: 30.0,
        )
      )
    );
  }
}