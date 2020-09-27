import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';

import 'package:homeaccountantapp/main.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/app_state.dart';

List<Middleware<AppState>> createNavigationMiddleware(Persistor<AppState> persistor) {
  return [
    TypedMiddleware<AppState, NavigateReplaceAction>(_navigateReplace),
    TypedMiddleware<AppState, NavigatePushAction>(_navigate),
    persistor.createMiddleware()
  ];
}

_navigateReplace(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as NavigateReplaceAction).routeName;
  if (store.state.route.last != routeName) {
    navigatorKey.currentState.pushReplacementNamed(routeName);
  }
  next(action); //This need to be after name checks
}

_navigate(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as NavigatePushAction).routeName;
  navigatorKey.currentState.pushNamed(routeName);
  next(action); //This need to be after name checks
}