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