import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_buddy/screens/shared/laoding.dart';
import 'package:reading_buddy/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reading_buddy/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Loading();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<User>.value(
            value: AuthService().user,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Wrapper(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

