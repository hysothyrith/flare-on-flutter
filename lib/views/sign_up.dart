import 'package:flare/repositories/auth.dart';
import 'package:flare/views/home.dart';
import 'package:flare/views/sign_in.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Image(image: AssetImage('assets/images/flare_logo.png')),
          ),
          SignUpForm(
            onSubmit: (name, email, password, passwordConfirmation) {
              AuthRepo authRepo = AuthRepo();
              authRepo
                  .signUp(
                      name: name,
                      email: email,
                      password: password,
                      passwordConfirmation: passwordConfirmation)
                  .then((success) {
                if (success) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeView()));
                } else {
                  print("Invalid sign up credentials");
                }
              });
            },
          )
        ],
      ),
    ));
  }
}

class SignUpForm extends StatefulWidget {
  final Function(String name, String email, String password,
      String passwordConfirmation) onSubmit;

  SignUpForm({this.onSubmit});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String name;
  String email;
  String password;
  String passwordConfirmation;

  final _formKey = GlobalKey<FormState>();

  bool _validateEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  bool _validatePassword(String password) => password != null && password.isNotEmpty && password.length >= 8;

  @override
  Widget build(BuildContext context) {
    final _inputFieldBorderRadius = BorderRadius.all(Radius.circular(8));

    _inputFieldDecoration({String hintText = ""}) => InputDecoration(
        contentPadding: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
        border: OutlineInputBorder(borderRadius: _inputFieldBorderRadius),
        enabledBorder: OutlineInputBorder(
            borderRadius: _inputFieldBorderRadius,
            borderSide: BorderSide(color: Theme.of(context).hintColor)),
        hintText: hintText);

    final _nameField = TextFormField(
      onSaved: (value) {
        name = value;
      },
      decoration: _inputFieldDecoration(hintText: "Name"),
    );

    final _emailField = TextFormField(
      onSaved: (value) {
        email = value;
      },
      validator: (value) {
        if (!_validateEmail(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
      decoration: _inputFieldDecoration(hintText: "Email"),
    );

    final _passwordField = TextFormField(
      onSaved: (value) {
        password = value;
      },
      validator: (value) {
        print(value);
        if (!_validatePassword(value)) {
          return "A valid password must have more than 8 characters";
        }
        return null;
      },
      decoration: _inputFieldDecoration(hintText: "Password"),
      obscureText: true,
    );

    final _confirmPasswordField = TextFormField(
      onSaved: (value) {
        passwordConfirmation = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a password confirmation";
        }
        return null;
      },
      decoration: _inputFieldDecoration(hintText: "Password confirmation"),
      obscureText: true,
    );

    final _signUpButton = ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            this.widget.onSubmit(name, email, password, passwordConfirmation);
          }
        },
        child: Text("Sign Up"));

    final _signInInvitation = TextButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInView()));
      },
      child: Text("Already have an account? Sign In"),
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
      ),
    );

    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              _nameField,
              SizedBox(height: 8),
              _emailField,
              SizedBox(height: 8),
              _passwordField,
              SizedBox(height: 8),
              _confirmPasswordField,
              SizedBox(height: 16),
              _signUpButton,
              _signInInvitation
            ],
          ),
        ));
  }
}
