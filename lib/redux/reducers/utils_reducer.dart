import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final isCreatingAccountReducer = TypedReducer<bool, IsCreatingAccount>(_isCreatingAccountReducer);
final isCreatingTransactionReducer = TypedReducer<bool, IsCreatingTransaction>(_isCreatingTransactionReducer);
final isCreatingSubcategoryReducer = TypedReducer<bool, IsCreatingSubcategory>(_isCreatingSubcategoryReducer);
final isSelectingSubcategoryReducer = TypedReducer<bool, IsSelectingSubcategory>(_isSelectingSubcategoryReducer);

bool _isCreatingAccountReducer(bool isCreating, IsCreatingAccount action) {
  return action.isCreatingAccount;
}

bool _isCreatingTransactionReducer(bool isCreating, IsCreatingTransaction action) {
  return action.isCreatingTransaction;
}

bool _isCreatingSubcategoryReducer(bool isCreating, IsCreatingSubcategory action) {
  return action.isCreatingSubcategory;
}

bool _isSelectingSubcategoryReducer(bool isSelectingSubcategory, IsSelectingSubcategory action) {
  return action.isSelectingSubcategory;
}