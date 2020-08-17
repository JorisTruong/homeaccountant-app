import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:google_fonts/google_fonts.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/year_picker.dart' as yp;
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the Date Range Panel widget.
/// It is displayed when selecting date range from the speed dial.
///


List<String> dateRangeTypes = ['Year', 'Month', 'Week'];

class DateRangePanel extends StatefulWidget {
  final PanelController _pcDate;

  DateRangePanel(this._pcDate);

  @override
  _DateRangePanelState createState() => _DateRangePanelState();
}

class _DateRangePanelState extends State<DateRangePanel> with TickerProviderStateMixin {
  FocusScopeNode currentFocus;

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);
    currentFocus = FocusScope.of(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return SingleChildScrollView(
          child: Padding (
            padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 50),
            child: Column(
              children: [
                /// Dropdown to select the date range type
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: Card(
                      margin: EdgeInsets.only(bottom: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side: BorderSide(color: baseColors.borderColor)
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 15.0),
                          Icon(Icons.timeline, size: 18.0),
                          Expanded(
                            child: DropdownButton<String>(
                              autofocus: true,
                              icon: Icon(Icons.keyboard_arrow_down),
                              value: _store.state.dateRangeType,
                              hint: Text(
                                'Type',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(color: baseColors.secondaryColor)
                              ),
                              isDense: false,
                              onTap: () {
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              onChanged: (String newValue) {
                                _store.dispatch(UpdateDateRangeType(newValue));
                              },
                              items: dateRangeTypes.map((key) {
                                return DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(key),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: 15.0)
                        ],
                      )
                    )
                  )
                ),
                /// Conditional rendering of a calendar, depending on the range type
                if (_store.state.dateRangeType == 'Year')
                  Material(
                    color: baseColors.transparent,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 20),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: yp.YearPicker(
                        selectedDate: _store.state.selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        onChanged: (datePeriod) {
                          _store.dispatch(UpdateSelectedDate(datePeriod));
                        },
                      )
                    )
                  ),
                if (_store.state.dateRangeType == 'Month')
                  dp.MonthPicker(
                    selectedDate: _store.state.selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    onChanged: (datePeriod) {
                      _store.dispatch(UpdateSelectedDate(datePeriod));
                    },
                  ),
                if (_store.state.dateRangeType == 'Week')
                  dp.WeekPicker(
                    selectedDate: _store.state.selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    onChanged: (datePeriod) {
                      _store.dispatch(UpdateSelectedDate(datePeriod.start));
                    },
                  ),
                /// Validate and cancel the operation
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        widget._pcDate.close();
                      },
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.lato(
                          fontSize: baseFontSize.text,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        )
                      ),
                      color: baseColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    RaisedButton(
                      onPressed: () {
                        print(
                          dateToDateRange(
                            _store.state.dateRangeType,
                            _store.state.selectedDate
                          )
                        );
                        _store.dispatch(
                          UpdateDateRange(
                            dateToDateRange(
                              _store.state.dateRangeType,
                              _store.state.selectedDate
                            )
                          )
                        );
                        widget._pcDate.close();
                      },
                      child: Text(
                        'VALIDATE',
                        style: GoogleFonts.lato(
                          fontSize: baseFontSize.text,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        )
                      ),
                      color: baseColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                  ],
                )
              ]
            )
          )
        );
      }
    );
  }
}
