import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:homeaccountantapp/const.dart';

class GenericHeader extends StatelessWidget {
  final String title;
  final bool close;
  final Function onTapFunction;

  GenericHeader(
    this.title,
    this.close,
    this.onTapFunction
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      color: baseColors.mainColor,
      padding: EdgeInsets.all(20),
      child: Stack(
        children: [
          close ? Material(
            color: baseColors.transparent,
            child: InkWell(
              child: Icon(Icons.close, color: Colors.white),
              onTap: onTapFunction
            )
          ) : Container(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: baseFontSize.title
                    )
                  )
                ]
              )
            ]
          )
        ]
      )
    );
  }
}