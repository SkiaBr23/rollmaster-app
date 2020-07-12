import 'package:flutter/material.dart';
import 'package:rollmaster/auth/rtdb_user.dart';
import 'package:rollmaster/auth/sign_in.dart';
import 'package:rollmaster/model/user.dart';
import 'package:rollmaster/session_screen.dart';

import 'component/session_list_view.dart';
import 'login_page.dart';
import 'model/session.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;

  @override
  _HomeScreenState createState() => _HomeScreenState();

  HomeScreen({this.currentUser});
}

class _HomeScreenState extends State<HomeScreen> {
  List<Session> _sessionList;
  Future<List<Session>> _sessionList2;

  @override
  void initState() {
    super.initState();

    _sessionList2 = getSessionsByOwner(widget.currentUser);
    _sessionList2.then((value) => {widget.createState()});
    //_sessionList = getActiveSessionsByUser(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('RollMaster Online')),
      ),
      body: Container(
        color: Colors.cyan[900],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Hello ' + widget.currentUser.fullName + '!',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black)),
              OutlineButton(
                color: Colors.amber,
                onPressed: () => createNewSession(widget.currentUser),
                child: Text('Criar sessão'),
              ),
              sessionListView2(),
              //ListViewSession(user: widget.currentUser),
              _logOutButton(),
            ],
          ),
        ),
      ),
    );
  }

  createNewSession(User currentUser) {
    createSession(currentUser).then((newSession) => {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return SessionScreen(currentSession: newSession);
          },
        ),
      )
    });
  }

  Widget sessionListView2() {
    return FutureBuilder(
        future: _sessionList2,
        builder: (context, AsyncSnapshot<List<Session>> snapshot) {
          if (snapshot.hasData) {
            _sessionList = snapshot.data;
            _sessionList.forEach((element) {
              print(element.toString());
            });
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: _sessionList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: InkWell(
                        onTap: () => _navigateToSession(context,_sessionList[index]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Title: " + _sessionList[index].title),
                            Text("Creation Date: " +
                                _sessionList[index].creationDate.toIso8601String()),
                            Text("Key: " + _sessionList[index].key),
                          ],
                        ),
                      ));
                });
          }
          return CircularProgressIndicator();
        });
  }

  _navigateToSession(BuildContext context, Session session) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SessionScreen(currentSession: session)),
    );
  }

  Widget _sessionListView(User user) {
    return FutureBuilder(
        future: getSessionsByOwner(user),
        builder: (context, AsyncSnapshot<List<Session>> snapshot) {
          if (snapshot.hasData) {
            _sessionList = snapshot.data;
            _sessionList.forEach((element) {
              print(element.toString());
            });
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: _sessionList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Title: " + _sessionList[index].title),
                        Text("Creation Date: " +
                            _sessionList[index].creationDate.toIso8601String()),
                        Text("Key: " + _sessionList[index].key),
                      ],
                    ),
                  );
                });
          }
          return CircularProgressIndicator();
        });
  }

  Widget _logOutButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signOutGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
          );
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
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Logout',
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

  joinSession() {}
}
