import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:homeaccountantapp/icons_list.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/generic_header.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/models.dart';
import 'package:homeaccountantapp/database/queries/queries.dart';
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
  bool errorCategory = false;
  bool errorSubcategory = false;
  bool errorIcon = false;

  void resetState(Store<AppState> _store) {
    /// When selecting a subcategory from a new transaction, we should not
    /// reset the category as we need it in the previous screen, which is
    /// the subcategory screen (category card with list of subcategories).
    if (!_store.state.isSelectingSubcategory) {
      _store.dispatch(SelectCategory(null));
    }
    _store.dispatch(CategorySubcategoryId(null));
    _store.dispatch(CategorySelectSubcategoryIcon(null));
    _store.dispatch(CategorySubcategoryText(TextEditingController()));
    _store.dispatch(IsSelectingSubcategory(false));
    _store.dispatch(IsCreatingSubcategory(false));
  }

  changeIcon(_iconData, color, _store) {
    Icon icon = Icon(
      _iconData,
      size: MediaQuery.of(context).size.width * 0.3,
      color: color
    );
    _store.dispatch(CategorySelectSubcategoryIcon(icon));
  }

  _pickIcon(Store<AppState> _store) async {
    final _iconData = await FlutterIconPicker.showIconPicker(context);
    final color = getCategoryColor(_store.state.categoryIndex) == null ?
      baseColors.mainColor :
      getCategoryColor(_store.state.categoryIndex);
    if (_iconData != null) {
      changeIcon(_iconData, color, _store);
    }
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
              resizeToAvoidBottomPadding: false,
              body: Center(
                child: Column(
                  children: [
                    GenericHeader('Subcategory', true, () {
                      resetState(_store);
                      _store.dispatch(NavigatePopAction());
                      Navigator.of(context).pop();
                    }),
                    Expanded(
                      child: Container(
                        color: baseColors.mainColor,
                        child: Container(
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)
                          ),
                          color: Colors.white
                          ),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.85,
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10)
                                      ),
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
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              child: Padding(
                                                padding: EdgeInsets.all(25.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 7,
                                                          child: Text(
                                                            'Category',
                                                            style: GoogleFonts.lato(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: baseFontSize.text
                                                            ),
                                                          )
                                                        ),
                                                        Expanded(
                                                          flex: 13,
                                                          /// Dropdown to select the category
                                                          child: DropdownButtonHideUnderline(
                                                            child: ButtonTheme(
                                                              alignedDropdown: true,
                                                              child: Card(
                                                                color: baseColors.tertiaryColor,
                                                                margin: EdgeInsets.zero,
                                                                shape: RoundedRectangleBorder(
                                                                  side: BorderSide(color: errorCategory ? baseColors.errorColor : baseColors.transparent)
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: 15.0),
                                                                    Icon(Icons.label, size: 18.0),
                                                                    Expanded(
                                                                      child: FutureBuilder(
                                                                        future: readCategories(databaseClient.db),
                                                                        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
                                                                          if (snapshot.hasData) {
                                                                            return DropdownButton<int>(
                                                                              icon: Icon(Icons.keyboard_arrow_down),
                                                                              value: _store.state.categoryIndex,
                                                                              hint: Text(
                                                                                'Category',
                                                                                textAlign: TextAlign.center,
                                                                                style: GoogleFonts.lato(color: baseColors.secondaryColor, fontSize: baseFontSize.text)
                                                                              ),
                                                                              isDense: false,
                                                                              onTap: () {
                                                                                if (!currentFocus.hasPrimaryFocus) {
                                                                                  currentFocus.unfocus();
                                                                                }
                                                                              },
                                                                              onChanged: (int newValue) {
                                                                                setState(() {
                                                                                  errorCategory = false;
                                                                                });
                                                                                _store.dispatch(SelectCategory(newValue));
                                                                                if (_store.state.categorySubcategoryIcon != null) {
                                                                                  Color color = getCategoryColor(_store.state.categoryIndex) == null ?
                                                                                      baseColors.mainColor :
                                                                                      getCategoryColor(_store.state.categoryIndex);
                                                                                  changeIcon(_store.state.categorySubcategoryIcon.icon, color, _store);
                                                                                }
                                                                              },
                                                                              items: List.generate(snapshot.data.length, (int index) {
                                                                                return DropdownMenuItem<int>(
                                                                                  value: snapshot.data[index].categoryId,
                                                                                  child: Text(snapshot.data[index].categoryName, style: GoogleFonts.lato(fontSize: baseFontSize.text))
                                                                                );
                                                                              })
                                                                            );
                                                                          } else {
                                                                            return Container();
                                                                          }
                                                                        }
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 15.0)
                                                                  ],
                                                                )
                                                              )
                                                            )
                                                          )
                                                        ),
                                                      ]
                                                    ),
                                                    SizedBox(height: 12.0),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 7,
                                                          child: Text(
                                                            'Subcategory',
                                                            style: GoogleFonts.lato(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: baseFontSize.text,
                                                            ),
                                                          )
                                                        ),
                                                        Expanded(
                                                          flex: 13,
                                                          /// Name of the subcategory
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: baseColors.tertiaryColor,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.35),
                                                                  spreadRadius: 0,
                                                                  blurRadius: 0,
                                                                  offset: Offset(1, 1), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: TextField(
                                                              controller: _store.state.categorySubcategoryText,
                                                              style: GoogleFonts.lato(fontSize: baseFontSize.text),
                                                              decoration: InputDecoration(
                                                                errorText: errorSubcategory ? '' : null,
                                                                errorStyle: GoogleFonts.lato(height: 0),
                                                                isDense: false,
                                                                alignLabelWithHint: true,
                                                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: baseColors.errorColor)),
                                                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                                                contentPadding: EdgeInsets.only(right: 20.0),
                                                                hintText: 'Subcategory',
                                                                prefixIcon: Icon(Icons.turned_in, color: baseColors.mainColor),
                                                              ),
                                                              onChanged: (string) {
                                                                setState(() {
                                                                  errorSubcategory = false;
                                                                });
                                                              },
                                                            )
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                    SizedBox(height: 12.0),
                                                    _store.state.categorySubcategoryIcon == null ? SizedBox(height: 12.0) : Column(
                                                      children: [
                                                        SizedBox(height: 12.0),
                                                        _store.state.categorySubcategoryIcon
                                                      ]
                                                    ),
                                                    SizedBox(height: 12.0),
                                                    /// Icon of the subcategory
                                                    RaisedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          errorIcon = false;
                                                        });
                                                        _pickIcon(_store);
                                                      },
                                                      child: Text(
                                                        'Pick an icon',
                                                        style: GoogleFonts.lato(
                                                          fontSize: baseFontSize.text,
                                                          color: Colors.white
                                                        )
                                                      ),
                                                      color: baseColors.blue,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(40.0),
                                                      ),
                                                    ),
                                                    Text(
                                                      errorIcon ? 'Choose an icon' : '',
                                                      style: GoogleFonts.lato(
                                                        fontSize: baseFontSize.text,
                                                        color: baseColors.errorColor
                                                      ),
                                                    ),
                                                    SizedBox(height: 24.0),
                                                    /// Validate and cancel the operation
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        RaisedButton(
                                                          onPressed: () {
                                                            if (!_store.state.isCreatingSubcategory) {
                                                              showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return AlertDialog(
                                                                    title: Text('Are you sure ?'),
                                                                    content: Text('Deleting this subcategory will affect the transactions that are tagged with this subcategory. Are you sure you want to delete this subcategory?'),
                                                                    actions: [
                                                                      FlatButton(
                                                                        child: Text('Cancel'),
                                                                        onPressed: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                      ),
                                                                      FlatButton(
                                                                        child: Text('Confirm'),
                                                                        onPressed: () async {
                                                                          await deleteSubcategory(databaseClient.db, _store.state.categorySubcategoryId);
                                                                          resetState(_store);
                                                                          _store.dispatch(NavigatePopAction());
                                                                          Navigator.of(context).pop();
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                }
                                                              );
                                                            } else {
                                                              resetState(_store);
                                                              _store.dispatch(NavigatePopAction());
                                                              Navigator.of(context).pop();
                                                            }
                                                          },
                                                          child: Text(
                                                            _store.state.isCreatingSubcategory ? 'CANCEL' : 'DELETE',
                                                            style: GoogleFonts.lato(
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
                                                          onPressed: () async {
                                                            if (_store.state.categoryIndex == null) {
                                                              setState(() {
                                                                errorCategory = true;
                                                              });
                                                            }
                                                            if (_store.state.categorySubcategoryText.text == '') {
                                                              setState(() {
                                                                errorSubcategory = true;
                                                              });
                                                            }
                                                            if (_store.state.categorySubcategoryIcon == null) {
                                                              setState(() {
                                                                errorIcon = true;
                                                              });
                                                            }
                                                            if (!errorCategory && !errorSubcategory && !errorIcon){
                                                              if (_store.state.isCreatingSubcategory) {
                                                                Subcategory subcategory = Subcategory(
                                                                  categoryId: _store.state.categoryIndex,
                                                                  subcategoryName: _store.state.categorySubcategoryText.text,
                                                                  subcategoryIconId: icons_list.indexOf(_store.state.categorySubcategoryIcon.icon)
                                                                );
                                                                await createSubcategory(databaseClient.db, subcategory);
                                                              } else {
                                                                Subcategory subcategory = Subcategory(
                                                                  subcategoryId: _store.state.categorySubcategoryId,
                                                                  categoryId: _store.state.categoryIndex,
                                                                  subcategoryName: _store.state.categorySubcategoryText.text,
                                                                  subcategoryIconId: icons_list.indexOf(_store.state.categorySubcategoryIcon.icon)
                                                                );
                                                                await updateSubcategory(databaseClient.db, subcategory);
                                                              }
                                                              _store.dispatch(NavigatePopAction());
                                                              resetState(_store);
                                                              Navigator.of(context).pop();
                                                            }
                                                          },
                                                          child: Text(
                                                            'VALIDATE',
                                                            style: GoogleFonts.lato(
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
                                                  ]
                                                )
                                              )
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
                        )
                      )
                    )
                  ]
                )
              )
            )
          )
        );
      }
    );
  }
}