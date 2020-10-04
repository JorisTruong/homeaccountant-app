import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:google_fonts/google_fonts.dart';
import 'package:currency_pickers/utils/utils.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/components/pie_chart.dart';
import 'package:homeaccountantapp/components/year_picker.dart' as yp;
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/queries/accounts.dart';
import 'package:homeaccountantapp/database/queries/transactions.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the transactions page.
/// It is where all the transactions from the selected date range are displayed.
///


class TransactionsPage extends StatefulWidget {
  TransactionsPage({Key key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with TickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            _store.dispatch(NavigatePopAction());
            print(_store.state);
            return Future(() => true);
          },
          /// The GestureDetector is for removing the speed dial when tapping the screen.
          child: GestureDetector(
            onTap: () {
              if (!_controller.isDismissed) {
                _controller.reverse();
              }
            },
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: baseColors.mainColor,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                              future: Future.wait(
                                [
                                  getTotalBalance(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                                  accountFromId(databaseClient.db, _store.state.accountId)
                                ]
                              ),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  String currency = '';
                                  String firstCurrency = CurrencyPickerUtils.getCountryByIsoCode(snapshot.data[1][0].accountCountryIso).currencyCode;
                                  if (snapshot.data[1].length != 1) {
                                    List<dynamic> allSameCurrency = snapshot.data[1].map((account) => CurrencyPickerUtils.getCountryByIsoCode(account.accountCountryIso).currencyCode == firstCurrency).toList();
                                    if (allSameCurrency.contains(false)) {
                                      currency = CurrencyPickerUtils.getCountryByIsoCode(_store.state.mainCountryIso).currencyCode;
                                    } else {
                                      currency = firstCurrency;
                                    }
                                  } else {
                                    currency = firstCurrency;
                                  }
                                  return Text(
                                    snapshot.data[0].toStringAsFixed(2) + " " + currency,
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: baseFontSize.title
                                    )
                                  );
                                } else {
                                  return LoadingComponent();
                                }
                              },
                            )
                          ]
                        ),
                        SizedBox(
                          height: 6
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Balance",
                              style: GoogleFonts.lato(
                                color: baseColors.borderColor,
                                fontSize: baseFontSize.subtitle
                              )
                            )
                          ]
                        ),
                        SizedBox(
                          height: 24
                        ),
                        Flexible(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: Card(
                                            color: baseColors.tertiaryColor,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: BorderSide(color: baseColors.transparent)
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: DropdownButton<String>(
                                                    icon: Icon(Icons.keyboard_arrow_down),
                                                    value: _store.state.dateRangeType,
                                                    isDense: false,
                                                    onChanged: (String newValue) {
                                                      if (_store.state.dateRangeType != newValue) {
                                                        if (newValue == 'Day') {
                                                          showDayDatePicker(context, _store);
                                                        }
                                                        if (newValue == 'Month') {
                                                          showMonthDatePicker(context, _store);
                                                        }
                                                        if (newValue == 'Year') {
                                                          showYearDatePicker(context, _store);
                                                        }
                                                      }
                                                    },
                                                    items: [
                                                      DropdownMenuItem<String>(
                                                        value: 'Day',
                                                        child: Text('Day', style: GoogleFonts.lato(fontSize: baseFontSize.text))
                                                      ),
                                                      DropdownMenuItem<String>(
                                                        value: 'Month',
                                                        child: Text('Month', style: GoogleFonts.lato(fontSize: baseFontSize.text))
                                                      ),
                                                      DropdownMenuItem<String>(
                                                        value: 'Year',
                                                        child: Text('Year', style: GoogleFonts.lato(fontSize: baseFontSize.text))
                                                      )
                                                    ]
                                                  )
                                                ),
                                              ],
                                            )
                                          )
                                        )
                                      )
                                    )
                                  ]
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: Card(
                                            color: baseColors.tertiaryColor,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: BorderSide(color: baseColors.transparent)
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: _store.state.showTransactionDate,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      isDense: false,
                                                      alignLabelWithHint: true,
                                                      border: OutlineInputBorder(borderSide: BorderSide.none),
                                                      hintText: 'Date',
                                                      hintStyle: GoogleFonts.lato(color: baseColors.mainColor)
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                    onTap: () async {
                                                      if (_store.state.dateRangeType == 'Day') {
                                                        showDayDatePicker(context, _store);
                                                      }
                                                      if (_store.state.dateRangeType == 'Month') {
                                                        showMonthDatePicker(context, _store);
                                                      }
                                                      if (_store.state.dateRangeType == 'Year') {
                                                        showYearDatePicker(context, _store);
                                                      }
                                                    },
                                                  )
                                                )
                                              ],
                                            )
                                          )
                                        )
                                      )
                                    )
                                  ]
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: Card(
                                            color: baseColors.tertiaryColor,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: BorderSide(color: baseColors.transparent)
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: DropdownButton<String>(
                                                    icon: Icon(Icons.keyboard_arrow_down),
                                                    value: _store.state.showTransactionType,
                                                    isDense: false,
                                                    onChanged: (String newValue) {
                                                      _store.dispatch(ShowTransactionType(newValue));
                                                    },
                                                    items: [
                                                      DropdownMenuItem<String>(
                                                        value: 'All',
                                                        child: Text('All', style: GoogleFonts.lato(fontSize: baseFontSize.text))
                                                      ),
                                                      DropdownMenuItem<String>(
                                                        value: 'Expenses',
                                                        child: Text('Expenses', style: GoogleFonts.lato(fontSize: baseFontSize.text))
                                                      ),
                                                      DropdownMenuItem<String>(
                                                        value: 'Income',
                                                        child: Text('Income', style: GoogleFonts.lato(fontSize: baseFontSize.text))
                                                      )
                                                    ]
                                                  )
                                                ),
                                              ],
                                            )
                                          )
                                        )
                                      )
                                    )
                                  ]
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                    color: baseColors.mainColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)
                          ),
                        color: Colors.white
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 40),
                          /// Display all the transactions
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: Future.wait([
                                  getExpensesProportion(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                                  getIncomeProportion(databaseClient.db, _store.state.dateRange, _store.state.accountId)
                                ]),
                                builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                  if (snapshot.hasData) {
                                    return PieChartCard(
                                      expenses: snapshot.data[0],
                                      income: snapshot.data[1],
                                      store: _store
                                    );
                                  } else {
                                    return LoadingComponent();
                                  }
                                }
                              ),
                            ]
                          )
                        )
                      )
                    )
                  )
                ]
              )
            )
          )
        );
      }
    );
  }
}

