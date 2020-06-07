import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

/// Get the max value of revenue or expense in order to scale graphs.
/// The argument is a List of Map with keys 'revenue' and 'expenses'.
/// Each value is a List of double of size 5 (for the 5 categories), where
/// each element represents the sum of expense/revenue of a certain category.
double getMaxRevenueExpenses(List<Map<String, List<double>>> map) {
  var maxRevenue = map.map<double>((e) => e['revenue'].reduce((a, b) => a + b)).reduce(max);
  var maxExpenses = map.map<double>((e) => e['expenses'].reduce((a, b) => a + b)).reduce(max);
  if (maxRevenue > maxExpenses) {
    return maxRevenue;
  } else {
    return maxExpenses;
  }
}

/// Compute the y-coordinate for the given value in a bar chart.
double makeBarValue(double value, double maxValue) {
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
      'to': DateTime.now().year.toString() + '12-31'
    };
  }
}

/// Build the X-axis.
/// Used for bar charts.
String getXAxis(value, type) {
  if (type == 'Week') {
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
  } else if (type == 'Month') {
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
  } else if (type == 'Year') {
    switch (value.toInt()) {
      case 0:
        return 'JAN';
      case 1:
        return 'FEB';
      case 2:
        return 'MAR';
      case 3:
        return 'APR';
      case 4:
        return 'MAY';
      case 5:
        return 'JUN';
      case 6:
        return 'JUL';
      case 7:
        return 'AUG';
      case 8:
        return 'SEP';
      case 9:
        return 'OCT';
      case 10:
        return 'NOV';
      case 11:
        return 'DEC';
    }
  }
  return '';
}

/// Build the scale for the Y-axis.
/// Used for bar charts.
String getYAxis(value, max) {
  switch (value.toInt()) {
    case 0:
      return '0';
    case 5:
      return NumberFormat.compact().format(max * 0.25);
    case 10:
      return NumberFormat.compact().format(max * 0.5);
    case 15:
      return NumberFormat.compact().format(max * 0.75);
    case 20:
      return NumberFormat.compact().format(max);
  }
  return '';
}

// Get month name from month number
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