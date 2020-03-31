import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = List<Item>();
  HomePage() {
    items = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var textCtrl = TextEditingController();

  _HomePageState() {
    load();
  }

  void add() {
    if (textCtrl.text.isEmpty) return null;
    setState(() {
      widget.items.add(Item(title: textCtrl.text, done: false));
      textCtrl.clear();
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: textCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
              labelText: "Nova Tarefa",
              labelStyle: TextStyle(
                color: Colors.white,
              )),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctx, int index) {
          var item = widget.items[index];
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            key: Key(item.title),
            background: Container(color: Colors.red.withOpacity(0.2)),
            onDismissed: (direction) {
              remove(index);
            },
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: add),
    );
  }
}

class _HomePageState2 extends State<HomePage> {
  var textCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo app"),
        leading: Icon(Icons.menu),
      ),
      body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 1,
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Nova Tarefa",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  )),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (BuildContext ctx, int index) {
                var item = widget.items[index];
                return CheckboxListTile(
                  title: Text(item.title),
                  key: Key(item.title),
                  value: item.done,
                  onChanged: (value) {
                    setState(() {
                      item.done = value;
                    });
                  },
                );
              },
            ),
          ]),
    );
  }
}
