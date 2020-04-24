import 'package:flutter/material.dart';

import 'package:homeaccountantapp/currency_icon.dart';

class MainCard extends StatelessWidget {
  final String currency;
  final String amount;

  MainCard(this.currency, this.amount);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(15.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Balance",
                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    Text(
                      amount,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)
                    )
                  ]
                )
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CurrencyIcon(currency)
              )
            ],
          )
        )
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          new BoxShadow(
            color: Colors.grey[400].withOpacity(0.7),
            blurRadius: 5.0,
            offset: Offset(
              0.0,
              5.0,
            ),
          ),
        ]
      ),
    );
  }
}