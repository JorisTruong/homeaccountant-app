import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final categoryReducer = TypedReducer<int, SelectCategory>(_selectCategory);
final subcategoryReducer = TypedReducer<Map<String, dynamic>, SelectSubcategory>(_selectSubcategory);
final subcategoryTextReducer = TypedReducer<TextEditingController, SelectSubcategoryText>(_subcategoryText);
final subcategoryIconReducer = TypedReducer<Icon, SelectSubcategoryIcon>(_subcategoryIcon);


int _selectCategory(int categoryIndex, SelectCategory action) {
  return action.categoryIndex;
}

Map<String, dynamic> _selectSubcategory(Map<String, dynamic> subcategory, SelectSubcategory action) {
  return action.subcategory;
}

TextEditingController _subcategoryText(TextEditingController subcategory, SelectSubcategoryText action) {
  return action.subcategory;
}

Icon _subcategoryIcon(Icon subcategoryIcon, SelectSubcategoryIcon action) {
  return action.subcategoryIcon;
}