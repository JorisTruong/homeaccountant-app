import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:homeaccountantapp/utils.dart';
import 'dart:math' as math;

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
    this.income
  });

  final String title1;
  final String title2;
  final List<Map<String, dynamic>> expenses;
  final List<Map<String, dynamic>> income;

  @override
  State<StatefulWidget> createState() => PieChartCardState();
}

class PieChartCardState extends State<PieChartCard> {
  int touchedIndex;
  bool switchData = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
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
                    sectionsSpace: widget.income.every((element) => element['percentage'] == 0) || widget.income.any((element) => element['percentage'] == 100) ? 0 : 3,
                    centerSpaceRadius: 0,
                    sections: showingIncomeSections()
                  ),
                ),
              ),
              Expanded(
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
                    sectionsSpace: widget.expenses.every((element) => element['percentage'] == 0) || widget.expenses.any((element) => element['percentage'] == 100) ? 0 : 3,
                    centerSpaceRadius: 0,
                    sections: showingExpensesSections()
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            /// Display the legend
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(widget.expenses.length, (int index) {
                        return ListTile(
                          dense: true,
                          leading: Icon(Icons.brightness_1, color: getCategoryColor(index)),
                          title: Text(
                            widget.expenses[index]['name'],
                            style: TextStyle(fontSize: baseFontSize.subtitle),
                          ),
                          trailing: Wrap(
                            spacing: 12,
                            children: [
                              Transform.rotate(
                                angle: math.pi / 1.35,
                                child: Icon(Icons.undo, color: baseColors.green)
                              ),
                              Text(widget.income[index]['value'].toStringAsFixed(2)),
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Transform.rotate(
                                  angle: -math.pi / 4,
                                  child: Transform.translate(
                                    offset: Offset(0.0, -5),
                                    child: Icon(Icons.undo, color: baseColors.red)
                                  )
                                )
                              ),
                              Text(widget.expenses[index]['value'].toStringAsFixed(2))
                            ]
                          )
                        );
                      })
                    )
                  ]
                )
              )
            ]
          )
        ]
      ),
    );
  }

  /// Chart data
  List<PieChartSectionData> showingIncomeSections() {
    bool emptyIncome = widget.income.every((element) => element['percentage'] == 0);
    if (emptyIncome) {
      final double radius = MediaQuery.of(context).size.width/6;
      return [PieChartSectionData(
        color: baseColors.mainColor,
        value: 100,
        title: '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: baseFontSize.text, fontWeight: FontWeight.bold, color: Colors.white
        ),
      )];
    } else {
      return List.generate(widget.income.length, (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? baseFontSize.title2 : baseFontSize.text;
        final double radius = isTouched ? MediaQuery.of(context).size.width/6 + 10 : MediaQuery.of(context).size.width/6;
        return PieChartSectionData(
          color: getCategoryColor(i),
          value: widget.income[i]['percentage'].toDouble(),
          title: formatPercentage(widget.income[i]['percentage']),
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white
          ),
        );
      });
    }
  }

  List<PieChartSectionData> showingExpensesSections() {
    bool emptyExpenses = widget.expenses.every((element) => element['percentage'] == 0);
    if (emptyExpenses) {
      final double radius = MediaQuery.of(context).size.width/6;
      return [PieChartSectionData(
        color: baseColors.mainColor,
        value: 100,
        title: '',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: baseFontSize.text, fontWeight: FontWeight.bold, color: Colors.white
        ),
      )];
    } else {
      return List.generate(widget.expenses.length, (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? baseFontSize.title2 : baseFontSize.text;
        final double radius = isTouched ? MediaQuery.of(context).size.width/6 + 10 : MediaQuery.of(context).size.width/6;
        return PieChartSectionData(
          color: getCategoryColor(i),
          value: widget.expenses[i]['percentage'].toDouble(),
          title: formatPercentage(widget.expenses[i]['percentage']),
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white
          ),
        );
      });
    }
  }
}
