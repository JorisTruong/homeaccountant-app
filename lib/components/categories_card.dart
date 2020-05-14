import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final List<dynamic> subcategories;
  final Color color;
  final bool select;

  CategoryCard(this.category, this.subcategories, this.color, this.select);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store<AppState> store) => store.state.subcategory,
      builder: (BuildContext context, Map<String, dynamic> subcategory) {
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
                              return Material(
                                color: baseColors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (select) {
                                      StoreProvider.of<AppState>(context).dispatch(SelectSubcategory(subcategories[index]));
                                      var subcategoryText = TextEditingController();
                                      subcategoryText.text = subcategories[index]['name'];
                                      StoreProvider.of<AppState>(context).dispatch(SelectSubcategoryText(subcategoryText));
                                      StoreProvider.of<AppState>(context).dispatch(SelectSubcategoryIcon(
                                        Icon(
                                          icons_list[subcategories[index]['icon_id']],
                                          color: color
                                        )
                                      ));
                                      StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
                                      Navigator.of(context).pop();
                                    } else {
                                      print('Update subcategory info');
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(icons_list[subcategories[index]['icon_id']], color: color),
                                      Text(
                                        subcategories[index]['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: baseFontSize.text2),
                                      )
                                    ]
                                  )
                                )
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
    );
  }
}