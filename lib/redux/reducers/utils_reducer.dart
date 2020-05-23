import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final visibilityReducer = TypedReducer<bool, ChangeVisibility>(_visibilityReducer);
final isCreatingReducer = TypedReducer<bool, IsCreating>(_isCreatingReducer);

bool _visibilityReducer(bool visibility, ChangeVisibility action) {
  return action.visibility;
}

bool _isCreatingReducer(bool isCreating, IsCreating action) {
  return action.isCreating;
}