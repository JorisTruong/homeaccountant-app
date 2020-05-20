import 'package:flutter/material.dart';
import 'dart:math';

import 'const.dart';

int switchFlag(int flag, int max) {
  if (flag == max-1) {
    return 0;
  } else {
    var newFlag = flag+1;
    return newFlag;
  }
}

double getMaxRevenueExpenses(List<Map<String, List<double>>> map) {
  var maxRevenue = map.map<double>((e) => e['revenue'].reduce((a, b) => a + b)).reduce(max);
  var maxExpenses = map.map<double>((e) => e['expenses'].reduce((a, b) => a + b)).reduce(max);
  if (maxRevenue > maxExpenses) {
    return maxRevenue;
  } else {
    return maxExpenses;
  }
}

double makeBarValue(double value, double maxValue) {
  return value * 20 / maxValue;
}

double valueFromBar(double barValue, double maxValue) {
  return double.parse((barValue * maxValue / 20).toStringAsFixed(2));
}

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

Map<String, dynamic> findSubcategoryFromId(int subcategoryId, Map<String, List<dynamic>> categories) {
  for(final category in categories.keys.toList()) {
    for(final subcategory in categories[category]) {
      if (subcategory['id'] == subcategoryId) {
        return subcategory;
      }
    }
  }
}

String findAccountFromId(int accountId, List<Map<String, dynamic>> accounts) {
  for(final account in accounts) {
    if (account['id'] == accountId) {
      return account['name'];
    }
  }
}

String DayOrMonthToString(int month) {
  if (month < 10) {
    return '0' + month.toString();
  } else {
    return month.toString();
  }
}

Map<String, String> datetoDateRange(String type, DateTime dateTime) {
  if (type == 'Year') {
    return {
      'from': dateTime.year.toString() + '-01-01',
      'to': dateTime.year.toString() + '-12-31'
    };
  }
  else if (type == 'Month') {
    var endDate = DateTime(dateTime.year, dateTime.month+1, 0);
    return {
      'from': dateTime.year.toString() + '-' + DayOrMonthToString(dateTime.month) + '-01',
      'to': endDate.year.toString() + '-' + DayOrMonthToString(endDate.month) + '-' + DayOrMonthToString(endDate.day)
    };
  }
  else if (type == 'Week') {
    var startDate = dateTime.subtract(Duration(days: dateTime.weekday-1));
    var endDate = dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    return {
      'from': startDate.year.toString() + '-' + DayOrMonthToString(startDate.month) + '-' + DayOrMonthToString(startDate.day),
      'to': endDate.year.toString() + '-' + DayOrMonthToString(endDate.month) + '-' + DayOrMonthToString(endDate.day)
    };
  }
  else {
    return {
      'from': DateTime.now().year.toString() + '-01-01',
      'to': DateTime.now().year.toString() + '12-31'
    };
  }
}