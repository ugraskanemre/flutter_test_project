import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<dynamic> _list = [];

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  void _initPage() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await Dio().get('https://www.reddit.com/r/TechNewsToday/top.json?count=20');
      print(response.data["data"]["children"]);
      _list = response.data["data"]["children"];
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  List<Widget> _getList() {
    List<Widget> lst = List();

    if (_list != null && _list.length > 0) {
      _list.forEach((p) async {
        print(p);
        print("-----------------------------");

        lst.add(Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ListTile(
                dense: false,
                contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                title: Text(
                  "Title: ${p["data"]["title"]}",
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${p["data"]["name"]}"),
                    Text("Subreddit: ${p["data"]["subreddit"]}"),
                    Text("Saved: ${p["data"]["saved"]}"),
                    Text("Subreddit Name Prefix: ${p["data"]["subreddit_name_prefixed"]}"),
                    Text("Subreddit ID: ${p["data"]["subreddit_id"]}"),
                  ],
                ),
                leading: Image.network(
                  p["data"]["thumbnail"],
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
              child: Divider(
                color: Colors.amberAccent,
                height: 2,
              ),
            ),
          ],
        ));
      });
      return lst;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/img/logo-dark.png',
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(bottom: 25, top: 15),
            physics: BouncingScrollPhysics(),
            children: []..addAll(
                _getList(),
              ),
          ),
          isLoading ? Center(child: CircularProgressIndicator()) : Container()
        ],
      ),
    );
  }
}
