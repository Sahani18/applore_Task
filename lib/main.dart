import 'package:applore_techno/Screens/add_item.dart';
import 'package:applore_techno/Screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/home.dart';
import 'Screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Applore Technologies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue.shade900,
      fontFamily: GoogleFonts.roboto().fontFamily ),
     home: SignIn(),

    );
  }
}
