import 'package:flutter/material.dart';

class CurrencyIcon extends StatelessWidget {
  final String currency;

  CurrencyIcon(this.currency);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 60.0,
      width: 60.0,
      decoration: new BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.all(Radius.circular(22.5))
      ),
      child: Center(
        child: Text(
          currency,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)
        )
      )
    );
  }
}