import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:homeaccountantapp/redux/models/app_state.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class RouteAwareWidget extends StatefulWidget {
  final Widget child;

  RouteAwareWidget({this.child});

  State<RouteAwareWidget> createState() => RouteAwareWidgetState(child: child);
}

class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  final Widget child;

  RouteAwareWidgetState({this.child});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {

  }

  @override
  void didPopNext() {
    print("pop");
    print(StoreProvider.of<AppState>(context).state);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: child);
  }
}