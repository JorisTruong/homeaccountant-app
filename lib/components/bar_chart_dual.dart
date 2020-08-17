import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/const.dart';


///
/// This is the card for the dual bar chart.
/// Have a look at the fl_chart package for more information.
///


class BarChartDualCard extends StatefulWidget {
  BarChartDualCard({
    Key key,
    this.title,
    this.data
  });

  final String title;
  final List<Map<String, dynamic>> data;

  @override
  State<StatefulWidget> createState() => BarChartDualCardState();
}

class BarChartDualCardState extends State<BarChartDualCard> {
  final Color leftBarColor = baseColors.blue;
  final Color rightBarColor = baseColors.red;
  double width;

  List<BarChartGroupData> barGroups;

  int touchedGroupIndex;
  double maxValue;
  int switchData;

  @override
  void initState() {
    super.initState();

    switchData = 0;
    width = 10;
    maxValue = getMaxIncomeExpenses(widget.data);
    barGroups = makeBarChart();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[700],
                  blurRadius: 10.0,
                  offset: Offset(
                    0.0,
                    5.0,
                  ),
                ),
              ],
              color: Colors.white
            ),
            child: Stack(
              children: <Widget>[
                Row(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: baseColors.mainColor
                        ),
                        onPressed: () {
                          setState(() {
                            switchData = switchFlag(switchData, 3);
                            switchData == 1 || switchData == 2 ? width = 20 : width = 10;
                            if (switchData == 0) {
                              maxValue = getMaxIncomeExpenses(widget.data);
                            }
                            if (switchData == 1) {
                              maxValue = widget.data.map<double>((e) => e['income']).reduce(max);
                            }
                            if (switchData == 2) {
                              maxValue = widget.data.map<double>((e) => e['expenses']).reduce(max);
                            }
                            barGroups = makeBarChart();
                          });
                        },
                      )
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 38),
                          Text(
                            widget.title,
                            style: GoogleFonts.lato(color: baseColors.mainColor, fontSize: baseFontSize.title2, fontWeight: FontWeight.bold, letterSpacing: 2),
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                      SizedBox(height: 38),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: BarChart(
                            BarChartData(
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: baseColors.mainColor,
                                  getTooltipItem: (_a, _b, _c, _d) {
                                    double realValue = valueFromBar(_c.y, maxValue);
                                    return BarTooltipItem(
                                      (_d == 0 ? 'Income : \n' : 'Expenses : \n') + realValue.toString(),
                                      GoogleFonts.lato(color: Colors.white)
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  reservedSize: 20,
                                  rotateAngle: 270,
                                  showTitles: true,
                                  textStyle: GoogleFonts.lato(
                                    color: baseColors.mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: baseFontSize.legend
                                  ),
                                  margin: 20,
                                  getTitles: (double value) {
                                    return widget.data[value.toInt()]['name'];
                                  },
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  textStyle: GoogleFonts.lato(
                                    color: baseColors.mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: baseFontSize.text),
                                  margin: 20,
                                  reservedSize: 20,
                                  getTitles: (value) {
                                    return getYAxis(value, maxValue);
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: barGroups,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }

  /// Dual chart data
  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    BarChartRodData income = BarChartRodData(
      y: y1,
      color: leftBarColor,
      width: width,
    );

    BarChartRodData expenses = BarChartRodData(
    y: y2,
    color: rightBarColor,
    width: width,
    );

    if (switchData == 1) {
      return BarChartGroupData(barsSpace: 4, x: x, barRods: [
        income
      ]);
    } else if (switchData == 2) {
      return BarChartGroupData(barsSpace: 4, x: x, barRods: [
        expenses
      ]);
    } else {
      return BarChartGroupData(barsSpace: 4, x: x, barRods: [
        income,
        expenses
      ]);
    }
  }

  /// Build the chart from the data
  List<BarChartGroupData> makeBarChart() {
    return List.generate(widget.data.length, (int i) {
      return makeGroupData(
        i,
        makeBarValue(widget.data[i]['income'], maxValue),
        makeBarValue(widget.data[i]['expenses'], maxValue)
      );
    });
  }
}

/// Build the scale for the Y-axis.
String getYAxis(value, max) {
  switch (value.toInt()) {
    case 0:
      return '0';
    case 5:
      return NumberFormat.compact().format(max * 0.25);
    case 10:
      return NumberFormat.compact().format(max * 0.5);
    case 15:
      return NumberFormat.compact().format(max * 0.75);
    case 20:
      return NumberFormat.compact().format(max);
  }
  return '';
}