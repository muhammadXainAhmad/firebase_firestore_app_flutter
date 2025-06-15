import 'package:flutter/material.dart';

class MyConstants {
  static final fBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: Colors.black, width: 1.5),
  );
  static final eBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: Colors.grey, width: 1.5),
  );
}

void showSnackBar(BuildContext context, Color clr, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(duration: Duration(seconds: 1),
      content: Text(text, textAlign: TextAlign.center),
      backgroundColor: clr,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
