import 'package:flutter/material.dart';
class Reusable extends StatelessWidget {
  Reusable({
    required  this.colors,required this.text,required this.onPressed
  });
  Color ?colors;

  String text;
  late VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colors,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            '$text',
          ),
        ),
      ),
    );
  }
}