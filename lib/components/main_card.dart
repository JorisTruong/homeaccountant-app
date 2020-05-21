import 'package:flutter/material.dart';

import 'package:homeaccountantapp/components/main_card_icon.dart';
import 'package:homeaccountantapp/const.dart';


///
/// This is the main card.
/// They are used in the home page as a sum up information.
///


class MainCard extends StatelessWidget {
  final String title;
  final dynamic icon;
  final String amount;
  final dynamic color;
  final String direction;

  MainCard(this.title, this.icon, this.amount, this.color, this.direction);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            /// Depending on the direction, place the icon at the left or right side
            children: direction == 'left' ? <Widget>[
              /// Text title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: baseFontSize.title2)
                  ),
                  Text(
                    amount,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseFontSize.title)
                  )
                ]
              ),
              /// Icon
              MainCardIcon(icon, color)
            ] : <Widget>[
              /// Icon
              MainCardIcon(icon, color),
              /// Text title
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: baseFontSize.title2),
                  ),
                  Text(
                    amount,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseFontSize.title)
                  )
                ]
              )
            ],
          )
        )
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
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