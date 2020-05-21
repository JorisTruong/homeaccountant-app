import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final navigationReducer = combineReducers<List<String>>(
  [
    TypedReducer<List<String>, NavigateReplaceAction>(_navigateReplace),
    TypedReducer<List<String>, NavigatePushAction>(_navigatePush),
    TypedReducer<List<String>, NavigatePopAction>(_navigatePop)
  ]
);

List<String> _navigateReplace(
  List<String> route,
  NavigateReplaceAction action) {
  return [action.routeName];
}

List<String> _navigatePush(
  List<String> route,
  NavigatePushAction action) {
  List<String> result = List<String>.from(route);
  if (action.routeName != result.last) {
    result.add(action.routeName);
  }
  return result;
}

List<String> _navigatePop(
  List<String> route,
  NavigatePopAction action) {
  List<String> result = List<String>.from(route);
  if (result.isNotEmpty) {
    result.removeLast();
  }
  return result;
}