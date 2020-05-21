import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/data.dart';
import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the transaction item widget.
/// It is the basic element widget for a transaction.
///


class TransactionItem extends StatelessWidget {
  final List<dynamic> transactions;

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
                                    transactions[index].containsKey('subcategory_id') ?
                                    Icon(
                                      icons_list[findSubcategoryFromId(transactions[index]['subcategory_id'], categories)['icon_id']],
                                      color: getCategoryColor(transactions[index]['category_id'])
                                    ) :
                                    Icon(
                                      icons_list[transactions[index]['category_id']],
                                      color: getCategoryColor(transactions[index]['category_id'])
                                    )
                                  ],
                                ),
                                /// Text information of the transaction (date, name, description)
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(transactions[index]['date'], style: TextStyle(fontSize: baseFontSize.text2)),
                                    Text(transactions[index]['transaction_name'], style: TextStyle(fontSize: baseFontSize.subtitle, fontWeight: FontWeight.bold)),
                                  ]
                                ),
                                subtitle: transactions[index]['description'] == '' ?
                                  null :
                                  Text(transactions[index]['description'], style: TextStyle(fontSize: baseFontSize.text2)),
                                /// Amount of the transaction
                                trailing: Text(
                                  (transactions[index]['is_expense'] == 0 ? '+' : '-') + transactions[index]['amount'].toString(),
                                  style: TextStyle(
                                    fontSize: baseFontSize.subtitle,
                                    fontWeight: FontWeight.bold,
                                    color: transactions[index]['is_expense'] == 0 ? baseColors.green : baseColors.red
                                  )
                                ),
                                /// Navigates to the update page on tap
                                onTap: () {
                                  print('Tapped tile ' + transactions[index]['id'].toString());
                                  TextEditingController transactionName = TextEditingController();
                                  transactionName.text = transactions[index]['transaction_name'];
                                  TextEditingController transactionDate = TextEditingController();
                                  transactionDate.text = transactions[index]['date'];
                                  Map<String, dynamic> subcategory = findSubcategoryFromId(transactions[index]['subcategory_id'], categories);
                                  TextEditingController subcategoryText = TextEditingController();
                                  Icon subcategoryIcon;
                                  /// Get the icon of the category if no subcategory is selected
                                  // TODO: Defines a icon for each category
                                  if (subcategory != null) {
                                    subcategoryText.text = subcategory['name'];
                                    subcategoryIcon = Icon(
                                      icons_list[findSubcategoryFromId(transactions[index]['subcategory_id'], categories)['icon_id']],
                                      color: getCategoryColor(transactions[index]['category_id'])
                                    );
                                  } else {
                                    subcategoryIcon = Icon(
                                      icons_list[transactions[index]['category_id']],
                                      color: getCategoryColor(transactions[index]['category_id'])
                                    );
                                  }
                                  TextEditingController transactionAmount = TextEditingController();
                                  transactionAmount.text = transactions[index]['amount'].toString();
                                  TextEditingController transactionDescription = TextEditingController();
                                  transactionDescription.text = transactions[index]['description'];
                                  _store.dispatch(TransactionName(transactionName));
                                  _store.dispatch(TransactionAccount(transactions[index]['account_id']));
                                  _store.dispatch(TransactionDate(transactionDate));
                                  _store.dispatch(TransactionIsExpense(transactions[index]['is_expense'] == 1));
                                  _store.dispatch(SelectCategory(transactions[index]['category_id']));
                                  _store.dispatch(SelectSubcategory(subcategory));
                                  _store.dispatch(SubcategoryText(subcategoryText));
                                  _store.dispatch(SelectSubcategoryIcon(subcategoryIcon));
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