import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/database/models/subcategories.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the category card.
/// It displays the subcategory of a certain category.
/// It is used in two different places and has two different interactions:
/// 1: from the categories page, where tapping a subcategory navigates to the update page
/// 2: from the transactions page, where selecting a subcategory updates to form
///


class CategoryCard extends StatelessWidget {
  final int categoryIndex;
  final String category;
  final List<Subcategory> subcategories;
  final Color color;
  final bool select;

  CategoryCard(this.categoryIndex, this.category, this.subcategories, this.color, this.select);

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
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
              padding: EdgeInsets.all(20.0),
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
                          /// Subcategories in a grid
                          GridView.count(
                            padding: EdgeInsets.only(top: 20.0),
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            childAspectRatio: 2,
                            crossAxisCount: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 5 : 3,
                            children: List.generate(subcategories.length, (int index) {
                              return Material(
                                color: baseColors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    /// Updating the form
                                    if (select) {
                                      TextEditingController subcategoryText = TextEditingController();
                                      subcategoryText.text = subcategories[index].subcategoryName;
                                      _store.dispatch(TransactionSubcategoryText(subcategoryText));
                                      _store.dispatch(TransactionSelectSubcategoryIcon(
                                        Icon(
                                          icons_list[subcategories[index].subcategoryIconId],
                                          color: color
                                        )
                                      ));
                                      _store.dispatch(NavigatePopAction());
                                      Navigator.of(context).pop();
                                    } else {
                                      /// Updating the subcategory
                                      _store.dispatch(IsCreating(false));
                                      _store.dispatch(SelectCategory(categoryIndex));
                                      _store.dispatch(CategorySubcategoryId(subcategories[index].subcategoryId));
                                      TextEditingController subcategoryText = TextEditingController();
                                      subcategoryText.text = subcategories[index].subcategoryName;
                                      _store.dispatch(CategorySubcategoryText(subcategoryText));
                                      _store.dispatch(CategorySelectSubcategoryIcon(
                                        Icon(
                                          icons_list[subcategories[index].subcategoryIconId],
                                          color: color,
                                          size: MediaQuery.of(context).size.width * 0.3
                                        )
                                      ));
                                      _store.dispatch(NavigatePushAction(AppRoutes.category));
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(icons_list[subcategories[index].subcategoryIconId], color: color),
                                      Text(
                                        subcategories[index].subcategoryName,
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