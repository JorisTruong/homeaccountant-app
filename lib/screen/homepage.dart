import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/icons_list.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/loading_component.dart';
import 'package:homeaccountantapp/components/point_tab_bar.dart';
import 'package:homeaccountantapp/database/database.dart';
import 'package:homeaccountantapp/database/models/models.dart' as m;
import 'package:homeaccountantapp/database/queries/categories.dart';
import 'package:homeaccountantapp/database/queries/subcategories.dart';
import 'package:homeaccountantapp/database/queries/transactions.dart';
import 'package:homeaccountantapp/navigation/app_routes.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the home page.
///


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  AnimationController _animationController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _itemBuilder(BuildContext context, dynamic transactionSummary, _) {
    Store<AppState> _store = getStore(context);
    ExpandableController expandableController = ExpandableController(initialExpanded: false);
    String type = transactionSummary['date'].length == 10 ? 'Day' : transactionSummary['date'].length == 7 ? 'Month' : 'Year';
    DateTime dateTime = type == 'Year' ?
      DateFormat('yyyy').parse(transactionSummary['date']) :
      type == 'Month' ?
      DateFormat('yyyy-MM').parse(transactionSummary['date']) :
      DateTime.parse(transactionSummary['date']);
    Map<String, String> dateRange = dateToDateRange(type, dateTime);
    return FutureBuilder(
      future: readTransactions(databaseClient.db, dateRange, _store.state.accountId),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return Card(
            child: ExpandableNotifier(
              controller: expandableController,
              child: ScrollOnExpand(
                child: ExpandablePanel(
                  header: ListTile(
                    dense: true,
                    title: Text(
                      transactionSummary['date'],
                      style: GoogleFonts.lato(fontSize: baseFontSize.text)
                    ),
                    subtitle: (transactionSummary['date'].length == 10) ?
                      Text(
                        DateFormat('EEEE').format(DateTime.parse(transactionSummary['date'])),
                        style: GoogleFonts.lato(fontSize: baseFontSize.text2)
                      ) :
                      transactionSummary['date'].length ==  7 ?
                      Text(
                        getMonth(transactionSummary['date'].split('-')[1]),
                        style: GoogleFonts.lato(fontSize: baseFontSize.text2)
                      ) :
                      null,
                    trailing: Wrap(
                      spacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: math.pi / 1.35,
                          child: Icon(Icons.undo, color: baseColors.green)
                        ),
                        Text(
                          transactionSummary['total_income'].toStringAsFixed(2),
                          style: GoogleFonts.lato(fontSize: baseFontSize.text)
                        ),
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Transform.rotate(
                            angle: -math.pi / 4,
                            child: Transform.translate(
                              offset: Offset(0.0, -5),
                              child: Icon(Icons.undo, color: baseColors.red)
                            )
                          )
                        ),
                        Text(
                          transactionSummary['total_expenses'].toStringAsFixed(2),
                          style: GoogleFonts.lato(fontSize: baseFontSize.text)
                        )
                      ]
                    )
                  ),
                  expanded: Column(
                    children: [
                      Divider(color: baseColors.mainColor, height: 1),
                      ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(5),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FutureBuilder(
                            future: snapshot.data[index].subcategoryId == null ?
                              categoryFromId(databaseClient.db, snapshot.data[index].categoryId) :
                              Future.wait([
                                categoryFromId(databaseClient.db, snapshot.data[index].categoryId),
                                subcategoryFromId(databaseClient.db, snapshot.data[index].subcategoryId)
                              ]),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> tags) {
                              if (tags.hasData) {
                                return Material(
                                  color: baseColors.tertiaryColor,
                                  child: ListTile(
                                    onTap: () async {
                                      _store.dispatch(IsCreatingTransaction(false));
                                      TextEditingController transactionName = TextEditingController();
                                      transactionName.text = snapshot.data[index].transactionName;
                                      TextEditingController transactionDate = TextEditingController();
                                      transactionDate.text = snapshot.data[index].date;
                                      TextEditingController subcategoryText = TextEditingController();
                                      Icon subcategoryIcon;
                                      /// Get the icon of the category if no subcategory is selected
                                      if (snapshot.data[index].subcategoryId != null) {
                                        m.Subcategory subcategory = await subcategoryFromId(databaseClient.db, snapshot.data[index].subcategoryId);
                                        subcategoryText.text = subcategory.subcategoryName;
                                        subcategoryIcon = Icon(
                                            icons_list[subcategory.subcategoryIconId],
                                            color: getCategoryColor(snapshot.data[index].categoryId)
                                        );
                                      } else {
                                        m.Category category = await categoryFromId(databaseClient.db, snapshot.data[index].categoryId);
                                        subcategoryIcon = Icon(
                                            icons_list[category.categoryIconId],
                                            color: getCategoryColor(snapshot.data[index].categoryId)
                                        );
                                      }
                                      TextEditingController transactionAmount = TextEditingController();
                                      transactionAmount.text = snapshot.data[index].isExpense ? (-1 * snapshot.data[index].amount).toStringAsFixed(2) : snapshot.data[index].amount.toStringAsFixed(2);
                                      TextEditingController transactionDescription = TextEditingController();
                                      transactionDescription.text = snapshot.data[index].description;
                                      _store.dispatch(TransactionId(snapshot.data[index].transactionId));
                                      _store.dispatch(TransactionName(transactionName));
                                      _store.dispatch(TransactionAccount(snapshot.data[index].accountId));
                                      _store.dispatch(TransactionDate(transactionDate));
                                      _store.dispatch(TransactionIsExpense(snapshot.data[index].isExpense));
                                      _store.dispatch(SelectCategory(snapshot.data[index].categoryId));
                                      _store.dispatch(TransactionSubcategoryId(snapshot.data[index].subcategoryId));
                                      _store.dispatch(TransactionSubcategoryText(subcategoryText));
                                      _store.dispatch(TransactionSelectSubcategoryIcon(subcategoryIcon));
                                      _store.dispatch(TransactionAmount(transactionAmount));
                                      _store.dispatch(TransactionDescription(transactionDescription));

                                      _store.dispatch(NavigatePushAction(AppRoutes.transaction));
                                    },
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: Wrap(
                                        direction: Axis.vertical,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        alignment: WrapAlignment.center,
                                        children: [
                                          snapshot.data[index].subcategoryId == null ?
                                          Icon(
                                            snapshot.data[index].subcategoryId == null ? icons_list[tags.data.categoryIconId] : icons_list[tags.data[0].categoryIconId],
                                            color: getCategoryColor(snapshot.data[index].categoryId),
                                          )
                                          :
                                          Icon(
                                            icons_list[tags.data[1].subcategoryIconId],
                                            color: getCategoryColor(snapshot.data[index].categoryId)
                                          ),
                                          snapshot.data[index].subcategoryId == null ?
                                          Text(
                                            tags.data.categoryName,
                                            style: GoogleFonts.lato(
                                              color: baseColors.mainColor,
                                              fontSize: baseFontSize.text2
                                            )
                                          ) :
                                          Text(
                                            tags.data[0].categoryName,
                                            style: GoogleFonts.lato(
                                              color: baseColors.mainColor,
                                              fontSize: baseFontSize.text2
                                            )
                                          ),
                                          snapshot.data[index].subcategoryId == null ? Container() :
                                          Text(
                                            tags.data[1].subcategoryName,
                                            style: GoogleFonts.lato(
                                              color: baseColors.mainColor,
                                              fontSize: baseFontSize.legend
                                            )
                                          )
                                        ]
                                      )
                                    ),
                                    title: Text(
                                      snapshot.data[index].transactionName,
                                      style: GoogleFonts.lato(
                                        color: baseColors.mainColor,
                                        fontSize: baseFontSize.text,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                    subtitle: snapshot.data[index].description == '' ? null : Text(
                                      snapshot.data[index].description,
                                      style: GoogleFonts.lato(
                                        color: baseColors.mainColor,
                                        fontSize: baseFontSize.text
                                      )
                                    ),
                                    trailing: Text(
                                      (snapshot.data[index].isExpense ? '' : '+') + snapshot.data[index].amount.toStringAsFixed(2),
                                      style: GoogleFonts.lato(
                                        color: snapshot.data[index].isExpense ? baseColors.red : baseColors.green,
                                        fontSize: baseFontSize.text,
                                        fontWeight: FontWeight.bold
                                      )
                                    )
                                  )
                                );
                              } else {
                                return LoadingComponent(size: 1);
                              }
                            }
                          );
                        }
                      )
                    ]
                  ),
                  theme: ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                  ),
                )
              )
            )
          );
        } else {
          return LoadingComponent();
        }
      }
    );
  }

  Widget _noItemBuilder(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Center(
        child: Text("There are no transactions yet.\nGo ahead a save some transactions!", textAlign: TextAlign.center)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);
    PagewiseLoadController dailyPageLoadController = PagewiseLoadController(
      pageSize: transactionsPageSize,
      pageFuture: (pageIndex) async {
        return readDailyTransactions(databaseClient.db, _store.state.accountId, pageIndex * transactionsPageSize, transactionsPageSize);
      }
    );
    PagewiseLoadController monthlyPageLoadController = PagewiseLoadController(
      pageSize: transactionsPageSize,
      pageFuture: (pageIndex) async {
        return readMonthlyTransactions(databaseClient.db, _store.state.accountId, pageIndex * transactionsPageSize, transactionsPageSize);
      }
    );
    PagewiseLoadController yearlyPageLoadController = PagewiseLoadController(
      pageSize: transactionsPageSize,
      pageFuture: (pageIndex) async {
        return readYearlyTransactions(databaseClient.db, _store.state.accountId, pageIndex * transactionsPageSize, transactionsPageSize);
      }
    );

    return StoreConnector<AppState, List<String>>(
      converter: (Store<AppState> store) => store.state.route,
      builder: (BuildContext context, List<String> route) {
        return WillPopScope(
          onWillPop: () {
            _store.dispatch(NavigatePopAction());
            return Future(() => true);
          },
          /// The GestureDetector is for removing the speed dial when tapping the screen.
          child: GestureDetector(
            onTap: () {
              if (!_animationController.isDismissed) {
                _animationController.reverse();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: baseColors.mainColor,
                        border: Border.all(width: 0),
                      ),
                      height: MediaQuery.of(context).size.height * 0.25,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                future: getTotalBalance(databaseClient.db, null, _store.state.accountId),
                                builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.toStringAsFixed(2) + " €",
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: baseFontSize.title
                                      )
                                    );
                                  } else {
                                    return LoadingComponent();
                                  }
                                },
                              )
                            ]
                          ),
                          SizedBox(
                            height: 6
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total balance",
                                style: GoogleFonts.lato(
                                  color: baseColors.borderColor,
                                  fontSize: baseFontSize.subtitle
                                )
                              )
                            ]
                          ),
                          SizedBox(
                            height: 24
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FutureBuilder(
                                          future: getTotalIncome(databaseClient.db, _store.state.dateRange, _store.state.accountId),
                                          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                "+" + snapshot.data.toStringAsFixed(2) + " €",
                                                style: GoogleFonts.lato(
                                                    fontSize: baseFontSize.title2,
                                                    fontWeight: FontWeight.bold,
                                                    color: baseColors.green
                                                ),
                                              );
                                            } else {
                                              return LoadingComponent(size: 5);
                                            }
                                          },
                                        ),
                                        Text(
                                          "Income",
                                          style: GoogleFonts.lato(
                                            fontSize: baseFontSize.text,
                                            color: baseColors.secondaryColor
                                          ),
                                        )
                                      ]
                                    )
                                  ),
                                ),
                                SizedBox(width: 30),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FutureBuilder(
                                          future: getTotalExpense(databaseClient.db, null, _store.state.accountId),
                                          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                "-" + snapshot.data.toStringAsFixed(2) + " €",
                                                style: GoogleFonts.lato(
                                                    fontSize: baseFontSize.title2,
                                                    fontWeight: FontWeight.bold,
                                                    color: baseColors.red
                                                ),
                                              );
                                            } else {
                                              return LoadingComponent(size: 5);
                                            }
                                          },
                                        ),
                                        Text(
                                          "Expenses",
                                          style: GoogleFonts.lato(
                                            fontSize: baseFontSize.text,
                                            color: baseColors.secondaryColor
                                          ),
                                        )
                                      ]
                                    )
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
                          padding: EdgeInsets.only(top: 15, bottom: 30),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                PointTabBar(tabController: _tabController, length: 3, tabsName: ['Daily', 'Monthly', 'Yearly']),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: <Widget>[
                                        PagewiseListView(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
                                          physics: BouncingScrollPhysics(),
                                          pageLoadController: dailyPageLoadController,
                                          itemBuilder: this._itemBuilder,
                                          noItemsFoundBuilder: this._noItemBuilder,
                                        ),
                                        PagewiseListView(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
                                          physics: BouncingScrollPhysics(),
                                          pageLoadController: monthlyPageLoadController,
                                          itemBuilder: this._itemBuilder,
                                          noItemsFoundBuilder: this._noItemBuilder,
                                        ),
                                        PagewiseListView(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
                                          physics: BouncingScrollPhysics(),
                                          pageLoadController: yearlyPageLoadController,
                                          itemBuilder: this._itemBuilder,
                                          noItemsFoundBuilder: this._noItemBuilder,
                                        ),
                                      ],
                                    ),
                                  )
                                )
                              ],
                            )
                          )
                        ),
                      )
                    ),
                  ]
                )
              ),
              floatingActionButton: Visibility(
                visible: _store.state.visibility,
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      _store.dispatch(IsCreatingTransaction(true));
                      _store.dispatch(NavigatePushAction(AppRoutes.transaction));
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              )
            )
          )
        );
      }
    );
  }
}