import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/data.dart';
import 'package:homeaccountantapp/utils.dart';


///
/// This is the card for the line chart.
/// Have a look at the fl_chart package for more information.
///


/// Get the max value of the data to build the scale
double getDataMaxValue(List<double> expenses, List<double> revenue, List<double> balance) {
  double maxExpenses = expenses.reduce(max);
  double maxRevenue = revenue.reduce(max);
  double maxBalance = balance.reduce(max);
  return [maxExpenses, maxRevenue, maxBalance].reduce(max);
}

class LineChartCard extends StatefulWidget {
  LineChartCard({
    Key key,
    this.title,
    this.durationType
  });

  final String title;
  final String durationType;

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
    dataMaxValue = getDataMaxValue(expensesWeek, revenueWeek, balanceWeek);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 1.23,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
              ),
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
                      switchData = switchFlag(switchData, 4);
                    });
                  },
                )
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
                  fontSize: 14
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
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
            color: baseColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: baseFontSize.text,
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
            fontSize: baseFontSize.text,
          ),
          getTitles: (value) {
            return getYAxis(value, dataMaxValue);
          },
          margin: 10,
          reservedSize: 40,
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
      maxX: durationType == 'Year' ? 24 : 14,
      maxY: 4,
      minY: 0,
      lineBarsData: linesBarData(),
    );
  }

  /// Line data
  List<LineChartBarData> linesBarData() {
    final LineChartBarData revenue = LineChartBarData(
      spots: dataToSpots(revenueWeek, dataMaxValue),
      isCurved: false,
      colors: [
        baseColors.green,
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: switchData != 0,
      ),
      belowBarData: BarAreaData(
        show: switchData != 0,
      ),
    );
    final LineChartBarData expenses = LineChartBarData(
      spots: dataToSpots(expensesWeek, dataMaxValue),
      isCurved: false,
      colors: [
        baseColors.red,
      ],
      barWidth: 5,
      isStrokeCapRound: switchData != 0,
      dotData: FlDotData(
        show: switchData != 0,
      ),
      belowBarData: BarAreaData(
        show: switchData != 0,
      ),
    );
    final LineChartBarData balance = LineChartBarData(
      spots: dataToSpots(balanceWeek, dataMaxValue),
      isCurved: false,
      colors: [
        baseColors.blue,
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: switchData != 0,
      ),
      belowBarData: BarAreaData(
        show: switchData != 0,
      ),
    );
    if (switchData == 1) {
      return [balance];
    } else if (switchData == 2) {
      return [revenue];
    } else if (switchData == 3) {
      return [expenses];
    } else {
      return [balance, revenue, expenses];
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
    switch (value.toInt()) {
      case 1:
        return 'W1';
      case 5:
        return 'W2';
      case 9:
        return 'W3';
      case 13:
        return 'W4';
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
  switch (value.toInt()) {
    case 1:
      return NumberFormat.compact().format(max * 0.25);
    case 2:
      return NumberFormat.compact().format(max * 0.5);
    case 3:
      return NumberFormat.compact().format(max * 0.75);
    case 4:
      return NumberFormat.compact().format(max);
  }
  return '';
}

/// Transform the amounts into FlSpots for the line chart
List<FlSpot> dataToSpots(List<double> data, double dataMaxValue) {
  return List.generate(data.length, (int index) {
    return FlSpot(index*2 + 1.0, dataMaxValue == 0 ? 0 : data[index] * 4.0 / dataMaxValue);
  });
}