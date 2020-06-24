import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';
import 'login_page.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: 'Test',
        theme: new ThemeData(
          primarySwatch: Colors.red,
        ),
        home: FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
          if (snapshot != null){
            //FirebaseUser user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            return HomeScreen();
          }
          /// other way there is no user logged.
          return LoginPage();
        }
    )
    );
  }
}
