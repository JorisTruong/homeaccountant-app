import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/generic_header.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/models.dart';
import 'package:homeaccountantapp/database/models/transactions.dart' as t;
import 'package:homeaccountantapp/database/queries/queries.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the transaction info page.
/// It is used to create or update a transaction.
///


class TransactionInfoPage extends StatefulWidget {
  TransactionInfoPage({Key key}) : super(key: key);

  @override
  _TransactionInfoPageState createState() => _TransactionInfoPageState();
}

class _TransactionInfoPageState extends State<TransactionInfoPage> with TickerProviderStateMixin {
  FocusScopeNode currentFocus;
  bool errorName = false;
  bool errorAccount = false;
  bool errorDate = false;
  bool errorIsExpense = false;
  bool errorCategory = false;
  bool errorAmount = false;

  void resetSubcategory(Store<AppState> _store) {
    _store.dispatch(TransactionSubcategoryId(null));
    _store.dispatch(TransactionSelectSubcategoryIcon(null));
    _store.dispatch(TransactionSubcategoryText(TextEditingController()));
  }

  void leaveScreen(Store<AppState> _store) {
    _store.dispatch(NavigatePopAction());
    _store.dispatch(SelectCategory(null));
    _store.dispatch(TransactionId(null));
    _store.dispatch(TransactionName(TextEditingController()));
    _store.dispatch(TransactionAccount(null));
    _store.dispatch(TransactionDate(TextEditingController()));
    _store.dispatch(TransactionIsExpense(null));
    _store.dispatch(TransactionAmount(TextEditingController()));
    _store.dispatch(TransactionDescription(TextEditingController()));
    _store.dispatch(IsSelectingSubcategory(false));
    _store.dispatch(IsCreatingTransaction(false));
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
            return Future(() => true);
          },
          /// The GestureDetector is for removing the dropdown when tapping the screen.
          child: GestureDetector(
            onTap: () {
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Center(
                child: Column(
                  children: [
                    GenericHeader('Transaction', true, () {
                      leaveScreen(_store);
                      Navigator.of(context).pop();
                    }),
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
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.85,
                              child: Padding(
                                padding: EdgeInsets.all(20),
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
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Container(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              /// Starting point of the form
                                              Row(
                                                children: [
                                                  /// Name of the transaction
                                                  Expanded(
                                                    flex: 7,
                                                    child: Text(
                                                      'Name',
                                                      style: GoogleFonts.lato(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: baseFontSize.text
                                                      ),
                                                    )
                                                  ),
                                                  Expanded(
                                                    flex: 13,
                                                    /// Name of the subcategory
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: baseColors.tertiaryColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.35),
                                                            spreadRadius: 0,
                                                            blurRadius: 0,
                                                            offset: Offset(1, 1), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: TextField(
                                                        controller: _store.state.transactionName,
                                                        style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                        decoration: InputDecoration(
                                                          errorText: errorName ? '' : null,
                                                          errorStyle: GoogleFonts.lato(height: 0),
                                                          isDense: true,
                                                          alignLabelWithHint: true,
                                                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: baseColors.errorColor)),
                                                          border: OutlineInputBorder(borderSide: BorderSide.none),
                                                          contentPadding: EdgeInsets.only(right: 20.0),
                                                          hintText: 'Transaction name',
                                                          prefixIcon: Icon(Icons.title, color: baseColors.mainColor)
                                                        ),
                                                        onChanged: (string) {
                                                          setState(() {
                                                            errorName = false;
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  ),
                                                ]
                                              ),
                                              SizedBox(height: 12.0),
                                              Row(
                                                children: [
                                                  /// Dropdown to select the account
                                                  Expanded(
                                                    flex: 7,
                                                    child: Text(
                                                      'Account',
                                                      style: GoogleFonts.lato(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: baseFontSize.text
                                                      ),
                                                    )
                                                  ),
                                                  Expanded(
                                                    flex: 13,
                                                    child: DropdownButtonHideUnderline(
                                                      child: ButtonTheme(
                                                        alignedDropdown: true,
                                                        child: Card(
                                                          color: baseColors.tertiaryColor,
                                                          margin: EdgeInsets.zero,
                                                          shape: RoundedRectangleBorder(
                                                              side: BorderSide(color: errorCategory ? baseColors.errorColor : baseColors.transparent)
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(width: 15.0),
                                                              Icon(Icons.account_box, size: 18.0),
                                                              Expanded(
                                                                child: FutureBuilder(
                                                                  future: readAccounts(databaseClient.db),
                                                                  builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                                                                    if (snapshot.hasData) {
                                                                      return DropdownButton<int>(
                                                                        autofocus: true,
                                                                        icon: Icon(Icons.keyboard_arrow_down),
                                                                        value: _store.state.transactionAccountId,
                                                                        hint: Text(
                                                                          'Account',
                                                                          textAlign: TextAlign.center,
                                                                          style: GoogleFonts.lato(color: baseColors.secondaryColor, fontSize: baseFontSize.text)
                                                                        ),
                                                                        isDense: false,
                                                                        onTap: () {
                                                                          if (!currentFocus.hasPrimaryFocus) {
                                                                            currentFocus.unfocus();
                                                                          }
                                                                        },
                                                                        onChanged: (int newValue) {
                                                                          setState(() {
                                                                            errorAccount = false;
                                                                          });
                                                                          _store.dispatch(TransactionAccount(newValue));
                                                                        },
                                                                        items: List.generate(snapshot.data.length, (int i) {
                                                                          return DropdownMenuItem<int>(
                                                                            value: snapshot.data[i].accountId,
                                                                            child: Text(snapshot.data[i].accountName, style: GoogleFonts.lato(fontSize: baseFontSize.text))
                                                                          );
                                                                        })
                                                                      );
                                                                    } else {
                                                                      return LoadingComponent();
                                                                    }
                                                                  }
                                                                )
                                                              ),
                                                              SizedBox(width: 15.0)
                                                            ],
                                                          )
                                                        )
                                                      )
                                                    )
                                                  )
                                                ]
                                              ),
                                              SizedBox(height: 12.0),
                                              Row(
                                                children: [
                                                  /// Select the date
                                                  Expanded(
                                                    flex: 7,
                                                    child: Text(
                                                      'Date',
                                                      style: GoogleFonts.lato(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: baseFontSize.text
                                                      ),
                                                    )
                                                  ),
                                                  Expanded(
                                                    flex: 13,
                                                    child: Theme(
                                                      data: ThemeData(
                                                        primaryColor: baseColors.mainColor,
                                                        colorScheme: ColorScheme.light(primary: baseColors.mainColor),
                                                        splashColor: baseColors.tertiaryColor
                                                      ),
                                                      child: Builder(
                                                        builder: (context) =>
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: baseColors.tertiaryColor,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.35),
                                                                  spreadRadius: 0,
                                                                  blurRadius: 0,
                                                                  offset: Offset(1, 1), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: TextField(
                                                              readOnly: true,
                                                              controller: _store.state.transactionDate,
                                                              style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                              decoration: InputDecoration(
                                                                errorText: errorDate ? '' : null,
                                                                errorStyle: GoogleFonts.lato(height: 0),
                                                                isDense: true,
                                                                alignLabelWithHint: true,
                                                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: baseColors.errorColor)),
                                                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                                                contentPadding: EdgeInsets.only(right: 20.0),
                                                                hintText: 'Date',
                                                                prefixIcon: Icon(Icons.date_range, color: baseColors.mainColor)
                                                              ),
                                                              onTap: () async {
                                                                setState(() {
                                                                  errorDate = false;
                                                                });
                                                                final DateTime pickedDate = await showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime.now(),
                                                                  firstDate: DateTime(1900),
                                                                  lastDate: DateTime(2100),
                                                                );
                                                                if (pickedDate != null) {
                                                                  TextEditingController date = TextEditingController();
                                                                  date.text = pickedDate.toString().split(' ')[0];
                                                                  _store.dispatch(TransactionDate(date));
                                                                }
                                                              },
                                                            )
                                                          )
                                                      )
                                                    )
                                                  )
                                                ]
                                              ),
                                              SizedBox(height: 12.0),
                                              /// Select expense or not
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 7,
                                                    child: Text(
                                                      'Type',
                                                      style: GoogleFonts.lato(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: baseFontSize.text
                                                      ),
                                                    )
                                                  ),
                                                  Expanded(
                                                    flex: 13,
                                                    child: Row(
                                                      children: [
                                                        Radio(
                                                          value: true,
                                                          groupValue: _store.state.transactionIsExpense,
                                                          onChanged: (bool value) {
                                                            setState(() {
                                                              errorIsExpense = false;
                                                            });
                                                            _store.dispatch(TransactionIsExpense(value));
                                                          }
                                                        ),
                                                        Text(
                                                          'Expense',
                                                          style: GoogleFonts.lato(
                                                            fontSize: baseFontSize.text
                                                          ),
                                                        ),
                                                        Radio(
                                                          value: false,
                                                          groupValue: _store.state.transactionIsExpense,
                                                          onChanged: (bool value) {
                                                            setState(() {
                                                              errorIsExpense = false;
                                                            });
                                                            _store.dispatch(TransactionIsExpense(value));
                                                          }
                                                        ),
                                                        Text(
                                                          'Income',
                                                          style: GoogleFonts.lato(
                                                            fontSize: baseFontSize.text
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  )
                                                ]
                                              ),
                                              errorIsExpense ? Text(
                                                'Select a transaction type',
                                                style: GoogleFonts.lato(
                                                  color: baseColors.errorColor,
                                                  fontSize: baseFontSize.text
                                                ),
                                              ) : Container(),
                                              SizedBox(height: 12.0),
                                              Row(
                                                children: [
                                                  /// Dropdown to select the category
                                                  Expanded(
                                                    flex: 7,
                                                    child: Text(
                                                      'Category',
                                                      style: GoogleFonts.lato(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: baseFontSize.text
                                                      ),
                                                    )
                                                  ),
                                                  Expanded(
                                                    flex: 13,
                                                    child: DropdownButtonHideUnderline(
                                                      child: ButtonTheme(
                                                        alignedDropdown: true,
                                                        child: Card(
                                                          color: baseColors.tertiaryColor,
                                                          margin: EdgeInsets.zero,
                                                          shape: RoundedRectangleBorder(
                                                            side: BorderSide(color: errorCategory ? baseColors.errorColor : baseColors.transparent)
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(width: 15.0),
                                                              Icon(Icons.label, size: 18.0),
                                                              Expanded(
                                                                child: FutureBuilder(
                                                                  future: readCategories(databaseClient.db),
                                                                  builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
                                                                    if (snapshot.hasData) {
                                                                      return DropdownButton<int>(
                                                                        icon: Icon(Icons.keyboard_arrow_down),
                                                                        value: _store.state.categoryIndex,
                                                                        hint: Text(
                                                                          'Category',
                                                                          textAlign: TextAlign.center,
                                                                          style: GoogleFonts.lato(color: baseColors.secondaryColor, fontSize: baseFontSize.text)
                                                                        ),
                                                                        isDense: false,
                                                                        onTap: () {
                                                                          if (!currentFocus.hasPrimaryFocus) {
                                                                            currentFocus.unfocus();
                                                                          }
                                                                        },
                                                                        onChanged: (int newValue) {
                                                                          setState(() {
                                                                            errorCategory = false;
                                                                          });
                                                                          resetSubcategory(_store);
                                                                          _store.dispatch(SelectCategory(newValue));
                                                                        },
                                                                        items: List.generate(snapshot.data.length, (int index) {
                                                                          return DropdownMenuItem<int>(
                                                                            value: snapshot.data[index].categoryId,
                                                                            child: Text(snapshot.data[index].categoryName, style: GoogleFonts.lato(fontSize: baseFontSize.text))
                                                                          );
                                                                        })
                                                                      );
                                                                    } else {
                                                                      return LoadingComponent();
                                                                    }
                                                                  }
                                                                ),
                                                              ),
                                                              SizedBox(width: 15.0)
                                                            ],
                                                          )
                                                        )
                                                      )
                                                    )
                                                  )
                                                ]
                                              ),
                                              SizedBox(height: 12.0),
                                              /// Select the subcategory
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 7,
                                                    child: Text(
                                                      'Subcategory',
                                                      style: GoogleFonts.lato(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: baseFontSize.text,
                                                      ),
                                                    )
                                                  ),
                                                  Expanded(
                                                    flex: 13,
                                                    /// Name of the subcategory
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: baseColors.tertiaryColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.35),
                                                            spreadRadius: 0,
                                                            blurRadius: 0,
                                                            offset: Offset(1, 1), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: TextField(
                                                        readOnly: true,
                                                        controller: _store.state.transactionSubcategoryText,
                                                        style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          alignLabelWithHint: true,
                                                          border: OutlineInputBorder(borderSide: BorderSide.none),
                                                          contentPadding: EdgeInsets.only(right: 20.0),
                                                          hintText: 'Subcategory',
                                                          prefixIcon: _store.state.transactionSubcategoryIcon == null ?
                                                            Icon(
                                                              Icons.turned_in,
                                                              color: baseColors.mainColor
                                                            ) :
                                                            _store.state.transactionSubcategoryIcon,
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
                                                    )
                                                  )
                                                ]
                                              ),
                                              SizedBox(height: 12.0),
                                              /// Amount of the transaction
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 7,
                                                    child: Text(
                                                      'Amount',
                                                      style: GoogleFonts.lato(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: baseFontSize.text,
                                                      ),
                                                    )
                                                  ),
                                                  Expanded(
                                                    flex: 13,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: baseColors.tertiaryColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.35),
                                                            spreadRadius: 0,
                                                            blurRadius: 0,
                                                            offset: Offset(1, 1), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: TextField(
                                                        inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                        controller: _store.state.transactionAmount,
                                                        style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                        decoration: InputDecoration(
                                                          errorText: errorDate ? '' : null,
                                                          errorStyle: GoogleFonts.lato(height: 0),
                                                          isDense: true,
                                                          alignLabelWithHint: true,
                                                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: baseColors.errorColor)),
                                                          border: OutlineInputBorder(borderSide: BorderSide.none),
                                                          contentPadding: EdgeInsets.only(right: 20.0),
                                                          hintText: 'Amount',
                                                          prefixIcon: Icon(Icons.attach_money, color: baseColors.mainColor)
                                                        ),
                                                        onChanged: (string) {
                                                          setState(() {
                                                            errorAmount = false;
                                                          });
                                                        }
                                                      )
                                                    )
                                                  )
                                                ]
                                              ),
                                              SizedBox(height: 12.0),
                                              /// Description of the transaction
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 7,
                                                    child: Text(
                                                      'Description',
                                                      style: GoogleFonts.lato(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: baseFontSize.text,
                                                      ),
                                                    )
                                                  ),
                                                  Expanded(
                                                    flex: 13,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: baseColors.tertiaryColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.35),
                                                            spreadRadius: 0,
                                                            blurRadius: 0,
                                                            offset: Offset(1, 1), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: TextField(
                                                        controller: _store.state.transactionDescription,
                                                        style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          alignLabelWithHint: true,
                                                          border: OutlineInputBorder(borderSide: BorderSide.none),
                                                          contentPadding: EdgeInsets.only(right: 20.0),
                                                          hintText: 'Description',
                                                          prefixIcon: Icon(Icons.create, color: baseColors.mainColor)
                                                        ),
                                                      ),
                                                    )
                                                  )
                                                ]
                                              ),
                                              SizedBox(height: 24.0),
                                              /// Validate and cancel the operation
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  RaisedButton(
                                                    onPressed: () async {
                                                      if (!_store.state.isCreatingTransaction) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text('Are you sure ?'),
                                                              content: Text('You will not be able to revert deleting this transaction. Are you sure you want to delete this transaction?'),
                                                              actions: [
                                                                FlatButton(
                                                                  child: Text('Cancel'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text('Confirm'),
                                                                  onPressed: () async {
                                                                    await deleteTransaction(databaseClient.db, _store.state.transactionId);
                                                                    leaveScreen(_store);
                                                                    Navigator.of(context).pop();
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          }
                                                        );
                                                      } else {
                                                        leaveScreen(_store);
                                                        Navigator.of(context).pop();
                                                      }
                                                    },
                                                    child: Text(
                                                      _store.state.isCreatingTransaction ? 'CANCEL' : 'DELETE',
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
                                                    onPressed: () async {
                                                      if (_store.state.transactionName.text == '') {
                                                        setState(() {
                                                          errorName = true;
                                                        });
                                                      }
                                                      if (_store.state.transactionAccountId == null) {
                                                        setState(() {
                                                          errorAccount = true;
                                                        });
                                                      }
                                                      if (_store.state.transactionDate.text == '') {
                                                        setState(() {
                                                          errorDate = true;
                                                        });
                                                      }
                                                      if (_store.state.transactionIsExpense == null) {
                                                        setState(() {
                                                          errorIsExpense = true;
                                                        });
                                                      }
                                                      if (_store.state.categoryIndex == null) {
                                                        setState(() {
                                                          errorCategory = true;
                                                        });
                                                      }
                                                      if (_store.state.transactionAmount.text == '') {
                                                        setState(() {
                                                          errorAmount = true;
                                                        });
                                                      }
                                                      if (!errorName && !errorAccount && !errorDate && !errorIsExpense && !errorCategory && !errorAmount) {
                                                        if (_store.state.isCreatingTransaction) {
                                                          t.Transaction transaction = t.Transaction(
                                                            transactionName: _store.state.transactionName.text,
                                                            accountId: _store.state.transactionAccountId,
                                                            date: _store.state.transactionDate.text,
                                                            isExpense: _store.state.transactionIsExpense,
                                                            categoryId: _store.state.categoryIndex,
                                                            subcategoryId: _store.state.transactionSubcategoryId,
                                                            amount: _store.state.transactionIsExpense ? -double.parse(_store.state.transactionAmount.text) : double.parse(_store.state.transactionAmount.text),
                                                            description: _store.state.transactionDescription.text,
                                                          );
                                                          await createTransaction(databaseClient.db, transaction);
                                                        } else {
                                                          t.Transaction transaction = t.Transaction(
                                                            transactionId: _store.state.transactionId,
                                                            transactionName: _store.state.transactionName.text,
                                                            accountId: _store.state.transactionAccountId,
                                                            date: _store.state.transactionDate.text,
                                                            isExpense: _store.state.transactionIsExpense,
                                                            categoryId: _store.state.categoryIndex,
                                                            subcategoryId: _store.state.transactionSubcategoryId,
                                                            amount: _store.state.transactionIsExpense ? -double.parse(_store.state.transactionAmount.text) : double.parse(_store.state.transactionAmount.text),
                                                            description: _store.state.transactionDescription.text,
                                                          );
                                                          await updateTransaction(databaseClient.db, transaction);
                                                        }
                                                        leaveScreen(_store);
                                                        Navigator.of(context).pop();
                                                      }
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
                                            ],
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              ),
                            )
                          )
                        )
                      )
                    )
                  ]
                )
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

      // Prevent from having char other than number
      if (value.contains(new RegExp('[^0-9.]'))) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }

      // Prevent from having multiple '.'
      if (value.contains('.') && value.substring(value.indexOf('.') + 1) == '.') {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }

      if (value.contains('.') && value.substring(value.indexOf('.') + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == '.') {
        truncated = '0.';

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