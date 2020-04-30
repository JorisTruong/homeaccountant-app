import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'indicator.dart';


class PieChartCard extends StatefulWidget {
  PieChartCard({
    Key key,
    this.title,
    this.data
  });

  final String title;
  final List<Map<String, dynamic>> data;

  @override
  State<StatefulWidget> createState() => PieChartCardState();
}

class PieChartCardState extends State<PieChartCard> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Card(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.grey[850],
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
                    children: new List.generate(widget.data.length, (int index) {
                      return Indicator(
                        color: widget.data[index]['color'],
                        text: widget.data[index]['name'],
                        isSquare: false
                      );
                    })..add(SizedBox(height: 18)),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              )
            ]
          ),
        ),
      )
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: widget.data[i]['color'],
        value: widget.data[i]['percentage'].toDouble(),
        title: widget.data[i]['percentage'].toString() + '%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    });
  }
}
