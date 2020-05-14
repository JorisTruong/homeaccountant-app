import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final String account;
  final int categoryIndex;
  final Map<String, dynamic> subcategory;
  final TextEditingController subcategoryText;
  final Icon subcategoryIcon;
  final String dateRange;
  final List<String> route;

  const AppState({
    @required this.account,
    this.categoryIndex,
    this.subcategory,
    this.subcategoryText,
    this.subcategoryIcon,
    @required this.dateRange,
    @required this.route
  });

  @override
  String toString() {
    return 'AppState: {account: $account, categoryIndex: $categoryIndex, subcategory: $subcategory, dateRange: $dateRange, route: $route}';
  }
}