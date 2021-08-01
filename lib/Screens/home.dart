import 'package:applore_techno/Screens/add_item.dart';
import 'package:applore_techno/Screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isSignedIn = false;

  void signOutUser() async {
    await _auth.signOut();
    loginPage();

  }

  loginPage(){
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignIn()));
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/SignIn");
      }
    });
  }

  Future getUser() async {
    await Future.delayed(Duration(seconds: 2));
    User user = _auth.currentUser; //get user
    // user?.reload(); //reload user
    user = _auth.currentUser; //then provide current user
    if (user != null) {
      setState(() {
        this.user = user;
        this.isSignedIn = true;
      });
    }
    print(this.user);
  }

  void navigateToAddItem() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(color: Colors.white),

        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.logout),
              onPressed: signOutUser,),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: getUser,
          child: FirebaseAnimatedList(
            query: _databaseReference,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return Card(
                color: Colors.blue.shade100,
                // elevation: 8,
                shadowColor: Colors.yellow.shade900,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                     // margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.value['name']}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Text(
                            "${snapshot.value['desc']}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Text("Price :"
                            "${snapshot.value['price']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 65,
                      width: 75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: snapshot.value['image'] == "empty"
                                ? AssetImage("assets/logo.png")
                                : NetworkImage(snapshot.value['image'])),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: navigateToAddItem,
      ),
    );
  }
}
