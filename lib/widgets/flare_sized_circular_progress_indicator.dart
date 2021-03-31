import 'package:flutter/material.dart';

class FlareSizedCircularProgressIndicator extends StatelessWidget {
  final double size;

  FlareSizedCircularProgressIndicator({this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
