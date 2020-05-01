import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:homeaccountantapp/utils.dart';

class BarChartMultiTypesCard extends StatefulWidget {
  const BarChartMultiTypesCard({
    Key key,
    this.durationType,
    this.data
  });

  final String durationType;
  final List<Map<String, List<double>>> data;

  @override
  State<StatefulWidget> createState() => BarChartMultiTypesCardState();
}

class BarChartMultiTypesCardState extends State<BarChartMultiTypesCard> {
  final Color leftBarColor = Colors.blueAccent;
  final Color rightBarColor = Colors.redAccent;
  final double width = 20;

  List<BarChartGroupData> barGroups;

  int touchedGroupIndex;
  double maxValue;
  bool switchData;

  @override
  void initState() {
    super.initState();

    switchData = false;
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            color: const Color(0xffffffff),
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
                                  color: Colors.grey[850]
                              ),
                              onPressed: () {
                                setState(() {
                                  switchData = !switchData;
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
                                switchData ? 'Expenses' : 'Revenue',
                                style: TextStyle(color: Colors.grey[850],
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: BarChart(
                                BarChartData(
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: Colors.grey[850],
                                      getTooltipItem: (_a, _b, _c, _d) {
                                        var realValues = List.generate(_c.rodStackItem.length, (int i) {
                                          return valueFromBar(_c.rodStackItem[i].toY - _c.rodStackItem[i].fromY, maxValue);
                                        });
                                        return BarTooltipItem(
                                          realValues.toString(),
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
                                          color: Colors.grey[850],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      margin: 20,
                                      getTitles: (double value) {
                                        return getXAxis(
                                            value, widget.durationType);
                                      },
                                    ),
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      textStyle: TextStyle(
                                          color: Colors.grey[850],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      margin: 20,
                                      reservedSize: 20,
                                      getTitles: (value) {
                                        return getYAxis(value, 0);
                                      },
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  barGroups: barGroups,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
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

  BarChartGroupData makeGroupData(int x, List<double> l) {
    var barMaxValue = makeBarValue(l.reduce((a, b) => a + b), maxValue);
    var value1 = makeBarValue(l[0], maxValue);
    var value2 = value1 + makeBarValue(l[1], maxValue);
    var value3 = value2 + makeBarValue(l[2], maxValue);
    var value4 = value3 + makeBarValue(l[3], maxValue);
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: barMaxValue,
        color: leftBarColor,
        width: width,
        rodStackItem: [
          BarChartRodStackItem(0, value1, const Color(0xff0293ee)),
          BarChartRodStackItem(value1, value2, const Color(0xfff8b250)),
          BarChartRodStackItem(value2, value3, const Color(0xff845bef)),
          BarChartRodStackItem(value3, value4, const Color(0xff13d38e)),
          BarChartRodStackItem(value4, barMaxValue, const Color(0xfff293ee)),
        ],
      )
    ]);
  }

  List<BarChartGroupData> makeBarChart() {
    if (!switchData) {
      return List.generate(widget.data.length, (int i) {
        return makeGroupData(
            i,
            widget.data[i]['revenue']
        );
      });
    } else {
      return List.generate(widget.data.length, (int i) {
        return makeGroupData(
            i,
            widget.data[i]['expenses']
        );
      });
    }
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