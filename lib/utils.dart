import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'const.dart';
import 'package:homeaccountantapp/redux/models/models.dart';

///
/// Various utility functions are defined here.
/// 


/// Retrieve the redux store from the context.
Store<AppState> getStore(BuildContext context) {
  return StoreProvider.of<AppState>(context);
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
    case 5:
      return baseColors.category6;
    case 6:
      return baseColors.category7;
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
  else if (type == 'Day') {
    return {
      'from': dateTime.toString().substring(0, 10),
      'to': dateTime.toString().substring(0, 10)
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

/// Utils function to not display pie chart percentage when it is 0
String formatPercentage(double percentage) {
  if (percentage == 0) {
    return '';
  } else {
    return percentage.toStringAsFixed(0) + '%';
  }
}
