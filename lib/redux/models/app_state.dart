import 'package:meta/meta.dart';

@immutable
class AppState {
  final String dateRange;
  final List<String> route;

  const AppState({
    @required this.dateRange,
    @required this.route
  });

  @override
  String toString() {
    return 'AppState: {dateRange: $dateRange, route: $route}';
  }
}