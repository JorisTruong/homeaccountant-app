import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:homeaccountantapp/utils.dart';

import 'indicator.dart';
import 'package:homeaccountantapp/const.dart';


class PieChartCard extends StatefulWidget {
  PieChartCard({
    Key key,
    this.title1,
    this.title2,
    this.expenses,
    this.revenue
  });

  final String title1;
  final String title2;
  final List<Map<String, dynamic>> expenses;
  final List<Map<String, dynamic>> revenue;

  @override
  State<StatefulWidget> createState() => PieChartCardState();
}

class PieChartCardState extends State<PieChartCard> {
  int touchedIndex;
  bool switchData = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Card(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey[500],
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      switchData ? widget.title1 : widget.title2,
                      style: TextStyle(
                        color: baseColors.mainColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(
                      height: 18,
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                              setState(() {
                                if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                    pieTouchResponse.touchInput is FlPanEnd) {
                                  touchedIndex = -1;
                                } else {
                                  touchedIndex = pieTouchResponse.touchedSectionIndex;
                                }
                              });
                            }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections()
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: new List.generate(switchData ? widget.expenses.length : widget.revenue.length, (int index) {
                        return Indicator(
                          color: getCategoryColor(index),
                          text: switchData ? widget.expenses[index]['name'] : widget.revenue[index]['name'],
                          isSquare: false
                        );
                      })..add(SizedBox(height: 18)),
                    ),
                    const SizedBox(
                      width: 28,
                    ),
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
                        switchData = !switchData;
                      });
                    },
                  )
                )
              ]
            ),
          ),
        ),
      )
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(switchData ? widget.expenses.length : widget.revenue.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: getCategoryColor(i),
        value: switchData ? widget.expenses[i]['percentage'].toDouble() : widget.revenue[i]['percentage'].toDouble(),
        title: (switchData ? widget.expenses[i]['percentage'].toString() : widget.revenue[i]['percentage'].toString()) + '%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }
}
