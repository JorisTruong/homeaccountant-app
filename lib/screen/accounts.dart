import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:currency_pickers/country.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/generic_header.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/accounts.dart';
import 'package:homeaccountantapp/database/models/exchange_rate.dart';
import 'package:homeaccountantapp/database/queries/accounts.dart';
import 'package:homeaccountantapp/database/queries/exchange_rate.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the accounts page.
///


class AccountsPage extends StatefulWidget {
  AccountsPage({Key key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);
    List<int> selectedAccount = _store.state.accountId;

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            _store.dispatch(NavigatePopAction());
            print(_store.state);
            return Future(() => true);
          },
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Center(
              child: Column(
                children: [
                  GenericHeader('Accounts', true, () {
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
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: readAccounts(databaseClient.db),
                                builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.separated(
                                      separatorBuilder: (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 5,
                                        );
                                      },
                                      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        Country country = CurrencyPickerUtils.getCountryByIsoCode(snapshot.data[index].accountCountryIso);
                                        return Material(
                                          child: CheckboxListTile(
                                            title: Wrap(
                                              direction: Axis.vertical,
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot.data[index].accountName,
                                                  style: GoogleFonts.lato(
                                                    color: baseColors.mainColor,
                                                    fontSize: baseFontSize.text
                                                  )
                                                ),
                                                Text(
                                                  snapshot.data[index].accountAcronym,
                                                  style: GoogleFonts.lato(
                                                    color: baseColors.mainColor,
                                                    fontSize: baseFontSize.text2
                                                  )
                                                ),
                                                snapshot.data[index].accountAcronym != '' ? SizedBox(height: 8) : Container()
                                              ]
                                            ),
                                            subtitle: Row(
                                              children: <Widget>[
                                                CurrencyPickerUtils.getDefaultFlagImage(country),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  "${country.currencyCode} (${country.isoCode})",
                                                  style: GoogleFonts.lato(fontSize: baseFontSize.text)
                                                ),
                                              ],
                                            ),
                                            value: selectedAccount.contains(snapshot.data[index].accountId),
                                            onChanged: (bool newValue) async {
                                              int selectedAccountId = snapshot.data[index].accountId;
                                              if (_store.state.accountId.contains(selectedAccountId)) {
                                                if (_store.state.accountId.length > 1) {
                                                  _store.state.accountId.remove(selectedAccountId);
                                                }
                                              } else {
                                                _store.state.accountId.add(selectedAccountId);
                                              }
                                              List<Account> selectedAccounts = await accountFromId(databaseClient.db, _store.state.accountId);
                                              if (_store.state.accountId.length > 1) {
                                                Set<String> currencies = selectedAccounts.map((account) => CurrencyPickerUtils.getCountryByIsoCode(account.accountCountryIso).currencyCode).toSet();
                                                if (currencies.length > 1) {
                                                  currencies.forEach((currency) async {
                                                    String mainCurrency = CurrencyPickerUtils.getCountryByIsoCode(_store.state.mainCountryIso).currencyCode;
                                                    ExchangeRate exchangeRate = await readExchangeRate(databaseClient.db, currency, mainCurrency);
                                                    if (exchangeRate == null) {
                                                      http.Response apiResponse = await http.get('https://api.exchangerate.host/convert?from=$currency&to=$mainCurrency');
                                                      Map<String, dynamic> apiResponseJson = json.decode(apiResponse.body);
                                                      double rate = apiResponseJson['info']['rate'];
                                                      ExchangeRate newExchangeRate = ExchangeRate(
                                                        from: currency,
                                                        to: mainCurrency,
                                                        rate: rate,
                                                        date: DateTime.now().toString().substring(0, 10)
                                                      );
                                                      await createExchangeRate(databaseClient.db, newExchangeRate);
                                                    }
                                                  });
                                                }
                                              }
                                              _store.dispatch(ChangeAccount(_store.state.accountId));
                                            },
                                            secondary: InkWell(
                                              onTap: () {
                                                _store.dispatch(IsCreatingAccount(false));
                                                TextEditingController accountName = TextEditingController();
                                                accountName.text = snapshot.data[index].accountName;
                                                TextEditingController accountAcronym = TextEditingController();
                                                accountAcronym.text = snapshot.data[index].accountAcronym;
                                                TextEditingController accountCurrency = TextEditingController();
                                                Country country = CurrencyPickerUtils.getCountryByIsoCode(snapshot.data[index].accountCountryIso);
                                                accountCurrency.text = "${country.currencyCode} (${country.isoCode})";
                                                _store.dispatch(AccountInfoId(snapshot.data[index].accountId));
                                                _store.dispatch(AccountInfoName(accountName));
                                                _store.dispatch(AccountInfoAcronym(accountAcronym));
                                                _store.dispatch(AccountInfoCountryIso(snapshot.data[index].accountCountryIso));
                                                _store.dispatch(AccountInfoCurrencyText(accountCurrency));

                                                _store.dispatch(NavigatePushAction(AppRoutes.account));
                                              },
                                              child: Icon(Icons.edit),
                                            ),
                                          )
                                        );
                                      }
                                    );
                                  } else {
                                    return LoadingComponent();
                                  }
                                },
                              )
                            ],
                          )
                        )
                      )
                    )
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
                heroTag: null,
              onPressed: () {
                _store.dispatch(IsCreatingAccount(true));
                _store.dispatch(NavigatePushAction(AppRoutes.account));
              },
              child: Icon(Icons.add),
            ),
          )
        );
      }
    );
  }
}