Future<dynamic> showDayDatePicker(BuildContext context, Store<AppState> _store) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: dp.DayPicker(
          selectedDate: _store.state.selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          datePickerLayoutSettings: dp.DatePickerLayoutSettings(
            maxDayPickerRowCount: 4
          ),
          onChanged: (datePeriod) {
            _store.dispatch(UpdateSelectedDate(datePeriod));
            _store.dispatch(
              UpdateDateRange(
                dateToDateRange(
                  'Day',
                  _store.state.selectedDate
                )
              )
            );
            TextEditingController showTransactionDate = TextEditingController();
            showTransactionDate.text = datePeriod.toString().substring(0, 10);
            _store.dispatch(ShowTransactionDate(showTransactionDate));
            _store.dispatch(UpdateDateRangeType('Day'));
            Navigator.of(context).pop();
          },
        ),
      );
    }
  );
}

Future<dynamic> showMonthDatePicker(BuildContext context, Store<AppState> _store) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: dp.MonthPicker(
          selectedDate: _store.state.selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          datePickerLayoutSettings: dp.DatePickerLayoutSettings(
            maxDayPickerRowCount: 4
          ),
          onChanged: (datePeriod) {
            _store.dispatch(UpdateSelectedDate(datePeriod));
            _store.dispatch(
              UpdateDateRange(
                dateToDateRange(
                  'Month',
                  _store.state.selectedDate
                )
              )
            );
            TextEditingController showTransactionDate = TextEditingController();
            showTransactionDate.text = datePeriod.toString().substring(0, 7);
            _store.dispatch(ShowTransactionDate(showTransactionDate));
            _store.dispatch(UpdateDateRangeType('Month'));
            Navigator.of(context).pop();
          },
        ),
      );
    }
  );
}

Future<dynamic> showYearDatePicker(BuildContext context, Store<AppState> _store) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Material(
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
                _store.dispatch(
                  UpdateDateRange(
                    dateToDateRange(
                      'Year',
                      _store.state.selectedDate
                    )
                  )
                );
                TextEditingController showTransactionDate = TextEditingController();
                showTransactionDate.text = datePeriod.toString().substring(0, 4);
                _store.dispatch(ShowTransactionDate(showTransactionDate));
                _store.dispatch(UpdateDateRangeType('Year'));
                Navigator.of(context).pop();
              },
            )
          )
        )
      );
    }
  );
}