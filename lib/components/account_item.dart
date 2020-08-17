import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/database/models/accounts.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the account item widget.
/// It is the basic element widget for an account.
///


class AccountItem extends StatelessWidget {
  final Account account;

  AccountItem(
    this.account
  );

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return Card(
          margin: EdgeInsets.only(bottom: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
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
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Material(
                color: baseColors.transparent,
                child: ListTile(
                  leading: Icon(
                    Icons.account_box,
                    color: baseColors.mainColor,
                  ),
                  /// Text information of the account
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.accountName,
                        style: GoogleFonts.lato(fontSize: baseFontSize.subtitle, fontWeight: FontWeight.bold)
                      ),
                    ]
                  ),
                  subtitle: account.accountAcronym == null ?
                    null :
                    Text(account.accountAcronym, style: GoogleFonts.lato(fontSize: baseFontSize.text2)),
                  /// Navigates to the update page on tap
                  onTap: () async {
                    _store.dispatch(IsCreatingAccount(false));
                    TextEditingController accountName = TextEditingController();
                    accountName.text = account.accountName;
                    TextEditingController accountAcronym = TextEditingController();
                    accountAcronym.text = account.accountAcronym;
                    _store.dispatch(AccountInfoId(account.accountId));
                    _store.dispatch(AccountInfoName(accountName));
                    _store.dispatch(AccountInfoAcronym(accountAcronym));

                    _store.dispatch(NavigatePushAction(AppRoutes.account));
                  }
                )
              )
            ),
          )
        );
      }
    );
  }
}