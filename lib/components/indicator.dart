import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


///
/// The Indicator widget is used as legend in the pie chart.
///


class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 12,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
