import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rollmaster/auth/rtdb_user.dart';
import 'package:rollmaster/model/roll_check.dart';
import 'package:rollmaster/util/dice_roller.dart';
import 'model/roll.dart';
import 'model/session.dart';
import 'model/user.dart';
import 'package:firebase_database/firebase_database.dart';

class SessionScreen extends StatefulWidget {
  final Session currentSession;
  final User currentUser;

  @override
  _SessionScreenState createState() => _SessionScreenState();

  SessionScreen({this.currentSession, this.currentUser});
}

class _SessionScreenState extends State<SessionScreen> {
  List<Roll> _rolls = [];
  List<User> activePlayers;
  DatabaseReference _rollsQuery;
  StreamSubscription _onRollAddedSubscription;
  StreamSubscription _onRollsCleanedSubscription;

  _onEntryAdded(Event event) {
    setState(() {
      Roll newRoll = Roll.fromSnapshot(event.snapshot);
      _rolls.add(newRoll);
      print("Added to list!");
      print(newRoll.toString());
    });
  }

  _onRollsCleaned(Event event) {
    setState(() {
      _rolls = [];
    });
  }

  @override
  void initState() {
    super.initState();
    _rollsQuery = FirebaseDatabase.instance
        .reference()
        .child("rolls")
        .child(widget.currentSession.key);
    _onRollAddedSubscription = _rollsQuery.onChildAdded.listen(_onEntryAdded);
    _onRollsCleanedSubscription =
        _rollsQuery.onChildRemoved.listen(_onRollsCleaned);
  }

  Widget rollListView() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _rolls.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_rolls[index].toString()),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.currentSession.title)),
        ),
        body: Stack(children: <Widget>[
          Container(
            color: Colors.cyan[900],
          ),
          SingleChildScrollView(
            child: Container(
                color: Colors.cyan[900],
                child: Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ([
                        Text(widget.currentSession.key),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlineButton(
                              color: Colors.amber,
                              onPressed: () => cleanRollsScreen(),
                              child: Text('Limpar'),
                            ),
                            OutlineButton(
                              color: Colors.amber,
                              onPressed: () => testRoll(),
                              child: Text('Teste'),
                            ),
                          ],
                        ),
                        rollListView(),
                      ])),
                )),
          )
        ]));
  }

  testRoll() {
    RollCheck rollCheck = RollCheck(faces: 20, dices: 1, modifier: 2);
    Roll newRoll =
        sendRoll(widget.currentUser, widget.currentSession.key, rollCheck);
  }

  cleanRollsScreen() {
    cleanRolls(widget.currentSession.key);
  }
}
