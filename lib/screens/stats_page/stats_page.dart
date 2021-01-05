import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/screens/home/app_drawer.dart';
import 'package:reading_buddy/services/database.dart';
import 'package:reading_buddy/models/user_stats.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatelessWidget {

  final User user;

  StatsPage({ this.user });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserStats>.value(
      value: DatabaseService(uid: user.uid).userStats,
      child: new WillPopScope(
        onWillPop: () async => false,
         child: Scaffold(
          appBar: AppBar(
            title: Text('Stats'),
            backgroundColor: Colors.lightBlue,
            elevation: 0.0,
          ),
          body: Text('Stats'),
          drawer: AppDrawer(user: user,),
        ),
      )
    );
  }
}
