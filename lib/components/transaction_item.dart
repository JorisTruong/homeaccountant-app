import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/screen/categories.dart';

class TransactionItem extends StatelessWidget {
  final List<dynamic> transactions;

  TransactionItem(
    this.transactions
  );

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return Column(
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    new BoxShadow(
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
                                trailing: Text(
                                  (transactions[index]['is_expense'] == 0 ? '+' : '-') + transactions[index]['amount'].toString(),
                                  style: TextStyle(
                                    fontSize: baseFontSize.subtitle,
                                    fontWeight: FontWeight.bold,
                                    color: transactions[index]['is_expense'] == 0 ? baseColors.green : baseColors.red
                                  )
                                ),
                                onTap: () {
                                  print('Tapped tile ' + transactions[index]['id'].toString());
                                  var transactionName = TextEditingController();
                                  transactionName.text = transactions[index]['transaction_name'];
                                  var transactionDate = TextEditingController();
                                  transactionDate.text = transactions[index]['date'];
                                  var subcategory = findSubcategoryFromId(transactions[index]['subcategory_id'], categories);
                                  var subcategoryText = TextEditingController();
                                  var subcategoryIcon;
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
                                  var transactionAmount = TextEditingController();
                                  transactionAmount.text = transactions[index]['amount'].toString();
                                  var transactionDescription = TextEditingController();
                                  transactionDescription.text = transactions[index]['description'];
                                  StoreProvider.of<AppState>(context).dispatch(TransactionName(transactionName));
                                  StoreProvider.of<AppState>(context).dispatch(TransactionAccount(transactions[index]['account_id']));
                                  StoreProvider.of<AppState>(context).dispatch(TransactionDate(transactionDate));
                                  StoreProvider.of<AppState>(context).dispatch(TransactionIsExpense(transactions[index]['is_expense'] == 1));
                                  StoreProvider.of<AppState>(context).dispatch(SelectCategory(transactions[index]['category_id']));
                                  StoreProvider.of<AppState>(context).dispatch(SelectSubcategory(subcategory));
                                  StoreProvider.of<AppState>(context).dispatch(SubcategoryText(subcategoryText));
                                  StoreProvider.of<AppState>(context).dispatch(SelectSubcategoryIcon(subcategoryIcon));
                                  StoreProvider.of<AppState>(context).dispatch(TransactionAmount(transactionAmount));
                                  StoreProvider.of<AppState>(context).dispatch(TransactionDescription(transactionDescription));

                                  StoreProvider.of<AppState>(context).dispatch(NavigatePushAction(AppRoutes.transaction));
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