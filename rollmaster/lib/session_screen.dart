import 'package:flutter/material.dart';
import 'model/session.dart';

class SessionScreen extends StatefulWidget {
  final Session currentSession;

  @override
  _SessionScreenState createState() => _SessionScreenState();

  SessionScreen({this.currentSession});
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.currentSession.title)
        ),
      ),
      body: Container(
          color: Colors.cyan[900],
          child: Center(
              child: Text(widget.currentSession.key)
          )
      ),
    );
  }
}
