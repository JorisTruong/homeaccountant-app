import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/database/models/categories.dart' as c;
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
  final c.Category category;
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
        return Container(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            Icon(icons_list[category.categoryIconId], color: color),
                            SizedBox(width: 12),
                            Text(
                              category.categoryName,
                              style: TextStyle(color: baseColors.mainColor, fontWeight: FontWeight.bold, fontSize: baseFontSize.title)
                            ),
                          ]
                        ),
                        Divider(color: baseColors.mainColor),
                        /// Subcategories in a grid
                        ListView(
                          padding: EdgeInsets.only(top: 10.0),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(subcategories.length, (int index) {
                            return Material(
                              color: baseColors.transparent,
                              child: InkWell(
                                onTap: () {
                                  /// Updating the form
                                  if (select) {
                                    _store.dispatch(TransactionSubcategoryId(subcategories[index].subcategoryId));
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
                                    _store.dispatch(IsCreatingSubcategory(false));
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
                                child: ListTile(
                                  leading: Icon(icons_list[subcategories[index].subcategoryIconId], color: color),
                                  title: Text(
                                    subcategories[index].subcategoryName,
                                    style: TextStyle(fontSize: baseFontSize.subtitle),
                                  )
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
        );
      }
    );
  }
}