import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';

import 'categories.dart';


final accounts = [
  'Account 1',
  'Account 2',
  'Account 3',
  'Account 4',
  'Account 5'
];

class CategoryInfoPage extends StatefulWidget {
  CategoryInfoPage({Key key}) : super(key: key);

  @override
  _CategoryInfoPageState createState() => _CategoryInfoPageState();
}

class _CategoryInfoPageState extends State<CategoryInfoPage> with TickerProviderStateMixin {
  FocusScopeNode currentFocus;

  void resetState(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(SelectCategory(null));
    StoreProvider.of<AppState>(context).dispatch(SelectSubcategoryIcon(null));
    StoreProvider.of<AppState>(context).dispatch(SubcategoryText(TextEditingController()));
  }

  changeIcon(_iconData, color) {
    Icon icon = Icon(
        _iconData,
        size: MediaQuery.of(context).size.width * 0.3,
        color: color
    );
    StoreProvider.of<AppState>(context).dispatch(SelectSubcategoryIcon(icon));
  }

  _pickIcon() async {
    final _iconData = await FlutterIconPicker.showIconPicker(context);
    final color = getCategoryColor(StoreProvider.of<AppState>(context).state.categoryIndex) == null ?
      baseColors.mainColor :
      getCategoryColor(StoreProvider.of<AppState>(context).state.categoryIndex);
    changeIcon(_iconData, color);
  }

  @override
  Widget build(BuildContext context) {
    currentFocus = FocusScope.of(context);

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            resetState(context);
            StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
            print(StoreProvider.of<AppState>(context).state);
            return Future(() => true);
          },
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
                    resetState(context);
                    StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
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
                                                        value: StoreProvider.of<AppState>(context).state.categoryIndex,
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
                                                          StoreProvider.of<AppState>(context).dispatch(SelectCategory(newValue));
                                                          if (StoreProvider.of<AppState>(context).state.subcategoryIcon != null) {
                                                            Color color = getCategoryColor(StoreProvider.of<AppState>(context).state.categoryIndex) == null ?
                                                                baseColors.mainColor :
                                                                getCategoryColor(StoreProvider.of<AppState>(context).state.categoryIndex);
                                                            changeIcon(StoreProvider.of<AppState>(context).state.subcategoryIcon.icon, color);
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
                                          SizedBox(
                                            height: 12.0,
                                          ),
                                          TextField(
                                            controller: StoreProvider.of<AppState>(context).state.subcategoryText,
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
                                          StoreProvider.of<AppState>(context).state.subcategoryIcon == null ? SizedBox(height: 12.0) : Column(
                                            children: [
                                              SizedBox(height: 12.0),
                                              StoreProvider.of<AppState>(context).state.subcategoryIcon
                                            ]
                                          ),
                                          SizedBox(height: 12.0),
                                          RaisedButton(
                                            onPressed: _pickIcon,
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
                                          SizedBox(
                                            height: 24.0,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                onPressed: () {
                                                  resetState(context);
                                                  StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'CANCEL',
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
                                              SizedBox(
                                                width: 12.0
                                              ),
                                              RaisedButton(
                                                onPressed: () {
                                                  print(StoreProvider.of<AppState>(context).state.categoryIndex);
                                                  print(StoreProvider.of<AppState>(context).state.subcategoryText.text);
                                                  print(StoreProvider.of<AppState>(context).state.subcategoryIcon);
                                                  StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
                                                  resetState(context);
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