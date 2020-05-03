import 'package:flutter/material.dart';

class SearchBoxDecoration {
  static BoxDecoration  decoration({Color color = Colors.white}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0.0, 10.0),
          blurRadius: 10.0,
        ),
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0.0, -5.0),
          blurRadius: 5.0,
        ),
      ],
    );
  }
}
