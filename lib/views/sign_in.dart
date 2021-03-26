import 'package:flare/models/auth_response.dart';
import 'package:flare/repositories/auth.dart';
import 'package:flare/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Column(
        children: [
          Image(image: AssetImage('assets/images/flare_logo.png')),
          SignInForm(
            onSubmit: (email, password) {
              AuthRepo auth = AuthRepo();
              auth.signIn(email: email, password: password).then((success) {
                if (success) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                } else {
                  print("Invalid credentials");
                }
              });
            },
          )
        ],
      ),
    ));
  }
}

class SignInForm extends StatefulWidget {
  final Function(String, String) onSubmit;

  SignInForm({this.onSubmit});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  String email;
  String password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              TextFormField(
                  onSaved: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "jamesbond@cia.com")),
              TextFormField(
                  onSaved: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                  obscureText: true),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      this.widget.onSubmit(email, password);
                    }
                  },
                  child: Text("Sign In"))
            ],
          ),
        ));
  }
}
