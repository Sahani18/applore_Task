import 'package:applore_techno/Screens/home.dart';
import 'package:applore_techno/Screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  UserCredential user;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _name, _email, _password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }


  signUp() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        // after creation of new user update the name parameter in firebase
        if (user != null) {
          _auth.currentUser.updateDisplayName(_name);
          _auth.currentUser?.reload();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SignIn()));
        }
      } catch (e) {
        showError(e.message);
      }
    }
  }

  showError(String errorMessage) {
    print(errorMessage);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              ElevatedButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 140),
                  child: Column(
                    children: [
                      Center(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'a',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                              text: 'pp',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                              text: 'lore',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              )),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 38),
                        child: Text(
                          'applore technologies',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Username';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSaved: (value) => _name = value,
                ),
                Padding(padding: EdgeInsets.only(top: 12)),
                Text(
                  'Email id',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Email Id';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email Id',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSaved: (value) => _email = value,
                ),
                Padding(padding: EdgeInsets.only(top: 12)),
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSaved: (value) => _password = value,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                GestureDetector(
                  child: Container(
                    height: 40,
                    width: width,
                    alignment: Alignment.center,
                    child: Text(
                      'Register Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                            colors: [Colors.blue.shade300, Colors.blue.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.topRight)),
                  ),
                  onTap: signUp,
                ),
                Padding(padding: EdgeInsets.only(top: 75)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account ?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87.withOpacity(0.7).withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                        onPressed: navigateToSignIn,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.orange),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToSignIn() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignIn()));
  }
}
