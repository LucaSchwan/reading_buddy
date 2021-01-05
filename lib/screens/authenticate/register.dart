import 'package:flutter/material.dart';
import 'package:reading_buddy/screens/shared/loading.dart';
import 'package:reading_buddy/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        title: Text('Sign up to Reading Buddy'),
        actions: <Widget>[
          FlatButton(
            child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'E-Mail *',
                ),
                validator: (val) => val.isEmpty ? 'Enter your E-Mail' : null,
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Password *',
                ),
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Please enter a Password thats 6 Characters or longer' : null,
                onChanged: (val) {
                  setState(() => password = val);
                }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.lightBlue,
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ), 
                onPressed: () async {
                  setState(() => loading = true);
                  if (_formKey.currentState.validate()) {
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                        loading = false;
                        error = 'Please Enter a valid Email';
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ), 
        ),
      ),
    );
  }
}
