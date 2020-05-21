import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'dart:math' as math;

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';

import 'categories.dart';


final accounts = [
  {'id': 0, 'name': 'Account 1'},
  {'id': 1, 'name': 'Account 2'},
  {'id': 2, 'name': 'Account 3'},
  {'id': 3, 'name': 'Account 4'},
  {'id': 4, 'name': 'Account 5'}
];

class TransactionInfoPage extends StatefulWidget {
  TransactionInfoPage({Key key}) : super(key: key);

  @override
  _TransactionInfoPageState createState() => _TransactionInfoPageState();
}

class _TransactionInfoPageState extends State<TransactionInfoPage> with TickerProviderStateMixin {
  FocusScopeNode currentFocus;

  void resetSubcategory(Store<AppState> _store) {
    _store.dispatch(SelectSubcategoryIcon(null));
    _store.dispatch(SubcategoryText(TextEditingController()));
    _store.dispatch(SelectSubcategory(null));
  }

  void leaveScreen(Store<AppState> _store) {
    _store.dispatch(NavigatePopAction());
    _store.dispatch(SelectCategory(null));
    _store.dispatch(TransactionName(TextEditingController()));
    _store.dispatch(TransactionAccount(null));
    _store.dispatch(TransactionDate(TextEditingController()));
    _store.dispatch(TransactionAmount(TextEditingController()));
    _store.dispatch(TransactionDescription(TextEditingController()));
    resetSubcategory(_store);
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);
    currentFocus = FocusScope.of(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            leaveScreen(_store);
            print(_store.state);
            return Future(() => true);
          },
          child: GestureDetector(
            onTap: () {
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    leaveScreen(_store);
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  'Transaction Info',
                  style: TextStyle(
                    fontSize: baseFontSize.title
                  ),
                ),
                centerTitle: true,
                actions: <Widget>[
                ],
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 20.0,
                            left: 20.0,
                            right: 20.0,
                            bottom: 20.0 + MediaQuery.of(context).viewInsets.bottom
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[500],
                                    blurRadius: 10.0,
                                    offset: Offset(
                                      0.0,
                                      5.0,
                                    ),
                                  ),
                                ],
                                color: Colors.white
                              ),
                              child: KeyboardAvoider(
                                autoScroll: true,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: LayoutBuilder(
                                    builder: (containerContext, containerConstraints) {
                                      return Column(
                                        children: [
                                          TextField(
                                            controller: _store.state.transactionName,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                              contentPadding: EdgeInsets.only(right: 20.0),
                                              labelText: 'Name',
                                              prefixIcon: Icon(Icons.title, color: baseColors.mainColor)
                                            ),
                                          ),
                                          SizedBox(height: 12.0),
                                          DropdownButtonHideUnderline(
                                            child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: Card(
                                                margin: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40.0),
                                                  side: BorderSide(color: baseColors.borderColor)
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 15.0),
                                                    Icon(Icons.account_box, size: 18.0),
                                                    Expanded(
                                                      child: DropdownButton<int>(
                                                        autofocus: true,
                                                        icon: Icon(Icons.keyboard_arrow_down),
                                                        value: _store.state.transactionAccountId,
                                                        hint: Text(
                                                          'Account',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: baseColors.secondaryColor)
                                                        ),
                                                        isDense: false,
                                                        onTap: () {
                                                          if (!currentFocus.hasPrimaryFocus) {
                                                            currentFocus.unfocus();
                                                          }
                                                        },
                                                        onChanged: (int newValue) {
                                                          setState(() {
                                                            _store.dispatch(TransactionAccount(newValue));
                                                          });
                                                        },
                                                        items: accounts.map((key) {
                                                          return DropdownMenuItem<int>(
                                                            value: key['id'],
                                                            child: Text(key['name']),
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
                                          SizedBox(height: 12.0),
                                          Theme(
                                            data: ThemeData(
                                              primaryColor: baseColors.mainColor,
                                              colorScheme: ColorScheme.light(primary: baseColors.mainColor, ),
                                            ),
                                            child: Builder(
                                              builder: (context) =>
                                                TextField(
                                                  readOnly: true,
                                                  controller: _store.state.transactionDate,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    alignLabelWithHint: true,
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                                    contentPadding: EdgeInsets.only(right: 20.0),
                                                    labelText: 'Date',
                                                    prefixIcon: Icon(Icons.date_range, color: baseColors.mainColor)
                                                  ),
                                                  onTap: () async {
                                                    final DateTime pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime.now(),
                                                    );
                                                    if (pickedDate != null) {
                                                      TextEditingController date = TextEditingController();
                                                      date.text = pickedDate.toString().split(' ')[0];
                                                      _store.dispatch(TransactionDate(date));
                                                    }
                                                  },
                                                )
                                            )
                                          ),
                                          SizedBox(height: 12.0,),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue: _store.state.transactionIsExpense,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _store.dispatch(TransactionIsExpense(value));
                                                  });
                                                }
                                              ),
                                              Text('Expense'),
                                              Radio(
                                                value: false,
                                                groupValue: _store.state.transactionIsExpense,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _store.dispatch(TransactionIsExpense(value));
                                                  });
                                                }
                                              ),
                                              Text('Revenue')
                                            ],
                                          ),
                                          SizedBox(height: 12.0),
                                          DropdownButtonHideUnderline(
                                            child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: Card(
                                                margin: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40.0),
                                                  side: BorderSide(color: baseColors.borderColor)
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 15.0),
                                                    Icon(Icons.label, size: 18.0),
                                                    Expanded(
                                                      child: DropdownButton<int>(
                                                        icon: Icon(Icons.keyboard_arrow_down),
                                                        value: _store.state.categoryIndex,
                                                        hint: Text(
                                                          'Category',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: baseColors.secondaryColor)
                                                        ),
                                                        isDense: false,
                                                        onTap: () {
                                                          if (!currentFocus.hasPrimaryFocus) {
                                                            currentFocus.unfocus();
                                                          }
                                                        },
                                                        onChanged: (int newValue) {
                                                          setState(() {
                                                            resetSubcategory(_store);
                                                            _store.dispatch(SelectCategory(newValue));
                                                          });
                                                        },
                                                        items: List.generate(categories.length, (int index) {
                                                          return DropdownMenuItem<int>(
                                                            value: index,
                                                            child: Text(categories.keys.toList()[index])
                                                          );
                                                        })
                                                      ),
                                                    ),
                                                    SizedBox(width: 15.0)
                                                  ],
                                                )
                                              )
                                            )
                                          ),
                                          SizedBox(height: 12.0,),
                                          TextField(
                                            readOnly: true,
                                            controller: _store.state.subcategoryText,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                              contentPadding: EdgeInsets.only(right: 20.0),
                                              labelText: 'Subcategory',
                                              prefixIcon: _store.state.subcategoryIcon == null ?
                                                Icon(
                                                  Icons.turned_in,
                                                  color: baseColors.mainColor
                                                ) :
                                                _store.state.subcategoryIcon,
                                            ),
                                            onTap: () {
                                              if (!currentFocus.hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                              if (_store.state.categoryIndex != null) {
                                                _store.dispatch(NavigatePushAction(AppRoutes.subcategory));
                                              }
                                            },
                                          ),
                                          SizedBox(height: 12.0,),
                                          TextField(
                                            inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            controller: _store.state.transactionAmount,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                              contentPadding: EdgeInsets.only(right: 20.0),
                                              labelText: 'Amount',
                                              prefixIcon: Icon(Icons.attach_money, color: baseColors.mainColor)
                                            ),
                                          ),
                                          SizedBox(height: 12.0,),
                                          TextField(
                                            controller: _store.state.transactionDescription,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                              contentPadding: EdgeInsets.only(right: 20.0),
                                              labelText: 'Description',
                                              prefixIcon: Icon(Icons.create, color: baseColors.mainColor)
                                            ),
                                          ),
                                          SizedBox(height: 24.0,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                onPressed: () {
                                                  leaveScreen(_store);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
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
                                                  print(_store.state.transactionName.text);
                                                  print(_store.state.transactionAccountId);
                                                  print(_store.state.transactionDate.text);
                                                  print(_store.state.transactionIsExpense);
                                                  print(_store.state.categoryIndex);
                                                  print(_store.state.subcategoryText.text);
                                                  print(_store.state.transactionAmount.text);
                                                  print(_store.state.transactionDescription.text);
                                                  leaveScreen(_store);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'VALIDATE',
                                                  style: TextStyle(
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
                                        ],
                                      );
                                    }
                                  )
                                )
                              )
                            )
                          )
                        ),
                      )
                    )
                  );
                }
              )
            )
          )
        );
      }
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains('-') || value.contains(',')) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }

      if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}