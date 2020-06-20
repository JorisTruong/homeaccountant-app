import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:date_util/date_util.dart';
import 'dart:math';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';


///
/// This is the card for the line chart.
/// Have a look at the fl_chart package for more information.
///


/// Get the max value of the data to build the scale
double getDataMaxValue(List<List<double>> data) {
  List<List<double>> absData = data.map((l) => l.map((e) => e.abs()).toList()).toList();
  List<double> maxData = absData.map((l) => l.reduce(max)).toList();
  return maxData.reduce(max);
}

class LineChartCard extends StatefulWidget {
  LineChartCard({
    Key key,
    this.title,
    this.subtitle,
    this.durationType,
    this.dateRange,
    this.linesData,
    this.colors,
    this.willNegative
  });

  final String title;
  final String subtitle;
  final String durationType;
  final Map<String, String> dateRange;
  final List<List<double>> linesData;
  final List<Color> colors;
  final bool willNegative;

  @override
  State<StatefulWidget> createState() => LineChartCardState();
}

class LineChartCardState extends State<LineChartCard> {
  int switchData;
  double dataMaxValue;

  @override
  void initState() {
    super.initState();
    switchData = 0;
    dataMaxValue = getDataMaxValue(widget.linesData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 1.1,
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
                          switchData = switchFlag(switchData, widget.linesData.length + 1);
                        });
                      },
                    )
                  ),
                ]
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: baseColors.mainColor,
                          fontSize: baseFontSize.title2,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Center(
                        child: Text(
                          widget.subtitle == null ? '' : widget.subtitle,
                          style: TextStyle(
                            color: baseColors.mainColor,
                            fontSize: baseFontSize.text
                          )
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 37),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0, left: 6.0),
                      child: LineChart(
                        lineData(widget.durationType),
                        swapAnimationDuration: Duration(milliseconds: 250),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  LineChartData lineData(String durationType) {
    return LineChartData(
      extraLinesData: ExtraLinesData(extraLinesOnTop: true),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: baseColors.mainColor,
          /// Customize the tooltip
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                (barSpot.y * dataMaxValue / 4.0).toStringAsFixed(2),
                TextStyle(color: barSpot.bar.colors[0],
                  fontWeight: FontWeight.bold,
                  fontSize: baseFontSize.subtitle
                )
              );
            }).toList();
          }
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          rotateAngle: 270,
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
            color: baseColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: baseFontSize.legend,
          ),
          margin: 10,
          getTitles: (value) {
            return getXAxis(value, widget.durationType);
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: baseColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: baseFontSize.text2,
          ),
          getTitles: (value) {
            return getYAxis(value, dataMaxValue);
          },
          margin: 10,
          reservedSize: 25,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: baseColors.mainColor,
            width: 2,
          ),
          left: BorderSide(
            color: baseColors.transparent,
          ),
          right: BorderSide(
            color: baseColors.transparent,
          ),
          top: BorderSide(
            color: baseColors.transparent,
          ),
        ),
      ),
      /// Points for FlSpot
      minX: 0,
      maxX: durationType == 'Year' ? 24 :
        durationType == 'Month' ? (2 * DateUtil().daysInMonth(
          getDateFromString(widget.dateRange['from'])['month'],
          getDateFromString(widget.dateRange['from'])['year'],
        )).toDouble() :
        14,
      maxY: 4,
      minY: widget.willNegative ? -4 : 0,
      lineBarsData: linesBarData(widget.linesData, widget.colors),
    );
  }

  /// Line data
  List<LineChartBarData> linesBarData(List<List<double>> linesData, List<Color> colors) {
    var linesChart = List.generate(linesData.length, (int i) {
      return LineChartBarData(
        spots: dataToSpots(linesData[i], dataMaxValue),
        isCurved: false,
        colors: [colors[i]],
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
      );
    });
    if (switchData != 0) {
      return [linesChart[switchData-1]];
    } else {
      return linesChart;
    }
  }
}

/// Build the X-axis
String getXAxis(value, type) {
  if (type == 'Week') {
    switch (value.toInt()) {
      case 1:
        return 'MON';
      case 3:
        return 'TUE';
      case 5:
        return 'WED';
      case 7:
        return 'THU';
      case 9:
        return 'FRI';
      case 11:
        return 'SAT';
      case 13:
        return 'SUN';
    }
  } else if (type == 'Month') {
      if (value.toInt().isOdd) {
        return (value / 2 + 1).toInt().toString();
      }
  } else if (type == 'Year') {
    switch (value.toInt()) {
      case 1:
        return 'JAN';
      case 3:
        return 'FEB';
      case 5:
        return 'MAR';
      case 7:
        return 'APR';
      case 9:
        return 'MAY';
      case 11:
        return 'JUN';
      case 13:
        return 'JUL';
      case 15:
        return 'AUG';
      case 17:
        return 'SEP';
      case 19:
        return 'OCT';
      case 21:
        return 'NOV';
      case 23:
        return 'DEC';
    }
  }
  return '';
}

/// Build the scale for Y-axis
String getYAxis(value, max) {
  if (max == 0) {
    if (value.toInt() == 0) {
      return '0';
    }
  } else {
    switch (value.toInt()) {
      case -4:
        return NumberFormat.compact().format(-max);
      case -3:
        return NumberFormat.compact().format(-max * 0.75);
      case -2:
        return NumberFormat.compact().format(-max * 0.5);
      case -1:
        return NumberFormat.compact().format(-max * 0.25);
      case 0:
        return '0';
      case 1:
        return NumberFormat.compact().format(max * 0.25);
      case 2:
        return NumberFormat.compact().format(max * 0.5);
      case 3:
        return NumberFormat.compact().format(max * 0.75);
      case 4:
        return NumberFormat.compact().format(max);
    }
  }
  return '';
}

/// Transform the amounts into FlSpots for the line chart
List<FlSpot> dataToSpots(List<double> data, double dataMaxValue) {
  return List.generate(data.length, (int index) {
    return FlSpot(index*2 + 1.0, dataMaxValue == 0 ? 0 : data[index] * 4.0 / dataMaxValue);
  });
}