import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final categoryReducer = TypedReducer<int, SelectCategory>(_selectCategory);
final subcategoryReducer = TypedReducer<Map<String, dynamic>, SelectSubcategory>(_selectSubcategory);
final categorySubcategoryTextReducer = TypedReducer<TextEditingController, CategorySubcategoryText>(_subcategoryText);
final categorySubcategoryIconReducer = TypedReducer<Icon, CategorySelectSubcategoryIcon>(_subcategoryIcon);


int _selectCategory(int categoryIndex, SelectCategory action) {
  return action.categoryIndex;
}

Map<String, dynamic> _selectSubcategory(Map<String, dynamic> subcategory, SelectSubcategory action) {
  return action.subcategory;
}

TextEditingController _subcategoryText(TextEditingController subcategory, CategorySubcategoryText action) {
  return action.subcategory;
}

Icon _subcategoryIcon(Icon subcategoryIcon, CategorySelectSubcategoryIcon action) {
  return action.subcategoryIcon;
}