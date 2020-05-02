import 'package:flutter/material.dart';

import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/const.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final List<dynamic> subcategories;

  CategoryCard(this.category, this.subcategories);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: TextStyle(color: baseColors.mainColor, fontWeight: FontWeight.bold, fontSize: 20)
                    ),
                    GridView.count(
                      padding: EdgeInsets.only(top: 50.0),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 5 : 3,
                      children: new List.generate(subcategories.length, (int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icons_list[subcategories[index]['icon_id']]),
                            Text(
                              subcategories[index]['name'],
                              textAlign: TextAlign.center,
                            )
                          ]
                        );
                      })
                    )
                  ]
                )
              ),
            )
          ],
        )
      )
    );
  }
}