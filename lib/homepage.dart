import 'package:flutter/material.dart';
import 'package:homeaccountantapp/speed_dial.dart';
import 'package:homeaccountantapp/main_card.dart';

final String currency = "HKD";
final String amount = "250,000";

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  List options = [
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Categories', 'icon': Icons.category},
    {'name': 'Graphs', 'icon': Icons.pie_chart},
    {'name': 'Charts', 'icon': Icons.show_chart},
    {'name': 'About us', 'icon': Icons.info_outline}
  ];

  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 24
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.transparent,
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: new AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return new Icon(Icons.more_vert);
                }
              )
            )
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            DrawerHeader(
              child: null,
              decoration: BoxDecoration(
                color: Colors.grey[850]
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                Map item = options[index];
                return ListTile(
                  leading: Icon(item['icon']),
                  title: Text(
                    item['name'],
                    style: TextStyle(
                      fontSize: 20,
                    )
                  ),
                  onTap: () {
                    print('${item['name']} pressed');
                  },
                );
              },
            )
          ]
        )
      ),
      body: Center(
        child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainCard(currency, amount)
              ],
            )
          ),
          SpeedDialButton(_controller),
        ])
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {print('Add Transaction Pressed');},
        child: Icon(Icons.add),
      ),
    );
  }
}