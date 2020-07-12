import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rollmaster/auth/rtdb_user.dart';
import 'package:rollmaster/model/session.dart';
import 'package:rollmaster/model/user.dart';

import '../session_screen.dart';

class ListViewSession extends StatefulWidget {
  final User user;

  @override
  _ListViewNoteState createState() => new _ListViewNoteState();

  ListViewSession({this.user});
}

final activeSessionsRef = FirebaseDatabase.instance
    .reference()
    .child("users")
    .child("activeSessions");
final sessionRef = FirebaseDatabase.instance.reference().child("sessions");

class _ListViewNoteState extends State<ListViewSession> {
  List<Session> sessionList;
  List<String> activeSessionIds;
  StreamSubscription<Event> _onSessionAddedSubscription;

  @override
  void initState() {
    super.initState();

    activeSessionIds = widget.user.activeSessions;

    _onSessionAddedSubscription =
        sessionRef.onChildAdded.listen(_onSessionAdded);
  }

  void _onSessionAdded(Event event) async {
    setState(() async {
      String sessionId = event.snapshot.value.toString();
      activeSessionIds.add(sessionId);
      sessionList.add(await getSessionById(sessionId));
    });
  }

  @override
  void dispose() {
    _onSessionAddedSubscription.cancel();
    super.dispose();
  }

  _navigateToSession(BuildContext context, Session session) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SessionScreen(currentSession: session)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: sessionList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Title: " + sessionList[index].title),
                  Text("Creation Date: " +
                      sessionList[index].creationDate.toIso8601String()),
                  Text("Key: " + sessionList[index].key),
                ],
              ),
              onTap: _navigateToSession(context, sessionList[index]),
            ),
          );
        });
  }
}
