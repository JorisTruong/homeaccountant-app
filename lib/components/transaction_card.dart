import 'package:flutter/material.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/components/transaction_item.dart';


///
/// This is the transaction card.
/// It is used as the parent card of a certain month transactions.
///


class TransactionCard extends StatelessWidget {
  final String month;
  final List<Map<String, dynamic>> transactions;

  TransactionCard(this.month, this.transactions);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[600],
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
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          /// Displays the month and year
                          child: Text(
                            month,
                            style: TextStyle(color: baseColors.mainColor, fontWeight: FontWeight.bold, fontSize: baseFontSize.title),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Container(
                            padding: EdgeInsets.only(bottom: transactions.isNotEmpty ? 15.0 : 0.0),
                            child: Center(
                              /// Displays the transactions
                              child: transactions.isNotEmpty ?
                                TransactionItem(transactions) :
                                null
                            )
                          )
                        )
                      ]
                    )
                  ),
                )
              ],
            )
          )
        )
      )
    );
  }
}