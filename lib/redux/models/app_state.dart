import 'package:meta/meta.dart';

@immutable
class AppState {
  final String dateRange;

  const AppState({
    @required this.dateRange
  });

  @override
  String toString() {
    return 'AppState: {dateRange: $dateRange}';
  }
}