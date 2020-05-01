import 'dart:math';


int switchFlag(int flag, int max) {
  if (flag == max-1) {
    return 0;
  } else {
    var newFlag = flag+1;
    return newFlag;
  }
}

double getMaxRevenueExpenses(List<Map<String, double>> map) {
  var maxRevenue = map.map<double>((e) => e['revenue']).reduce(max);
  var maxExpenses = map.map<double>((e) => e['expenses']).reduce(max);
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
  return barValue * maxValue / 20;
}