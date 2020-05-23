import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final categoryReducer = TypedReducer<int, SelectCategory>(_selectCategory);
final categorySubcategoryTextReducer = TypedReducer<TextEditingController, CategorySubcategoryText>(_subcategoryText);
final categorySubcategoryIconReducer = TypedReducer<Icon, CategorySelectSubcategoryIcon>(_subcategoryIcon);


int _selectCategory(int categoryIndex, SelectCategory action) {
  return action.categoryIndex;
}

TextEditingController _subcategoryText(TextEditingController subcategory, CategorySubcategoryText action) {
  return action.subcategory;
}

Icon _subcategoryIcon(Icon subcategoryIcon, CategorySelectSubcategoryIcon action) {
  return action.subcategoryIcon;
}