import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:math';

import 'const.dart';
import 'package:homeaccountantapp/redux/models/models.dart';

///
/// Various utility functions are defined here.
/// 


/// Retrieve the redux store from the context.
Store<AppState> getStore(BuildContext context) {
  return StoreProvider.of<AppState>(context);
}

/// Simulate a bool with 3 values.
/// Notably used for changing graphs/charts.
int switchFlag(int flag, int max) {
  if (flag == max-1) {
    return 0;
  } else {
    var newFlag = flag+1;
    return newFlag;
  }
}

/// Get the max value of income or expense in order to scale graphs.
/// The argument is a List of Map with keys 'income' and 'expenses'.
/// Each value is a double.
double getMaxIncomeExpenses(List<Map<String, dynamic>> map) {
  var maxIncome = map.map<double>((e) => e['income']).reduce(max);
  var maxExpenses = map.map<double>((e) => e['expenses']).reduce(max);
  if (maxIncome > maxExpenses) {
    return maxIncome;
  } else {
    return maxExpenses;
  }
}

/// Compute the y-coordinate for the given value in a bar chart.
double makeBarValue(double value, double maxValue) {
  if (maxValue == 0) {
    return 0;
  }
  return value * 20 / maxValue;
}

/// Retrieve the true value from the given y-coordinate in a bar chart.
double valueFromBar(double barValue, double maxValue) {
  return double.parse((barValue * maxValue / 20).toStringAsFixed(2));
}

/// Retrieve the color assigned to the given category index.
Color getCategoryColor(int index) {
  switch (index) {
    case 0:
      return baseColors.category1;
    case 1:
      return baseColors.category2;
    case 2:
      return baseColors.category3;
    case 3:
      return baseColors.category4;
    case 4:
      return baseColors.category5;
    default:
      return baseColors.mainColor;
  }
}

/// Add a '0' in front of a day or month number when necessary.
String dayOrMonthToString(int month) {
  if (month < 10) {
    return '0' + month.toString();
  } else {
    return month.toString();
  }
}

/// Format a date range object from date range selection.
Map<String, String> dateToDateRange(String type, DateTime dateTime) {
  if (type == 'Year') {
    return {
      'from': dateTime.year.toString() + '-01-01',
      'to': dateTime.year.toString() + '-12-31'
    };
  }
  else if (type == 'Month') {
    var endDate = DateTime(dateTime.year, dateTime.month+1, 0);
    return {
      'from': dateTime.year.toString() + '-' + dayOrMonthToString(dateTime.month) + '-01',
      'to': endDate.year.toString() + '-' + dayOrMonthToString(endDate.month) + '-' + dayOrMonthToString(endDate.day)
    };
  }
  else if (type == 'Week') {
    var startDate = dateTime.subtract(Duration(days: dateTime.weekday-1));
    var endDate = dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    return {
      'from': startDate.year.toString() + '-' + dayOrMonthToString(startDate.month) + '-' + dayOrMonthToString(startDate.day),
      'to': endDate.year.toString() + '-' + dayOrMonthToString(endDate.month) + '-' + dayOrMonthToString(endDate.day)
    };
  }
  else {
    return {
      'from': DateTime.now().year.toString() + '-01-01',
      'to': DateTime.now().year.toString() + '-12-31'
    };
  }
}

/// Get month name from month number
String getMonth(String month) {
  switch (month) {
    case '01':
      return 'January';
    case '02':
      return 'February';
    case '03':
      return 'March';
    case '04':
      return 'April';
    case '05':
      return 'May';
    case '06':
      return 'June';
    case '07':
      return 'July';
    case '08':
      return 'August';
    case '09':
      return 'September';
    case '10':
      return 'October';
    case '11':
      return 'November';
    case '12':
      return 'December';
  }
  return '';
}

/// Get a dictionary with 'year', 'month' and 'day' keys from a date string
Map<String, int> getDateFromString(String date) {
  List<String> _date = date.split('-');
  int year = int.parse(_date[0]);
  int month = int.parse(_date[1]);
  int day = int.parse(_date[2]);
  return {
    'year': year,
    'month': month,
    'day': day
  };
}

/// Utils function to not display pie chart percentage when it is 0
String formatPercentage(double percentage) {
  if (percentage == 0) {
    return '';
  } else {
    return percentage.toStringAsFixed(0) + '%';
  }
}

/// Returns the cumulative sum of a list
List<double> cumulativeSum(List<double> data) {
  List<double> cumulativeSumData = [];
  for (int i = 0; i < data.length; i++) {
    if (i == 0) {
      cumulativeSumData.add(data[0]);
    } else {
      cumulativeSumData.add(cumulativeSumData[i-1] + data[i]);
    }
  }
  return cumulativeSumData;
}