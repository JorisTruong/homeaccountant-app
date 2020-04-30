import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:homeaccountantapp/utils.dart';


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
  const LineChartCard({
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
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey[600],
                blurRadius: 10.0,
                offset: Offset(
                  0.0,
                  5.0,
                ),
              ),
            ],
            gradient: LinearGradient(
              colors: const [
                Color(0xffffffff),
                Color(0xffffffff),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 37,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 37,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                      child: LineChart(
                        lineData(),
                        swapAnimationDuration: const Duration(milliseconds: 250),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.grey[850]
                ),
                onPressed: () {
                  setState(() {
                    switchData = switchFlag(switchData, 4);
                  });
                },
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
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff303030),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            return getXAxis(value, widget.durationType);
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff303030),
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff212121),
            width: 2,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
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
        Colors.green,
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
        Colors.redAccent,
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
      colors: const [
        Colors.blueAccent,
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