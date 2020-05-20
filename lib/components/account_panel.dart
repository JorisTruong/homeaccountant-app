import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


final accounts = [
  {'id': 0, 'name': 'Account 1'},
  {'id': 1, 'name': 'Account 2'},
  {'id': 2, 'name': 'Account 3'},
  {'id': 3, 'name': 'Account 4'},
  {'id': 4, 'name': 'Account 5'}
];

class AccountPanel extends StatefulWidget {
  PanelController _pcAccount;

  AccountPanel(this._pcAccount);

  @override
  _AccountPanelState createState() => _AccountPanelState();
}

class _AccountPanelState extends State<AccountPanel> with TickerProviderStateMixin {
  FocusScopeNode currentFocus;
  TextEditingController _currentAccountController = TextEditingController();
  int newAccountId;

  @override
  Widget build(BuildContext context) {
    currentFocus = FocusScope.of(context);
    _currentAccountController.text = findAccountFromId(
      StoreProvider.of<AppState>(context).state.accountId,
      accounts
    );

    return new StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 50),
          child: Column(
            children: [
              TextField(
                readOnly: true,
                controller: _currentAccountController,
                decoration: InputDecoration(
                    isDense: true,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                    contentPadding: EdgeInsets.only(right: 20.0),
                    labelText: 'Current Account',
                    prefixIcon: Icon(Icons.account_box, color: baseColors.mainColor)
                )
              ),
              SizedBox(
                height: 24
              ),
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
                        Icon(Icons.account_box, size: 18.0),
                        Expanded(
                          child: DropdownButton<int>(
                            autofocus: true,
                            icon: Icon(Icons.keyboard_arrow_down),
                            value: newAccountId,
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
                                newAccountId = newValue;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    onPressed: () {
                      widget._pcAccount.close();
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
                      StoreProvider.of<AppState>(context).dispatch(ChangeAccount(newAccountId));
                      newAccountId = null;
                      widget._pcAccount.close();
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
            ]
          )
        );
      }
    );
  }
}
