import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/const.dart';


final revenueWeek = [
  FlSpot(1, 2),
  FlSpot(3, 1),
  FlSpot(5, 0.3),
  FlSpot(7, 0),
  FlSpot(9, 0),
  FlSpot(11, 0),
  FlSpot(13, 0),
];

final expensesWeek = [
  FlSpot(1, 0),
  FlSpot(3, 0),
  FlSpot(5, 0.2),
  FlSpot(7, 0),
  FlSpot(9, 0),
  FlSpot(11, 0.5),
  FlSpot(13, 0.1),
];

final balanceWeek = [
  FlSpot(1, 2),
  FlSpot(3, 3),
  FlSpot(5, 3.1),
  FlSpot(7, 3.1),
  FlSpot(9, 3.1),
  FlSpot(11, 2.6),
  FlSpot(13, 2.5),
];

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

  @override
  void initState() {
    super.initState();
    switchData = 0;
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
                        lineData(),
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

  LineChartData lineData() {
    return LineChartData(
      extraLinesData: ExtraLinesData(extraLinesOnTop: true),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: baseColors.mainColor,
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
            return getYAxis(value, 0);
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
      minX: 0,
      maxX: 14,
      maxY: 4,
      minY: 0,
      lineBarsData: linesBarData(),
    );
  }

  List<LineChartBarData> linesBarData() {
    final LineChartBarData revenue = LineChartBarData(
      spots: revenueWeek,
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
      spots: expensesWeek,
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
      spots: balanceWeek,
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

String getXAxis(value, type) {
  if (type == 'week') {
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
  } else if (type == 'month') {
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
  }
  return '';
}

String getYAxis(value, max) {
  switch (value.toInt()) {
    case 1:
      return '100k';
    case 2:
      return '200k';
    case 3:
      return '300k';
    case 4:
      return '400k';
  }
  return '';
}