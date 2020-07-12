import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rollmaster/auth/rtdb_user.dart';
import 'package:rollmaster/main.dart';
import 'model/user.dart';

import 'auth/sign_in.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usersDbRef = FirebaseDatabase.instance.reference().child("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().then((value) => {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return FutureBuilder(
                    future: checkPersistedUser(),
                    builder: (BuildContext context,
                        AsyncSnapshot<User> userSnapshot) {
                      switch (userSnapshot.connectionState) {
                        case ConnectionState.done:
                          {
                            return userSnapshot.data != null ? HomeScreen(currentUser: userSnapshot.data) : loadingCircle();
                          }
                        default:
                          {
                            return loadingCircle();
                          }
                      }
                    }); 
              }))
            });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<FirebaseUser> currentUserObject() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user;
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.blue[100]),
    );
  }
}
