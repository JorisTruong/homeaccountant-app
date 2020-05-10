import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'dart:math' as math;

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';

import 'categories.dart';


final accounts = [
  'Account 1',
  'Account 2',
  'Account 3',
  'Account 4',
  'Account 5'
];

class TransactionInfoPage extends StatefulWidget {
  TransactionInfoPage({Key key}) : super(key: key);

  @override
  _TransactionInfoPageState createState() => _TransactionInfoPageState();
}

class _TransactionInfoPageState extends State<TransactionInfoPage> with TickerProviderStateMixin {
  FocusScopeNode currentFocus;
  TextEditingController _nameController;
  TextEditingController _amountController;
  TextEditingController _descriptionController;
  TextEditingController _dateController;
  String accountValue;
  String categoryValue;
  String subcategoryValue;
  bool isExpense;

  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    _dateController = TextEditingController();
  }

  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentFocus = FocusScope.of(context);

    return new StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
            print(StoreProvider.of<AppState>(context).state);
            return new Future(() => true);
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
                    StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
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
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10)),
                                boxShadow: [
                                  new BoxShadow(
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
                                            controller: _nameController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                              contentPadding: EdgeInsets.only(right: 20.0),
                                              labelText: 'Name',
                                              prefixIcon: Icon(Icons.title, color: baseColors.mainColor)
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12.0,
                                          ),
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
                                                      child: DropdownButton<String>(
                                                        autofocus: true,
                                                        icon: Icon(Icons.keyboard_arrow_down),
                                                        value: accountValue,
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
                                                        onChanged: (String newValue) {
                                                          setState(() {
                                                            accountValue = newValue;
                                                          });
                                                        },
                                                        items: accounts.map((key){
                                                          return DropdownMenuItem<String>(
                                                            value: key.toString(),
                                                            child: Text(key.toString()),
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
                                          SizedBox(
                                            height: 12.0,
                                          ),
                                          Theme(
                                            data: ThemeData(
                                              primaryColor: baseColors.mainColor,
                                              colorScheme: ColorScheme.light(primary: baseColors.mainColor, ),
                                            ),
                                            child: Builder(
                                              builder: (context) =>
                                                TextField(
                                                  readOnly: true,
                                                  controller: _dateController,
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
                                                      _dateController.text = pickedDate.toString().split(' ')[0];
                                                    }
                                                  },
                                                )
                                            )
                                          ),
                                          SizedBox(
                                            height: 12.0,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue: isExpense,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    isExpense = value;
                                                  });
                                                }
                                              ),
                                              Text('Expense'),
                                              Radio(
                                                  value: false,
                                                  groupValue: isExpense,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      isExpense = value;
                                                    });
                                                  }
                                              ),
                                              Text('Revenue')
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.0,
                                          ),
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
                                                      child: DropdownButton<String>(
                                                        icon: Icon(Icons.keyboard_arrow_down),
                                                        value: categoryValue,
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
                                                        onChanged: (String newValue) {
                                                          setState(() {
                                                            subcategoryValue = null;
                                                            categoryValue = newValue;
                                                          });
                                                        },
                                                        items: categories.keys.map((key){
                                                          return DropdownMenuItem<String>(
                                                            value: key.toString(),
                                                            child: Text(key.toString()),
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
                                          SizedBox(
                                            height: 12.0,
                                          ),
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
                                                    Icon(Icons.turned_in, size: 18.0),
                                                    Expanded(
                                                      child: DropdownButton<String>(
                                                        icon: Icon(Icons.keyboard_arrow_down),
                                                        value: subcategoryValue,
                                                        hint: Text(
                                                          'Subcategory',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: baseColors.secondaryColor)
                                                        ),
                                                        isDense: false,
                                                        onTap: () {
                                                          if (!currentFocus.hasPrimaryFocus) {
                                                            currentFocus.unfocus();
                                                          }
                                                        },
                                                        onChanged: (String newValue) {
                                                          setState(() {
                                                            subcategoryValue = newValue;
                                                          });
                                                        },
                                                        items: categoryValue == null ? null :
                                                          categories[categoryValue].map((key) {
                                                            return DropdownMenuItem<String>(
                                                              value: key['name'],
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
                                          SizedBox(
                                            height: 12.0,
                                          ),
                                          TextField(
                                            inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            controller: _amountController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                              contentPadding: EdgeInsets.only(right: 20.0),
                                              labelText: 'Amount',
                                              prefixIcon: Icon(Icons.attach_money, color: baseColors.mainColor)
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12.0,
                                          ),
                                          TextField(
                                            controller: _descriptionController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                              contentPadding: EdgeInsets.only(right: 20.0),
                                              labelText: 'Description',
                                              prefixIcon: Icon(Icons.create, color: baseColors.mainColor)
                                            ),
                                          ),
                                          SizedBox(
                                            height: 24.0,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                onPressed: () {
                                                  StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
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
                                              SizedBox(
                                                width: 12.0
                                              ),
                                              RaisedButton(
                                                onPressed: () {
                                                  StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
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

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
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