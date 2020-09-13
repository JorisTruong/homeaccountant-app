import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_picker_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/generic_header.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/queries/main_currency.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the main currency page.
/// It is used to update the main currency.
///


class MainCurrencyPage extends StatefulWidget {
  MainCurrencyPage({Key key}) : super(key: key);

  @override
  _MainCurrencyPageState createState() => _MainCurrencyPageState();
}

class _MainCurrencyPageState extends State<MainCurrencyPage> with TickerProviderStateMixin {
  String exchangeRatesApi = 'https://exchangeratesapi.io/';

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
                  GenericHeader('Main Currency', true, () {
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
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Container(
                                          child: Padding(
                                            padding: EdgeInsets.all(25.0),
                                            child: Column(
                                              children: [
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
                                                          controller: _store.state.mainCurrencyText,
                                                          style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            alignLabelWithHint: true,
                                                            border: OutlineInputBorder(borderSide: BorderSide.none),
                                                            contentPadding: EdgeInsets.only(right: 20.0),
                                                            hintText: 'Currency',
                                                            prefixIcon: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                CurrencyPickerUtils.getDefaultFlagImage(CurrencyPickerUtils.getCountryByIsoCode(_store.state.mainCountryIso)),
                                                              ]
                                                            ),
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
                                                                    Map<String, dynamic> updatedMainCurrency = {
                                                                      'id': 0,
                                                                      'country_iso': country.isoCode,
                                                                      'currency': country.currencyCode
                                                                    };
                                                                    await updateMainCurrency(databaseClient.db, updatedMainCurrency);
                                                                    _store.dispatch(MainCountryIso(country.isoCode));
                                                                    TextEditingController currency = TextEditingController();
                                                                    currency.text = "${country.currencyCode} (${country.isoCode})";
                                                                    _store.dispatch(MainCurrencyText(currency));
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
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "The use of the main currency is to convert all transactions into the same currency. Is it particularly helpful when the user select multiple accounts with different currencies. Transactions will then show up with amounts using the main currency, obtained via currency conversion.",
                                                        style: GoogleFonts.lato(
                                                          color: baseColors.mainColor,
                                                          fontSize: baseFontSize.subtitle
                                                        ),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                      SizedBox(height: 12),
                                                      Text(
                                                        "Currency conversion is obviously not performed if only one account is selected, or if selected accounts share the same currency.",
                                                        style: GoogleFonts.lato(
                                                            color: baseColors.mainColor,
                                                            fontSize: baseFontSize.subtitle
                                                        ),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                      SizedBox(height: 12),
                                                      Text(
                                                        "Conversions are performed using an open-source projet, Exchange Rates API. The applied exchange rates are published by the European Central Bank. You can find more info about the project here: ",
                                                        style: GoogleFonts.lato(
                                                          color: baseColors.mainColor,
                                                          fontSize: baseFontSize.subtitle
                                                        ),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                      SizedBox(height: 12),
                                                      InkWell(
                                                        child: Text(
                                                          exchangeRatesApi,
                                                          style: GoogleFonts.lato(
                                                            color: baseColors.blue,
                                                            fontSize: baseFontSize.subtitle
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        onTap: () async {
                                                          if (await canLaunch(exchangeRatesApi)) {
                                                            await launch(exchangeRatesApi);
                                                          } else {
                                                            throw 'Could not launch $exchangeRatesApi';
                                                          }
                                                        },
                                                      )
                                                    ]
                                                  )
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
                ]
              )
            )
          )
        );
      }
    );
  }
}