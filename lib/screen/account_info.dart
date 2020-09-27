import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_picker_dialog.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/generic_header.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/accounts.dart';
import 'package:homeaccountantapp/database/queries/accounts.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the account info page.
/// It is used to create or update an account.
///


class AccountInfoPage extends StatefulWidget {
  AccountInfoPage({Key key}) : super(key: key);

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> with TickerProviderStateMixin {
  FocusScopeNode currentFocus;
  bool errorAccount = false;
  bool errorCurrency = false;

  void resetState(Store<AppState> _store) {
    _store.dispatch(AccountInfoId(null));
    _store.dispatch(AccountInfoName(TextEditingController()));
    _store.dispatch(AccountInfoAcronym(TextEditingController()));
    _store.dispatch(AccountInfoCountryIso(null));
    _store.dispatch(AccountInfoCurrencyText(TextEditingController()));
    _store.dispatch(IsCreatingAccount(false));
  }

  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CurrencyPickerUtils.getDefaultFlagImage(country),
      SizedBox(width: 8.0),
      Text("${country.currencyCode}"),
      SizedBox(width: 8.0),
      Flexible(child: Text(country.name))
    ],
  );

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);
    currentFocus = FocusScope.of(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            resetState(_store);
            _store.dispatch(NavigatePopAction());
            return Future(() => true);
          },
          /// The GestureDetector is for removing the keyboard when tapping the screen.
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
                    GenericHeader('Account', true, () {
                      resetState(_store);
                      _store.dispatch(NavigatePopAction());
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
                                padding: EdgeInsets.all(20.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10)
                                      ),
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
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              child: Padding(
                                                padding: EdgeInsets.all(25.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 7,
                                                          child: Text(
                                                            'Name',
                                                            style: GoogleFonts.lato(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: baseFontSize.text,
                                                            ),
                                                          )
                                                        ),
                                                        Expanded(
                                                          flex: 13,
                                                          /// Name of the account
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
                                                              controller: _store.state.accountInfoName,
                                                              style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                              decoration: InputDecoration(
                                                                errorText: errorAccount ? '' : null,
                                                                errorStyle: GoogleFonts.lato(height: 0),
                                                                isDense: false,
                                                                alignLabelWithHint: true,
                                                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: baseColors.errorColor)),
                                                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                                                contentPadding: EdgeInsets.only(right: 20.0),
                                                                hintText: 'Account Name',
                                                                prefixIcon: Icon(Icons.turned_in, color: baseColors.mainColor),
                                                              ),
                                                              onChanged: (string) {
                                                                setState(() {
                                                                  errorAccount = false;
                                                                });
                                                              },
                                                            )
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                    SizedBox(height: 12.0),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 7,
                                                          child: Text(
                                                            'Acronym',
                                                            style: GoogleFonts.lato(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: baseFontSize.text,
                                                            ),
                                                          )
                                                        ),
                                                        Expanded(
                                                          flex: 13,
                                                          /// Acronym of the account
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
                                                              controller: _store.state.accountInfoAcronym,
                                                              style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                              decoration: InputDecoration(
                                                                isDense: false,
                                                                alignLabelWithHint: true,
                                                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: baseColors.errorColor)),
                                                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                                                contentPadding: EdgeInsets.only(right: 20.0),
                                                                hintText: 'Acronym',
                                                                prefixIcon: Icon(Icons.turned_in, color: baseColors.mainColor),
                                                              ),
                                                            )
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                    SizedBox(height: 12.0),
                                                    /// Select the currency
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 7,
                                                          child: Text(
                                                            'Currency',
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
                                                              readOnly: true,
                                                              controller: _store.state.accountInfoCurrencyText,
                                                              style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                              decoration: InputDecoration(
                                                                isDense: true,
                                                                alignLabelWithHint: true,
                                                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                                                contentPadding: EdgeInsets.only(right: 20.0),
                                                                hintText: 'Currency',
                                                                prefixIcon: _store.state.accountInfoCountryIso == null ?
                                                                  Icon(MaterialCommunityIcons.currency_sign, size: 18.0, color: baseColors.mainColor) :
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      CurrencyPickerUtils.getDefaultFlagImage(CurrencyPickerUtils.getCountryByIsoCode(_store.state.accountInfoCountryIso)),
                                                                    ]
                                                                  ),
                                                              ),
                                                              onTap: () {
                                                                if (!currentFocus.hasPrimaryFocus) {
                                                                  currentFocus.unfocus();
                                                                }
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) => Theme(
                                                                    data: Theme.of(context).copyWith(primaryColor: baseColors.mainColor),
                                                                    child: CurrencyPickerDialog(
                                                                      titlePadding: EdgeInsets.all(8.0),
                                                                      searchCursorColor: baseColors.mainColor,
                                                                      searchInputDecoration: InputDecoration(hintText: 'Search...'),
                                                                      isSearchable: true,
                                                                      title: Text('Select your currency'),
                                                                      onValuePicked: (Country country) {
                                                                        _store.dispatch(AccountInfoCountryIso(country.isoCode));
                                                                        TextEditingController currency = TextEditingController();
                                                                        currency.text = "${country.currencyCode} (${country.isoCode})";
                                                                        _store.dispatch(AccountInfoCurrencyText(currency));
                                                                      },
                                                                      itemBuilder: _buildDialogItem
                                                                    )
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                    SizedBox(height: 36.0),
                                                    /// Validate and cancel the operation
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        RaisedButton(
                                                          onPressed: () async {
                                                            if (!_store.state.isCreatingAccount) {
                                                              int numberOfAccounts = (await readAccounts(databaseClient.db)).length;
                                                              showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return AlertDialog(
                                                                    title: Text('Are you sure ?'),
                                                                    content: Text('Deleting this account will delete all the transactions that are tagged with this account. Are you sure you want to delete this account?'),
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
                                                                          if (numberOfAccounts <= 1) {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                               return AlertDialog(
                                                                                 title: Text(
                                                                                   'You need to have at least one account!',
                                                                                   style: GoogleFonts.lato(
                                                                                     color: baseColors.errorColor,
                                                                                     fontWeight: FontWeight.bold,
                                                                                     fontSize: baseFontSize.subtitle
                                                                                   )
                                                                                 ),
                                                                                 actions: [
                                                                                   FlatButton(
                                                                                     child: Text('OK'),
                                                                                     onPressed: () {
                                                                                       Navigator.of(context).pop();
                                                                                     }
                                                                                   )
                                                                                 ]
                                                                               );
                                                                              }
                                                                            );
                                                                          } else {
                                                                            await deleteAccount(databaseClient.db, _store.state.accountInfoId);
                                                                            if (_store.state.accountId.contains(_store.state.accountInfoId)) {
                                                                              _store.state.accountId.remove(_store.state.accountInfoId);
                                                                              if (_store.state.accountId.length < 1) {
                                                                                Account baseAccount = (await readAccounts(databaseClient.db))[0];
                                                                                _store.state.accountId.add(baseAccount.accountId);
                                                                              }
                                                                              _store.dispatch(ChangeAccount(_store.state.accountId));
                                                                            }
                                                                            resetState(_store);
                                                                            _store.dispatch(NavigatePopAction());
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pop();
                                                                          }
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                }
                                                              );
                                                            } else {
                                                              resetState(_store);
                                                              _store.dispatch(NavigatePopAction());
                                                              Navigator.of(context).pop();
                                                            }
                                                          },
                                                          child: Text(
                                                            _store.state.isCreatingAccount ? 'CANCEL' : 'DELETE',
                                                            style: GoogleFonts.lato(
                                                              fontSize: baseFontSize.text,
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
                                                            if (_store.state.accountInfoName.text == '') {
                                                              setState(() {
                                                                errorAccount = true;
                                                              });
                                                            }
                                                            if (_store.state.accountInfoCountryIso == null || _store.state.accountInfoCountryIso == '') {
                                                              setState(() {
                                                                errorCurrency = true;
                                                              });
                                                            }
                                                            if (!errorAccount && !errorCurrency) {
                                                              if (_store.state.isCreatingAccount) {
                                                                Account account = Account(
                                                                  accountName: _store.state.accountInfoName.text,
                                                                  accountAcronym: _store.state.accountInfoAcronym.text,
                                                                  accountCountryIso: _store.state.accountInfoCountryIso
                                                                );
                                                                await createAccount(databaseClient.db, account);
                                                              } else {
                                                                Account account = Account(
                                                                  accountId: _store.state.accountInfoId,
                                                                  accountName: _store.state.accountInfoName.text,
                                                                  accountAcronym: _store.state.accountInfoAcronym.text,
                                                                  accountCountryIso: _store.state.accountInfoCountryIso
                                                                );
                                                                await updateAccount(databaseClient.db, account);
                                                              }
                                                              _store.dispatch(NavigatePopAction());
                                                              resetState(_store);
                                                              Navigator.of(context).pop();
                                                            }
                                                          },
                                                          child: Text(
                                                            'VALIDATE',
                                                            style: GoogleFonts.lato(
                                                              fontSize: baseFontSize.text,
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