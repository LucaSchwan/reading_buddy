import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_buddy/screens/authenticate/authenticate.dart';
import 'package:reading_buddy/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    // return either Home or Authenticate
    if (user == null) {
      return Authenticate();
    } else { 
      return Home(user: user);
    }
  }
}