import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';
import 'package:rollmaster/model/user.dart';
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
        theme: ThemeData.dark(),
        home: TestHome()
    );
  }
}

Widget loadingCircle(){
  return Center(child: CircularProgressIndicator());
}

class TestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingCircle();
          } else if (snapshot.hasData){
            print(snapshot.data);
            User loggedUser = User.fromFirebase(snapshot.data);
            /// is because there is user already logged
            return HomeScreen(currentUser: loggedUser);
          } else {
            /// other way there is no user logged.
            return LoginPage();
          }
        }
    );
  }
}