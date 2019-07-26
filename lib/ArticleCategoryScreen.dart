import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:timeago/timeago.dart';
import 'globalStore.dart' as globalStore;

class ArticleCategoryScreen extends StatefulWidget {
  ArticleCategoryScreen( 
    {Key key,
      this.catID = "",
      this.catName = ""})
    :super(key: key);
    final catID;
    final catName; 
    
  @override
 _ArticleCategoryScreenState createState() => new _ArticleCategoryScreenState( 
      catID: this.catID,
      catName: this.catName);
}

class WebView  extends StatefulWidget {
final String value;
  WebView({String key, this.value});

  @override
  State<StatefulWidget> createState() { 
    return WebViewState();
  }

}

class WebViewState extends State<WebView>{
 // Calling a New Class to open the webpages
  @override
  Widget build(BuildContext context) {
    String url =  widget.value;
    return WebviewScaffold(
      url: url ,
      appBar: AppBar(
        title: Text('WebView'),
        backgroundColor: Colors.blueGrey,
      ),
    ); 
  }


}

class _ArticleCategoryScreenState extends State<ArticleCategoryScreen> {
 _ArticleCategoryScreenState({this.catID, this.catName});
  
  final catID;
  final catName;
  bool change = false;
  
  var userDatabaseReference;
  var articleDatabaseReference;
  var data;

  @override
  Widget build(BuildContext context) { 
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(catName),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      
      body: data == null
          ? const Center(child: const CircularProgressIndicator())
          : data["articles"].length != 0
              ? new ListView.builder(
                  itemCount: data == null ? 0 : data["articles"].length,
                  padding: new EdgeInsets.all(8.0),
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
                                      
                                        String url = data["articles"][index]["url"];
                                       // print(Url);
                                        
                                      Navigator.push(context, new MaterialPageRoute(
                                            builder: (context) =>
                                           new WebView(value: url,)   )  
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
                                      new Row(
                                        children: <Widget>[
                                          new FlatButton(
                                            onPressed: () => _pushArticle(data["articles"][index]),
                                            child: Text(
                                              "Save Article",
                                            ),
                                          )                                                                              
                                        ],
                                        
                                      )
                                    ],
                                    
                                  ),
                                  
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Icon(Icons.chrome_reader_mode,
                          color: Colors.grey, size: 60.0),
                      new Text(
                        "No articles saved",
                        style:
                            new TextStyle(fontSize: 24.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
    );        
  }

  _pushArticle(article) {
    articleDatabaseReference.push().set({
      'source': article["source"]["name"],
      'description': article['description'],
      'publishedAt': article['publishedAt'],
      'title': article['title'],
      'url': article['url'],
      'urlToImage': article['urlToImage'],
   });
  }

  void initState() {
    super.initState();
    this.getData();    
  }

  Future getData() async{
    await globalStore.logIn;
    articleDatabaseReference = globalStore.articleDatabaseReference;
    userDatabaseReference = globalStore.userDatabaseReference;

    var response = await http.get(
        Uri.encodeFull('https://newsapi.org/v2/top-headlines?country=us&category=' +
            catID ),
        headers: {
          "Accept": "application/json",
          "X-Api-Key": "306b0b4c8a9a4fc2b9df9a9ad997e9e6"
        }
    );

    if (mounted) {
      this.setState(() {
        data = json.decode(response.body);
      });
    }
    return "Success";
  }
}

