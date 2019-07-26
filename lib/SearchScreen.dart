import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:timeago/timeago.dart';

class SearchScreen extends StatefulWidget {

 SearchScreen({
    Key key,
    this.searchQuery = "",
  })
      : super(key: key);
  final searchQuery;

  @override
  _SearchScreenState createState() =>
      new _SearchScreenState(searchQuery: this.searchQuery);

}

class _SearchScreenState extends State<SearchScreen> {
  _SearchScreenState({this.searchQuery});

var searchQuery;
var data;

 DataSnapshot snapshot;
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();


  void initState() {
    super.initState();
    this.getData();
  }

 Future getData() async {
    var response = await http.get(
        Uri.encodeFull('https://newsapi.org/v2/everything?q=' +
            searchQuery +
            '&sortBy=popularity'),
        headers: {
          "Accept": "application/json",
          "X-Api-Key": "306b0b4c8a9a4fc2b9df9a9ad997e9e6"
        });

    if (mounted) {
      this.setState(() {
        data = json.decode(response.body);
      });
    }
    return "Success!";
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(searchQuery),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: data == null
          ? const Center(child: const CircularProgressIndicator())
          : data["articles"].length < 1
              ? new Padding(
                  padding: new EdgeInsets.only(top: 60.0),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Icon(Icons.error_outline,
                            size: 60.0, color: Colors.redAccent[200]),
                        new Center(
                          child: new Text(
                            "Could not find anything related to '$searchQuery'",
                            textScaleFactor: 1.5,
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      ]))
              : new ListView.builder(
                  itemCount: data['articles'].length < 51
                      ? data['articles'].length
                      : 50,
                  itemBuilder: (BuildContext context, int index) {
                    return new GestureDetector(
                      child: new Card(
                        elevation: 1.7,
                        child: new Padding(
                          padding: new EdgeInsets.all(10.0),
                          child: new Column(
                            children: [
                              new Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: new EdgeInsets.only(left: 4.0),
                                    child: new Text(
                                      timeAgo(DateTime.parse(data["articles"]
                                          [index]["publishedAt"])),
                                      style: new TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.all(5.0),
                                    child: new Text(
                                      data["articles"][index]["source"]["name"],
                                      style: new TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              new Row(
                                children: [
                                  new Expanded(
                                    child: new GestureDetector(
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          new Padding(
                                            padding: new EdgeInsets.only(
                                                left: 4.0,
                                                right: 8.0,
                                                bottom: 8.0,
                                                top: 8.0),
                                            child: new Text(
                                              data["articles"][index]["title"],
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          new Padding(
                                            padding: new EdgeInsets.only(
                                                left: 4.0,
                                                right: 4.0,
                                                bottom: 4.0),
                                            child: new Text(
                                              data["articles"][index]
                                                  ["description"],
                                              style: new TextStyle(
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        flutterWebviewPlugin.launch(
                                            data["articles"][index]["url"],
                                         //   fullScreen: false
                                        );
                                      },
                                    ),
                                  ),
                                  new Column(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.only(top: 8.0),
                                        child: new SizedBox(
                                          height: 100.0,
                                          width: 100.0,
                                          child: new Image.network(
                                            data["articles"][index]
                                                ["urlToImage"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    ); 
  }
}