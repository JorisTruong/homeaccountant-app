import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/subcategories.dart';
import 'package:homeaccountantapp/database/models/transactions.dart' as t;
import 'package:homeaccountantapp/database/queries/subcategories.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the transaction item widget.
/// It is the basic element widget for a transaction.
///


class TransactionItem extends StatelessWidget {
  final List<t.Transaction> transactions;

  TransactionItem(
    this.transactions
  );

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return Column(
          children: [
            Card(
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
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(transactions.length, (int index) {
                            return Material(
                              color: Colors.white,
                              child: ListTile(
                                /// Icon of the transaction
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    transactions[index].subcategoryId != null ?
                                    FutureBuilder(
                                      future: subcategoryFromId(databaseClient.db, transactions[index].subcategoryId),
                                      builder: (BuildContext context, AsyncSnapshot<Subcategory> snapshot) {
                                        if (snapshot.hasData) {
                                          return Icon(
                                            icons_list[snapshot.data.subcategoryIconId],
                                            color: getCategoryColor(transactions[index].categoryId)
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ) :
                                    Icon(
                                      // TODO: Replace by the icon of the category
                                      icons_list[transactions[index].categoryId],
                                      color: getCategoryColor(transactions[index].categoryId)
                                    )
                                  ],
                                ),
                                /// Text information of the transaction (date, name, description)
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(transactions[index].date, style: TextStyle(fontSize: baseFontSize.text2)),
                                    Text(
                                      transactions[index].transactionName != null ? transactions[index].transactionName : '',
                                      style: TextStyle(fontSize: baseFontSize.subtitle, fontWeight: FontWeight.bold)
                                    ),
                                  ]
                                ),
                                subtitle: transactions[index].description == null ?
                                  null :
                                  Text(transactions[index].description, style: TextStyle(fontSize: baseFontSize.text2)),
                                /// Amount of the transaction
                                trailing: Text(
                                  (transactions[index].isExpense ? '-' : '+') + transactions[index].amount.toString(),
                                  style: TextStyle(
                                    fontSize: baseFontSize.subtitle,
                                    fontWeight: FontWeight.bold,
                                    color: transactions[index].isExpense ? baseColors.red : baseColors.green
                                  )
                                ),
                                /// Navigates to the update page on tap
                                onTap: () async {
                                  print('Tapped tile ' + transactions[index].transactionId.toString());
                                  _store.dispatch(IsCreatingTransaction(false));
                                  TextEditingController transactionName = TextEditingController();
                                  transactionName.text = transactions[index].transactionName;
                                  TextEditingController transactionDate = TextEditingController();
                                  transactionDate.text = transactions[index].date;
                                  TextEditingController subcategoryText = TextEditingController();
                                  Icon subcategoryIcon;
                                  /// Get the icon of the category if no subcategory is selected
                                  // TODO: Defines a icon for each category
                                  if (transactions[index].subcategoryId != null) {
                                    Subcategory subcategory = await subcategoryFromId(databaseClient.db, transactions[index].subcategoryId);
                                    subcategoryText.text = subcategory.subcategoryName;
                                    subcategoryIcon = Icon(
                                      icons_list[subcategory.subcategoryIconId],
                                      color: getCategoryColor(transactions[index].categoryId)
                                    );
                                  } else {
                                    subcategoryIcon = Icon(
                                      // TODO: Replace by the icon of the category
                                      icons_list[transactions[index].categoryId],
                                      color: getCategoryColor(transactions[index].categoryId)
                                    );
                                  }
                                  TextEditingController transactionAmount = TextEditingController();
                                  transactionAmount.text = transactions[index].amount.toString();
                                  TextEditingController transactionDescription = TextEditingController();
                                  transactionDescription.text = transactions[index].description;
                                  _store.dispatch(TransactionId(transactions[index].transactionId));
                                  _store.dispatch(TransactionName(transactionName));
                                  _store.dispatch(TransactionAccount(transactions[index].accountId));
                                  _store.dispatch(TransactionDate(transactionDate));
                                  _store.dispatch(TransactionIsExpense(transactions[index].isExpense));
                                  _store.dispatch(SelectCategory(transactions[index].categoryId));
                                  _store.dispatch(TransactionSubcategoryId(transactions[index].subcategoryId));
                                  _store.dispatch(TransactionSubcategoryText(subcategoryText));
                                  _store.dispatch(TransactionSelectSubcategoryIcon(subcategoryIcon));
                                  _store.dispatch(TransactionAmount(transactionAmount));
                                  _store.dispatch(TransactionDescription(transactionDescription));

                                  _store.dispatch(NavigatePushAction(AppRoutes.transaction));
                                }
                              )
                            );
                          })
                        )
                      )
                    ]
                  ),
                )
              )
            )
          ],
        );
      }
    );
  }
}