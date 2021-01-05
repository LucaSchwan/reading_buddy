import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_buddy/screens/home/home.dart';
import 'package:reading_buddy/screens/stats_page/stats_page.dart';
import 'package:reading_buddy/screens/finished_page/finished_page.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/services/auth.dart';

class AppDrawer extends StatelessWidget {

  final User user;

  AppDrawer({ this.user });

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Account'),
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('logout'),
                  onPressed: () async {
                    await _auth.signOut();
                  },
                )
              ],
            )
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(user: user,)
                )
              );
            },
          ),
          ListTile(
            title: Text('Stats'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StatsPage(user: user,)
                )
              );
            },
          ),
          ListTile(
            title: Text('Finished Books'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FinishedPage(user: user,)
                )
              );
            },
          ),
        ],
      ),
    );
  }
}

