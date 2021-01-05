import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/screens/home/app_drawer.dart';

class FinishedPage extends StatelessWidget {

  final User user;

  FinishedPage({ this.user });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finished Books'),
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
      ),
      body: Text('Finished Books'),
      drawer: AppDrawer(user: user,),
    );
  }
}
