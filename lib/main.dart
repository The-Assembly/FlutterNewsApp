import 'package:flutter/material.dart';
import 'CategoriesScreen.dart' as CategoriesScreen;
import 'SavedArticlesScreen.dart' as SavedArticlesScreen;
import 'HomeFeedScreen.dart' as HomeFeedScreen;
import 'globalStore.dart' as globalStore;

void main() => runApp(new MaterialApp(home: new HomeTab()));

class HomeTab extends StatefulWidget {
  // This widget is the root of your application.
  @override
  createState() => new HomeScreen();
  
}

 Future ensureLogIn() async {
   await globalStore.logIn;
  }


class HomeScreen extends State<HomeTab> with TickerProviderStateMixin {

  
  @override
  Widget build(BuildContext context) {
    
   TabController controller;
   // controller = new TabController(initialIndex: 0, length: 4,vsync:this);
    controller = new TabController(vsync: this, length: 3);
   
        return new Scaffold(  
          appBar: new AppBar(  
            title: new Text("News API"),
            backgroundColor: Colors.red[700],
            centerTitle: true,
          ),
          bottomNavigationBar: new Material( 
            color: Colors.red[700],
            child: new TabBar(controller: controller,tabs: <Tab>[ 
              new Tab(icon: new Icon(Icons.explore,size: 30.0)),
              new Tab(icon: new Icon(Icons.view_module,size: 30.0)),
              new Tab(icon: new Icon(Icons.collections_bookmark,size: 30.0)),
             
        ]),
      ),
      body: new TabBarView(controller: controller,children: <Widget>[ 
        new HomeFeedScreen.HomeScreen(), 
        new CategoriesScreen.CategoriesScreen(),
        new SavedArticlesScreen.SavedArticlesScreen(),
        
        

      ],),
    );
}







}



