import 'package:flutter/material.dart';

class ChangeAccount {
  final String account;

  ChangeAccount(this.account);
}

class UpdateDateRange {
  final String dateRange;

  UpdateDateRange(this.dateRange);
}

class SelectCategory {
  final int categoryIndex;

  SelectCategory(this.categoryIndex);
}

class SelectSubcategory {
  final Map<String, dynamic> subcategory;

  SelectSubcategory(this.subcategory);
}

class SelectSubcategoryText {
  final TextEditingController subcategory;

  SelectSubcategoryText(this.subcategory);
}

class SelectSubcategoryIcon {
  final Icon subcategoryIcon;

  SelectSubcategoryIcon(this.subcategoryIcon);
}

class NavigateReplaceAction {
  final String routeName;

  NavigateReplaceAction(this.routeName);
}

class NavigatePushAction {
  final String routeName;

  NavigatePushAction(this.routeName);
}

class NavigatePopAction {

}