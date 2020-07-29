import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
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
  List<Session> _sessionList = [];
  Future<List<Session>> _sessionList2;
  DatabaseReference _sessionsQuery;
  StreamSubscription _onSessionDeleteSubscription;
  StreamSubscription _onSessionCreatedSubscription;

  @override
  void initState() {
    super.initState();

    _sessionList2 = getSessionsByOwner(widget.currentUser);
    _sessionList2.then((value) => {widget.createState()});
    _sessionsQuery = getUserSessionsRef(widget.currentUser.userId);
    _onSessionCreatedSubscription =
        _sessionsQuery.onChildAdded.listen(_onSessionCreated);
    _onSessionDeleteSubscription =
        _sessionsQuery.onChildRemoved.listen(_onSessionDeleted);
  }

  _onSessionCreated(Event event) async {
    if (this.mounted) {
      String newSessionId = event.snapshot.value;
      Session newSession = await getSessionById(newSessionId);
      setState(() {
        _sessionList.add(newSession);
        print("Added to list!");
        print(newSession.toString());
      });
    }
  }

  _onSessionDeleted(Event event) {
    if (this.mounted) {
      setState(() {
        String deletedSessionId = event.snapshot.value;
        _sessionList.removeWhere((element) => element.key == deletedSessionId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('RollMaster Online')),
        ),
        body: Stack(children: <Widget>[
          Container(
            color: Colors.cyan[900],
          ),
          SingleChildScrollView(
              child: Container(
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
                  sessionListView(),
                  _logOutButton(),
                ],
              ),
            ),
          )),
        ]));
  }

  createNewSession(User currentUser) {
    createSession(currentUser).then((newSession) => {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return SessionScreen(currentUser: currentUser,currentSession: newSession);
          },
        ),
      )
        });
  }

  Widget sessionListView() {
    return new ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _sessionList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: InkWell(
            onTap: () => _navigateToSession(context, _sessionList[index]),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Title: " + _sessionList[index].title),
                    Text("Creation Date: " +
                        _sessionList[index].creationDate.toIso8601String()),
                    Text("Key: " + _sessionList[index].key),
                  ],
                ),
                (_sessionList[index].creatorId == widget.currentUser.userId)
                    ? OutlineButton(
                        color: Colors.amber,
                        onPressed: () =>
                            deleteOwnedSession(_sessionList[index]),
                        child: Text('X'),
                      )
                    : null,
              ],
            ),
          ));
        });
  }

  _navigateToSession(BuildContext context, Session session) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SessionScreen(
                currentSession: session,
                currentUser: widget.currentUser,
              )),
    );
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

  deleteOwnedSession(Session session) {
    deleteSession(widget.currentUser.userId, session.key);
  }
}
