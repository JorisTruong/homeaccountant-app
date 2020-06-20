import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:homeaccountantapp/const.dart';


///
/// This is the Year Picker widget.
/// It is heavily inspired on the original deprecated YearPicker of Flutter.
/// There are just small modifications on the style.
///


class YearPicker extends StatefulWidget {
  YearPicker({
    Key key,
    @required this.selectedDate,
    @required this.onChanged,
    @required this.firstDate,
    @required this.lastDate,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : assert(selectedDate != null),
        assert(onChanged != null),
        assert(!firstDate.isAfter(lastDate)),
        super(key: key);

  final DateTime selectedDate;

  final ValueChanged<DateTime> onChanged;

  final DateTime firstDate;

  final DateTime lastDate;

  final DragStartBehavior dragStartBehavior;

  @override
  _YearPickerState createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  static double _itemExtent = 50.0;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(
      initialScrollOffset: (widget.selectedDate.year - widget.firstDate.year) * _itemExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData themeData = Theme.of(context);
    final TextStyle style = themeData.textTheme.bodyText2;
    return ListView.builder(
      dragStartBehavior: widget.dragStartBehavior,
      controller: scrollController,
      itemExtent: _itemExtent,
      itemCount: widget.lastDate.year - widget.firstDate.year + 1,
      itemBuilder: (BuildContext context, int index) {
        final int year = widget.firstDate.year + index;
        final bool isSelected = year == widget.selectedDate.year;
        return InkWell(
          key: ValueKey<int>(year),
          onTap: () {
            widget.onChanged(DateTime(year, widget.selectedDate.month, widget.selectedDate.day));
          },
          child: Center(
            child: Semantics(
              selected: isSelected,
              child: isSelected ?
                RaisedButton(
                  onPressed: () {},
                  child: Text(
                    year.toString(),
                    style: TextStyle(
                      fontSize: baseFontSize.bigTitle,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  color: baseColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ) : Text(year.toString(), style: style),
            ),
          ),
        );
      },
    );
  }
}
