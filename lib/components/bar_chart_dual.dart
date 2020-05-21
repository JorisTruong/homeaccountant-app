import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/const.dart';

class BarChartDualCard extends StatefulWidget {
  const BarChartDualCard({
    Key key,
    this.title,
    this.durationType,
    this.data
  });

  final String title;
  final String durationType;
  final List<Map<String, List<double>>> data;

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
    maxValue = getMaxRevenueExpenses(widget.data);
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
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                new BoxShadow(
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
                            barGroups = makeBarChart();
                          });
                        },
                      )
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
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
                          const SizedBox(
                            width: 38,
                          ),
                          Text(
                            widget.title,
                            style: TextStyle(color: baseColors.mainColor, fontSize: baseFontSize.title2, fontWeight: FontWeight.bold, letterSpacing: 2),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: BarChart(
                            BarChartData(
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: baseColors.mainColor,
                                  getTooltipItem: (_a, _b, _c, _d) {
                                    var realValue = valueFromBar(_c.y, maxValue);
                                    return BarTooltipItem(
                                      (_d == 0 ? 'Expenses : \n' : 'Revenue : \n') + realValue.toString(),
                                      TextStyle(color: Colors.white)
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  textStyle: TextStyle(
                                    color: baseColors.mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: baseFontSize.text),
                                  margin: 20,
                                  getTitles: (double value) {
                                    return getXAxis(value, widget.durationType);
                                  },
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  textStyle: TextStyle(
                                    color: baseColors.mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: baseFontSize.text),
                                  margin: 20,
                                  reservedSize: 20,
                                  getTitles: (value) {
                                    return getYAxis(value, 0);
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: false,),
                              barGroups: barGroups,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
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

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    var revenue = BarChartRodData(
      y: y1,
      color: leftBarColor,
      width: width,
    );

    var expenses = BarChartRodData(
    y: y2,
    color: rightBarColor,
    width: width,
    );

    if (switchData == 1) {
      return BarChartGroupData(barsSpace: 4, x: x, barRods: [
        revenue
      ]);
    } else if (switchData == 2) {
      return BarChartGroupData(barsSpace: 4, x: x, barRods: [
        expenses
      ]);
    } else {
      return BarChartGroupData(barsSpace: 4, x: x, barRods: [
        revenue,
        expenses
      ]);
    }
  }

  List<BarChartGroupData> makeBarChart() {
    return List.generate(widget.data.length, (int i) {
      return makeGroupData(
        i,
        makeBarValue(widget.data[i]['revenue'].reduce((a, b) => a+b), maxValue),
        makeBarValue(widget.data[i]['expenses'].reduce((a, b) => a+b), maxValue)
      );
    });
  }
}

String getXAxis(value, type) {
  if (type == 'week') {
    switch (value.toInt()) {
      case 0:
        return 'MON';
      case 1:
        return 'TUE';
      case 2:
        return 'WED';
      case 3:
        return 'THU';
      case 4:
        return 'FRI';
      case 5:
        return 'SAT';
      case 6:
        return 'SUN';
    }
  } else if (type == 'month') {
    switch (value.toInt()) {
      case 0:
        return 'W1';
      case 2:
        return 'W2';
      case 4:
        return 'W3';
      case 6:
        return 'W4';
    }
  }
  return '';
}

String getYAxis(value, max) {
  switch (value.toInt()) {
    case 0:
      return '0';
    case 5:
      return '50k';
    case 10:
      return '100k';
    case 15:
      return '150k';
    case 20:
      return '200k';
  }
  return '';
}