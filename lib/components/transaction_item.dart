import 'package:flutter/material.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/utils.dart';

class TransactionItem extends StatelessWidget {
  final String date;
  final List<dynamic> transactions;

  TransactionItem(
    this.date,
    this.transactions
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
//          shape: RoundedRectangleBorder(
//            side: BorderSide(color: baseColors.mainColor.withOpacity(0.5))
//          ),
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
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                this.date,
                                style: TextStyle(fontSize: baseFontSize.subtitle, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]
                        ),
                        Divider()
                      ]..addAll(
                        List.generate(transactions.length, (int index) {
                          return Material(
                            color: Colors.white,
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  transactions[index].containsKey('subcategory_id') ?
                                  Icon(icons_list[transactions[index]['subcategory_id']], color: getCategoryColor(transactions[index]['category_id'])) :
                                  Icon(icons_list[transactions[index]['category_id']], color: getCategoryColor(transactions[index]['category_id']))
                                ],
                              ),
                              title: Text(transactions[index]['transaction_name'], style: TextStyle(fontSize: baseFontSize.text)),
                              subtitle: transactions[index]['description'] == '' ?
                                null :
                                Text(transactions[index]['description'], style: TextStyle(fontSize: baseFontSize.text2)),
                              trailing: Text(
                                (transactions[index]['isExpense'] == 0 ? '+' : '-') + transactions[index]['amount'].toString(),
                                style: TextStyle(
                                  fontSize: baseFontSize.subtitle,
                                  fontWeight: FontWeight.bold,
                                  color: transactions[index]['isExpense'] == 0 ? baseColors.green : baseColors.red
                                )
                              ),
                              onTap: () {
                                print('Tapped tile ' + transactions[index]['id'].toString());
                              }
                            )
                          );
                        })
                      ),
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
}