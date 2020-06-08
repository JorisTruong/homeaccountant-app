import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:homeaccountantapp/utils.dart';

import 'indicator.dart';
import 'package:homeaccountantapp/const.dart';


///
/// This is the card for the pie chart.
/// Have a look at the fl_chart package for more information.
///


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
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[600],
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
                    SizedBox(height: 10),
                    Text(
                      switchData ? widget.title1 : widget.title2,
                      style: TextStyle(
                        color: baseColors.mainColor,
                        fontSize: baseFontSize.title2,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(height: 18),
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
                            centerSpaceRadius: MediaQuery.of(context).size.width / 15,
                            sections: showingSections()
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      /// Display the legend
                      children: List.generate(switchData ? widget.expenses.length : widget.revenue.length, (int index) {
                        return Indicator(
                          color: getCategoryColor(index),
                          text: switchData ? widget.expenses[index]['name'] : widget.revenue[index]['name'],
                          isSquare: false
                        );
                      })..add(SizedBox(height: 18)),
                    ),
                    SizedBox(width: 28),
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

  /// Chart data
  List<PieChartSectionData> showingSections() {
    bool emptyExpenses = widget.expenses.every((element) => element['percentage'] == 0);
    bool emptyRevenue = widget.revenue.every((element) => element['percentage'] == 0);
    if ((switchData && emptyExpenses) || (!switchData && emptyRevenue)) {
      final double radius = MediaQuery.of(context).size.width/10;
      return [PieChartSectionData(
        color: baseColors.borderColor,
        value: 100,
        title: '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: baseFontSize.text, fontWeight: FontWeight.bold, color: Colors.white
        ),
      )];
    } else {
      return List.generate(switchData ? widget.expenses.length : widget.revenue.length, (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? baseFontSize.title2 : baseFontSize.text;
        final double radius = isTouched ? MediaQuery.of(context).size.width/10 +10 : MediaQuery.of(context).size.width/10;
        return PieChartSectionData(
          color: getCategoryColor(i),
          value: switchData ? widget.expenses[i]['percentage'].toDouble() : widget.revenue[i]['percentage'].toDouble(),
          title: switchData ? formatPercentage(widget.expenses[i]['percentage']) : formatPercentage(widget.revenue[i]['percentage']),
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white
          ),
        );
      });
    }
  }
}
