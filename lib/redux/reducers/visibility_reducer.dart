import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final visibilityReducer = TypedReducer<bool, ChangeVisibility>(_visibilityReducer);

bool _visibilityReducer(bool visibility, ChangeVisibility action) {
  return action.visibility;
}