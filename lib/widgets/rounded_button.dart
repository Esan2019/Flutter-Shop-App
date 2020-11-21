import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    this.color,
    this.textColor = Colors.white,
    @required this.onPressed,
    @required this.text,
  });

  final Color color, textColor;
  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: RaisedButton(
        padding: const EdgeInsets.all(15),
        color: color ?? Theme.of(context).accentColor,
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: textColor)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        splashColor: Colors.pinkAccent.withOpacity(0.3),
      ),
    );
  }
}
