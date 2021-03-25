import 'package:flare/repositories/auth.dart';
import 'package:flare/views/home.dart';
import 'package:flare/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final primaryColor = Color(0xFF22223B);
  final backgroundColorDarker = Color(0xFFF5F8FF);
  final primaryTextColor = Color(0xFF4A4E69);
  final captionColor = Color(0xFF8e9aaf);
  final primaryBackgroundColor = Color(0xFFFFFFFF);
  final accentColor = Colors.red;
  final highlightColor = Color(0xFF02C39A);
  final Auth auth = new Auth();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flare',
      theme: ThemeData(
          primaryColor: primaryColor,
          backgroundColor: primaryBackgroundColor,
          accentColor: accentColor,
          highlightColor: highlightColor,
          textTheme: TextTheme(
              headline1: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),
              headline2: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),
              headline3: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),
              headline4: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),
              headline5: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 14, color: primaryColor)),
              headline6: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 14, color: primaryTextColor)),
              subtitle2: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 14, color: captionColor)),
              bodyText1: GoogleFonts.lato(
                  textStyle: TextStyle(color: primaryTextColor, height: 1.6)),
              bodyText2: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 14, color: primaryTextColor, height: 1.6)),
              caption: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 12, color: captionColor))),
          iconTheme: IconThemeData(color: primaryColor),
          scaffoldBackgroundColor: backgroundColorDarker,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
              elevation: 0, iconTheme: IconThemeData(color: primaryColor))),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: auth.verifyExistingCredentials(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error loading app");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data ? Home() : SignInView();
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
