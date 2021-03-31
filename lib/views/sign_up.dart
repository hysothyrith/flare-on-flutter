import 'package:flare/repositories/auth.dart';
import 'package:flare/views/home.dart';
import 'package:flare/views/sign_in.dart';
import 'package:flare/widgets/flare_sized_circular_progress_indicator.dart';
import 'package:flare/widgets/flare_text_form_field.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
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
              SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String name;
  String email;
  String password;
  final _authRepo = AuthRepo();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  bool _validateEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  bool _validatePassword(String password) =>
      password != null && password.isNotEmpty && password.length >= 8;

  @override
  Widget build(BuildContext context) {
    final _nameField = FlareTextFormField(
        labelText: "Name",
        hintText: "Justin Bieber",
        onSaved: (value) {
          name = value;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your name";
          }
          return null;
        });

    final _emailField = FlareTextFormField(
      labelText: "Email",
      hintText: "justinbieber@gmail.com",
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
      hintText: "8 characters or more",
      obscureText: true,
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
    );

    final _signUpButton = ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (_formKey.currentState.validate()) {
            setState(() {
              _isLoading = true;
            });
            _formKey.currentState.save();
            _authRepo.signUp(name: name, email: email, password: password).then(
              (success) {
                if (success) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeView()));
                } else {
                  final snackBar = SnackBar(
                      content: Text(
                          "Sorry, the sign up wasn't successful. Please try a different email."),
                      backgroundColor: Theme.of(context).errorColor);
                  Scaffold.of(context).showSnackBar(snackBar);
                  _formKey.currentState.reset();
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            );
          }
        },
        child: _isLoading
            ? FlareSizedCircularProgressIndicator(size: 16)
            : Text("Sign Up"));

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
              SizedBox(height: 16),
              _emailField,
              SizedBox(height: 16),
              _passwordField,
              SizedBox(height: 24),
              _signUpButton,
              _signInInvitation
            ],
          ),
        ));
  }
}
