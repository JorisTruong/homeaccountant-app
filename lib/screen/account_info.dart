import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
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
  bool errorMinimum = false;
  bool errorAccount = false;

  void resetState(Store<AppState> _store) {
    setState(() {
      errorMinimum = false;
    });
    _store.dispatch(AccountInfoId(null));
    _store.dispatch(AccountInfoName(TextEditingController()));
    _store.dispatch(AccountInfoAcronym(TextEditingController()));
    _store.dispatch(IsCreatingAccount(false));
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
            resetState(_store);
            _store.dispatch(NavigatePopAction());
            print(_store.state);
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
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    resetState(_store);
                    _store.dispatch(NavigatePopAction());
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  'Account Info',
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
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
                                          /// Account name
                                          TextField(
                                            controller: _store.state.accountInfoName,
                                            decoration: InputDecoration(
                                                errorText: errorAccount ? 'Cannot be null' : null,
                                                isDense: true,
                                                alignLabelWithHint: true,
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                                contentPadding: EdgeInsets.only(right: 20.0),
                                                labelText: 'Account name',
                                                prefixIcon: Icon(Icons.turned_in, color: baseColors.mainColor)
                                            ),
                                            onChanged: (string) {
                                              setState(() {
                                                errorAccount = false;
                                              });
                                            },
                                          ),
                                          SizedBox(height: 12.0),
                                          /// Account acronym
                                          TextField(
                                            controller: _store.state.accountInfoAcronym,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                              contentPadding: EdgeInsets.only(right: 20.0),
                                              labelText: 'Acronym',
                                              prefixIcon: Icon(Icons.turned_in, color: baseColors.mainColor)
                                            ),
                                          ),
                                          SizedBox(height: 24.0),
                                          /// Validate and cancel the operation
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                onPressed: () async {
                                                  // TODO: Delete confirmation ?
                                                  int numberOfAccounts = (await readAccounts(databaseClient.db)).length;
                                                  if (!_store.state.isCreatingAccount) {
                                                    if (numberOfAccounts <= 1) {
                                                      setState(() {
                                                        errorMinimum = true;
                                                      });
                                                    } else {
                                                      await deleteAccount(databaseClient.db, _store.state.accountInfoId);
                                                      resetState(_store);
                                                      _store.dispatch(NavigatePopAction());
                                                      Navigator.of(context).pop();
                                                    }
                                                  }
                                                  else {
                                                    resetState(_store);
                                                    _store.dispatch(NavigatePopAction());
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: Text(
                                                  _store.state.isCreatingAccount ? 'CANCEL' : 'DELETE',
                                                  style: TextStyle(
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
                                                  if (!errorAccount){
                                                    if (_store.state.isCreatingAccount) {
                                                      Account account = Account(
                                                        accountName: _store.state.accountInfoName.text,
                                                        accountAcronym: _store.state.accountInfoAcronym.text
                                                      );
                                                      await createAccount(databaseClient.db, account);
                                                    } else {
                                                      Account account = Account(
                                                        accountId: _store.state.accountInfoId,
                                                        accountName: _store.state.accountInfoName.text,
                                                        accountAcronym: _store.state.accountInfoAcronym.text
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
                                                  style: TextStyle(
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
                                          ),
                                          SizedBox(height: 24.0),
                                          errorMinimum ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'You need to have at least one account !',
                                                style: TextStyle(
                                                  color: baseColors.errorColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: baseFontSize.subtitle
                                                ),
                                              )
                                            ],
                                          ) : Container()
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