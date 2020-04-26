import 'package:meta/meta.dart';

@immutable
class AppState {
  final String account;
  final String dateRange;
  final List<String> route;

  const AppState({
    @required this.account,
    @required this.dateRange,
    @required this.route
  });

  @override
  String toString() {
    return 'AppState: {account: $account, dateRange: $dateRange, route: $route}';
  }
}