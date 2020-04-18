import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List options = [
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Categories', 'icon': Icons.category},
    {'name': 'Graphs', 'icon': Icons.pie_chart},
    {'name': 'Analyze', 'icon': Icons.show_chart},
    {'name': 'About us', 'icon': Icons.info_outline}
  ];

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
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            DrawerHeader(
              child: null,
              decoration: BoxDecoration(
                color: Colors.grey
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {print('Pressed');},
        child: Icon(Icons.add),
      ),
    );
  }
}