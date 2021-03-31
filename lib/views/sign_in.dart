import 'package:flare/repositories/auth.dart';
import 'package:flare/views/home.dart';
import 'package:flare/views/sign_up.dart';
import 'package:flare/widgets/flare_text_form_field.dart';
import 'package:flutter/material.dart';

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child:
                      Image(image: AssetImage('assets/images/flare_logo.png')),
                ),
              ),
              SignInForm(
                onSubmit: (email, password) {
                  AuthRepo auth = AuthRepo();
                  auth.signIn(email: email, password: password).then((success) {
                    if (success) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomeView()));
                    } else {
                      print("Invalid credentials");
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
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

  bool _validateEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  @override
  Widget build(BuildContext context) {
    final _emailField = FlareTextFormField(
      labelText: "Email",
      hintText: "jamesbond@cia.com",
      onSaved: (value) {
        email = value;
      },
      validator: (value) {
        if (!_validateEmail(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
    );

    final _passwordField = FlareTextFormField(
      labelText: "Password",
      obscureText: true,
      onSaved: (value) {
        password = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a password";
        }
        return null;
      },
    );

    final _signInButton = ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            this.widget.onSubmit(email, password);
          }
        },
        child: Text("Sign In"));

    final _signUpInvitation = TextButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUpView()));
      },
      child: Text("Don't have an account? Sign Up"),
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
            _emailField,
            SizedBox(height: 16),
            _passwordField,
            SizedBox(height: 24),
            _signInButton,
            _signUpInvitation
          ],
        ),
      ),
    );
  }
}
