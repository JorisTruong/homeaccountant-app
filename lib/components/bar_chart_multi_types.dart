import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/const.dart';


///
/// This is the card for the multi-type bar chart.
/// Have a look at the fl_chart package for more information.
///


class BarChartMultiTypesCard extends StatefulWidget {
  BarChartMultiTypesCard({
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
  final Color leftBarColor = baseColors.blue;
  final Color rightBarColor = baseColors.red;
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
                            switchData = !switchData;
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
                            switchData ? 'Expenses' : 'Revenue',
                            style: TextStyle(color: baseColors.mainColor,
                              fontSize: baseFontSize.title2,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2
                            ),
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                      SizedBox(height: 38),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0
                          ),
                          child: BarChart(
                            BarChartData(
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: baseColors.mainColor,
                                  getTooltipItem: (_a, _b, _c, _d) {
                                    List<double> realValues = List.generate(_c.rodStackItem.length, (int i) {
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
                                    color: baseColors.mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: baseFontSize.text
                                  ),
                                  margin: 20,
                                  getTitles: (double value) {
                                    return getXAxis(
                                      value, widget.durationType);
                                  },
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  textStyle: TextStyle(
                                    color: baseColors.mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: baseFontSize.text
                                  ),
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

  /// Multi-type chart data
  BarChartGroupData makeGroupData(int x, List<double> l) {
    double barMaxValue = makeBarValue(l.reduce((a, b) => a + b), maxValue);
    double value1 = makeBarValue(l[0], maxValue);
    double value2 = value1 + makeBarValue(l[1], maxValue);
    double value3 = value2 + makeBarValue(l[2], maxValue);
    double value4 = value3 + makeBarValue(l[3], maxValue);
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: barMaxValue,
        color: leftBarColor,
        width: width,
        rodStackItem: [
          BarChartRodStackItem(0, value1, baseColors.category1),
          BarChartRodStackItem(value1, value2, baseColors.category2),
          BarChartRodStackItem(value2, value3, baseColors.category3),
          BarChartRodStackItem(value3, value4, baseColors.category4),
          BarChartRodStackItem(value4, barMaxValue, baseColors.category5),
        ],
      )
    ]);
  }

  /// Build the chart from the data
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