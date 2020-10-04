import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_picker_dialog.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/generic_header.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/exchange_rate.dart';
import 'package:homeaccountantapp/database/models/accounts.dart';
import 'package:homeaccountantapp/database/queries/exchange_rate.dart';
import 'package:homeaccountantapp/database/queries/accounts.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the exchange rates page.
///


class ExchangeRatesPage extends StatefulWidget {
  ExchangeRatesPage({Key key}) : super(key: key);

  @override
  _ExchangeRatesPageState createState() => _ExchangeRatesPageState();
}

class _ExchangeRatesPageState extends State<ExchangeRatesPage> with TickerProviderStateMixin {

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
    TextEditingController from = TextEditingController();
    TextEditingController to = TextEditingController();

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            _store.dispatch(NavigatePopAction());
            return Future(() => true);
          },
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Center(
              child: Column(
                children: [
                  GenericHeader('Exchange rates', true, () {
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
                                future: readExchangeRates(databaseClient.db),
                                builder: (BuildContext context, AsyncSnapshot<List<ExchangeRate>> snapshot) {
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
                                        return Material(
                                            child: ListTile(
                                              title: Text(
                                                snapshot.data[index].from + ' to ' + snapshot.data[index].to,
                                                style: GoogleFonts.lato(
                                                  color: baseColors.mainColor,
                                                  fontSize: baseFontSize.subtitle
                                                )
                                              ),
                                              subtitle: Text(
                                                'Last updated on: ' + snapshot.data[index].date,
                                                style: GoogleFonts.lato(
                                                  color: baseColors.mainColor,
                                                  fontSize: baseFontSize.text
                                                )
                                              ),
                                              trailing: Wrap(
                                                spacing: 12,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                  Text(
                                                    'Rate: ' + snapshot.data[index].rate.toString(),
                                                    style: GoogleFonts.lato(
                                                      color: baseColors.mainColor,
                                                      fontSize: baseFontSize.subtitle,
                                                      fontWeight: FontWeight.bold
                                                    )
                                                  ),
                                                  InkWell(
                                                    child: Icon(
                                                      Icons.refresh,
                                                      color: baseColors.mainColor,
                                                    ),
                                                    onTap: () async {
                                                      if (snapshot.data[index].date != DateTime.now().toString().substring(0, 10)) {
                                                        http.Response apiResponse = await http.get('https://api.exchangerate.host/convert?from=${snapshot.data[index].from}&to=${snapshot.data[index].to}');
                                                        Map<String, dynamic> apiResponseJson = json.decode(apiResponse.body);
                                                        double rate = apiResponseJson['info']['rate'];
                                                        ExchangeRate updatedExchangeRate = ExchangeRate(
                                                          exchangeRateId: snapshot.data[index].exchangeRateId,
                                                          from: snapshot.data[index].from,
                                                          to: snapshot.data[index].to,
                                                          rate: rate,
                                                          date: DateTime.now().toString().substring(0, 10)
                                                        );
                                                        await updateExchangeRate(databaseClient.db, updatedExchangeRate).then((value) => this.setState(() {}));
                                                      } else {
                                                        Fluttertoast.showToast(
                                                          msg: 'Already up to date.',
                                                          backgroundColor: baseColors.mainColor,
                                                          textColor: Colors.white
                                                        );
                                                      }
                                                    }
                                                  ),
                                                  InkWell(
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: baseColors.mainColor
                                                    ),
                                                    onTap: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Are you sure ?'),
                                                            content: Text('Are you sure you want to delete this exchange rate?'),
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
                                                                  List<Account> selectedAccounts = await accountFromId(databaseClient.db, _store.state.accountId);
                                                                  Set<String> currencies = selectedAccounts.map((account) => CurrencyPickerUtils.getCountryByIsoCode(account.accountCountryIso).currencyCode).toSet();
                                                                  ExchangeRate exchangeRate = snapshot.data[index];
                                                                  if (currencies.contains(exchangeRate.from) && exchangeRate.to == CurrencyPickerUtils.getCountryByIsoCode(_store.state.mainCountryIso).currencyCode) {
                                                                    Fluttertoast.showToast(
                                                                      msg: 'You cannot delete this exchange rate as a selected account uses it.',
                                                                      backgroundColor: baseColors.mainColor,
                                                                      textColor: Colors.white
                                                                    );
                                                                  } else {
                                                                    await deleteExchangeRate(databaseClient.db, exchangeRate.exchangeRateId);
                                                                    Navigator.of(context).pop();
                                                                  }
                                                                  setState((){});
                                                                },
                                                              )
                                                            ],
                                                          );
                                                        }
                                                      );
                                                    },
                                                  )
                                                ]
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add an exchange rate'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Text(
                                  'From',
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
                                    controller: from,
                                    style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      alignLabelWithHint: true,
                                      border: OutlineInputBorder(borderSide: BorderSide.none),
                                      contentPadding: EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20)
                                    ),
                                    onTap: () {
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
                                            onValuePicked: (Country country) async {
                                              from.text = country.currencyCode;
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
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Text(
                                  'To',
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
                                    controller: to,
                                    style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      alignLabelWithHint: true,
                                      border: OutlineInputBorder(borderSide: BorderSide.none),
                                      contentPadding: EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20)
                                    ),
                                    onTap: () {
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
                                            onValuePicked: (Country country) async {
                                              to.text = country.currencyCode;
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
                          )
                        ]
                      ),
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
                            ExchangeRate exchangeRate = await readExchangeRate(databaseClient.db, from.text, to.text);
                            if (exchangeRate != null) {
                              Fluttertoast.showToast(
                                msg: 'This exchange rate already exists.',
                                backgroundColor: baseColors.mainColor,
                                textColor: Colors.white
                              );
                            } else {
                              http.Response apiResponse = await http.get('https://api.exchangerate.host/convert?from=${from.text}&to=${to.text}');
                              Map<String, dynamic> apiResponseJson = json.decode(apiResponse.body);
                              double rate = apiResponseJson['info']['rate'];
                              ExchangeRate newExchangeRate = ExchangeRate(
                                from: from.text,
                                to: to.text,
                                rate: rate,
                                date: DateTime.now().toString().substring(0, 10)
                              );
                              await createExchangeRate(databaseClient.db, newExchangeRate);
                            }
                            from.text = '';
                            to.text = '';
                            this.setState(() {});
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  }
                );
              },
              child: Icon(Icons.add),
            ),
          )
        );
      }
    );
  }
}