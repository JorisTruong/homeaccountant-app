import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/const.dart';
import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/components/navigation_drawer.dart';
import 'package:homeaccountantapp/redux/actions/actions.dart';
import 'package:homeaccountantapp/redux/models/models.dart';


///
/// This is the about us page.
///


class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    Store<AppState> _store = getStore(context);

    return StoreConnector<AppState, List<String>>(
        converter: (Store<AppState> store) => store.state.route,
        builder: (BuildContext context, List<String> route) {
          return WillPopScope(
            onWillPop: () {
              _store.dispatch(NavigatePopAction());
              print(_store.state);
              return Future(() => true);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'About us',
                  style: TextStyle(
                    fontSize: baseFontSize.title
                  ),
                ),
                centerTitle: true,
                actions: <Widget>[
                ],
              ),
              /// This is the drawer accessible from a left-to-right swipe or the top left icon.
              drawer: NavigationDrawer(),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lorem Ipsum',
                          style: TextStyle(
                            fontSize: baseFontSize.bigTitle,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ]
                    ),
                    SizedBox(height: 32),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            ' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce efficitur risus quis rhoncus fringilla. Suspendisse non metus ultrices, mattis diam convallis, bibendum nisi. Quisque gravida nisi sed felis interdum viverra. In pretium et quam non egestas. Pellentesque ullamcorper mi ac risus porta, id convallis tellus suscipit. In egestas lectus ac luctus sollicitudin. Quisque lectus sem, commodo sit amet velit sit amet, finibus lobortis ligula. Etiam ac risus auctor, lobortis felis in, vulputate ex. Nulla scelerisque tincidunt metus a tempor. In id velit tincidunt est fringilla faucibus. Nulla felis justo, congue id velit eu, facilisis euismod sem. Phasellus ac justo egestas, pulvinar nisi a, commodo mauris. Fusce porta tortor ut elementum consequat.',
                            style: TextStyle(
                              fontSize: baseFontSize.title
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Nullam consectetur augue quis lectus faucibus, sodales porttitor quam laoreet. Duis sed libero malesuada, consequat lorem nec, ultricies nunc. Vivamus sit amet purus erat. Cras in dui facilisis, condimentum quam et, cursus tellus. Integer aliquet lorem dolor. Pellentesque ac accumsan augue, tristique blandit metus. Vestibulum mi magna, imperdiet lacinia orci quis, tempus viverra orci. Duis elementum condimentum vulputate. Phasellus ac odio vel arcu molestie suscipit. Maecenas sit amet suscipit mauris. Sed rhoncus condimentum nisl. Aenean vitae ante diam. Nulla convallis id ex ut auctor. Mauris mattis sit amet neque id tempus. Curabitur et posuere felis. Vestibulum ornare non sapien id convallis.',
                            style: TextStyle(
                              fontSize: baseFontSize.title
                            ),
                          )
                        ],
                      ),
                    )
                  ]
                )
              ),
            )
          );
        }
    );
  }
}