import 'package:flutter/material.dart';

import 'package:homeaccountantapp/const.dart';

class GenericHeader extends StatelessWidget {
  final String title;

  GenericHeader(
    this.title
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      color: baseColors.mainColor,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: baseFontSize.title
                )
              )
            ]
          )
        ]
      )
    );
  }
}