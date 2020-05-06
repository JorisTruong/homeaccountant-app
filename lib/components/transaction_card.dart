import 'package:flutter/material.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/components/transaction_item.dart';


class TransactionCard extends StatelessWidget {
  final String month;
  final Map<String, List<dynamic>> transactions;

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
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              new BoxShadow(
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
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            month,
                            style: TextStyle(color: baseColors.mainColor, fontWeight: FontWeight.bold, fontSize: baseFontSize.title),
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 20.0),
                          shrinkWrap: true,
                          itemCount: transactions.length,
                          itemBuilder: (BuildContext context, int index) {
                            var day = transactions.keys.elementAt(index);
                            return Container(
                              padding: EdgeInsets.only(bottom: transactions[day].isNotEmpty ? 30.0 : 0.0),
                              child: Center(
                                child: transactions[day].isNotEmpty ?
                                  TransactionItem(
                                    month + ' ' + day, transactions[day]
                                  ) : null
                              )
                            );
                          },
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