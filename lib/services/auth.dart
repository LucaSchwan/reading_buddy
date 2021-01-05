import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_buddy/services/database.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream 
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());                                                                
      return null;
    }
  }

  // register with email in password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      DatabaseService(uid: user.uid).newUserStats();
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out 
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}
