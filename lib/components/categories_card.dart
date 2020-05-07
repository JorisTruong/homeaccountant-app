import 'package:flutter/material.dart';

import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/const.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final List<dynamic> subcategories;
  final Color color;

  CategoryCard(this.category, this.subcategories, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
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
                        style: TextStyle(color: baseColors.mainColor, fontWeight: FontWeight.bold, fontSize: baseFontSize.title)
                      ),
                      GridView.count(
                        padding: EdgeInsets.only(top: 20.0),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 5 : 3,
                        children: new List.generate(subcategories.length, (int index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icons_list[subcategories[index]['icon_id']], color: color),
                              Text(
                                subcategories[index]['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: baseFontSize.text2),
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
      )
    );
  }
}