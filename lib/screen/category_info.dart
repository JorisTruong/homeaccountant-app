import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/data.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the category info page.
/// It is used to create or update a subcategory.
///


class CategoryInfoPage extends StatefulWidget {
  CategoryInfoPage({Key key}) : super(key: key);

  @override
  _CategoryInfoPageState createState() => _CategoryInfoPageState();
}

class _CategoryInfoPageState extends State<CategoryInfoPage> with TickerProviderStateMixin {
  FocusScopeNode currentFocus;

  void resetState(Store<AppState> _store) {
    if (!_store.state.isSelectingSubcategory) {
      _store.dispatch(SelectCategory(null));
    }
    _store.dispatch(SelectSubcategoryIcon(null));
    _store.dispatch(SubcategoryText(TextEditingController()));
    _store.dispatch(IsSelectingSubcategory(false));
  }

  changeIcon(_iconData, color, _store) {
    Icon icon = Icon(
      _iconData,
      size: MediaQuery.of(context).size.width * 0.3,
      color: color
    );
    _store.dispatch(SelectSubcategoryIcon(icon));
  }

  _pickIcon(Store<AppState> _store) async {
    final _iconData = await FlutterIconPicker.showIconPicker(context);
    final color = getCategoryColor(_store.state.categoryIndex) == null ?
      baseColors.mainColor :
      getCategoryColor(_store.state.categoryIndex);
    changeIcon(_iconData, color, _store);
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);
    currentFocus = FocusScope.of(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            resetState(_store);
            _store.dispatch(NavigatePopAction());
            print(_store.state);
            return Future(() => true);
          },
          /// The GestureDetector is for removing the dropdown when tapping the screen.
          child: GestureDetector(
            onTap: () {
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    resetState(_store);
                    _store.dispatch(NavigatePopAction());
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  'Category Info',
                  style: TextStyle(
                    fontSize: baseFontSize.title
                  ),
                ),
                centerTitle: true,
                actions: <Widget>[
                ],
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 20.0,
                            left: 20.0,
                            right: 20.0,
                            bottom: 20.0 + MediaQuery.of(context).viewInsets.bottom
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
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
                              child: KeyboardAvoider(
                                autoScroll: true,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: LayoutBuilder(
                                    builder: (containerContext, containerConstraints) {
                                      return Column(
                                        children: [
                                          /// Dropdown to select the category
                                          DropdownButtonHideUnderline(
                                            child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: Card(
                                                margin: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40.0),
                                                  side: BorderSide(color: baseColors.borderColor)
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 15.0),
                                                    Icon(Icons.label, size: 18.0),
                                                    Expanded(
                                                      child: DropdownButton<int>(
                                                        icon: Icon(Icons.keyboard_arrow_down),
                                                        value: _store.state.categoryIndex,
                                                        hint: Text(
                                                          'Category',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: baseColors.secondaryColor)
                                                        ),
                                                        isDense: false,
                                                        onTap: () {
                                                          if (!currentFocus.hasPrimaryFocus) {
                                                            currentFocus.unfocus();
                                                          }
                                                        },
                                                        onChanged: (int newValue) {
                                                          _store.dispatch(SelectCategory(newValue));
                                                          if (_store.state.subcategoryIcon != null) {
                                                            Color color = getCategoryColor(_store.state.categoryIndex) == null ?
                                                                baseColors.mainColor :
                                                                getCategoryColor(_store.state.categoryIndex);
                                                            changeIcon(_store.state.subcategoryIcon.icon, color, _store);
                                                          }
                                                        },
                                                        items: List.generate(categories.length, (int index) {
                                                          return DropdownMenuItem<int>(
                                                            value: index,
                                                            child: Text(categories.keys.toList()[index])
                                                          );
                                                        })
                                                      ),
                                                    ),
                                                    SizedBox(width: 15.0)
                                                  ],
                                                )
                                              )
                                            )
                                          ),
                                          SizedBox(height: 12.0),
                                          /// Name of the subcategory
                                          TextField(
                                            controller: _store.state.subcategoryText,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              alignLabelWithHint: true,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
                                              contentPadding: EdgeInsets.only(right: 20.0),
                                              labelText: 'Subcategory',
                                              prefixIcon: Icon(Icons.turned_in, color: baseColors.mainColor)
                                            ),
                                          ),
                                          SizedBox(height: 12.0),
                                          _store.state.subcategoryIcon == null ? SizedBox(height: 12.0) : Column(
                                            children: [
                                              SizedBox(height: 12.0),
                                              _store.state.subcategoryIcon
                                            ]
                                          ),
                                          SizedBox(height: 12.0),
                                          /// Icon of the subcategory
                                          RaisedButton(
                                            onPressed: () {_pickIcon(_store);},
                                            child: Text(
                                              'Pick an icon',
                                              style: TextStyle(
                                                fontSize: baseFontSize.text,
                                                color: Colors.white
                                              )
                                            ),
                                            color: baseColors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                          ),
                                          SizedBox(height: 24.0),
                                          /// Validate and cancel the operation
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                onPressed: () {
                                                  resetState(_store);
                                                  _store.dispatch(NavigatePopAction());
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  _store.state.isCreating ? 'CANCEL' : 'DELETE',
                                                  style: TextStyle(
                                                    fontSize: baseFontSize.text,
                                                    color: Colors.white
                                                  )
                                                ),
                                                color: baseColors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40.0),
                                                ),
                                              ),
                                              SizedBox(width: 12.0),
                                              RaisedButton(
                                                onPressed: () {
                                                  print(_store.state.categoryIndex);
                                                  print(_store.state.subcategoryText.text);
                                                  print(_store.state.subcategoryIcon);
                                                  _store.dispatch(NavigatePopAction());
                                                  resetState(_store);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'VALIDATE',
                                                  style: TextStyle(
                                                    fontSize: baseFontSize.text,
                                                    color: Colors.white
                                                  )
                                                ),
                                                color: baseColors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40.0),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    }
                                  )
                                )
                              )
                            )
                          )
                        ),
                      )
                    )
                  );
                }
              )
            )
          )
        );
      }
    );
  }
}