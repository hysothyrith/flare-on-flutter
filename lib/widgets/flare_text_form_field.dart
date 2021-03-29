import 'package:flutter/material.dart';

class FlareTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final void Function(String) onSaved;
  final String Function(String) validator;

  FlareTextFormField(
      {this.labelText,
      this.hintText,
      this.obscureText = false,
      this.onSaved,
      this.validator});

  @override
  _FlareTextFormFieldState createState() => _FlareTextFormFieldState();
}

class _FlareTextFormFieldState extends State<FlareTextFormField> {
  @override
  Widget build(BuildContext context) {
    final _borderRadius = BorderRadius.all(Radius.circular(8));
    final _decoration = InputDecoration(
      contentPadding: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
      border: OutlineInputBorder(borderRadius: _borderRadius),
      labelText: widget.labelText,
      hintText: widget.hintText,
      enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
    );

    return TextFormField(
        onSaved: widget.onSaved,
        validator: widget.validator,
        obscureText: widget.obscureText,
        decoration: _decoration);
  }
}
