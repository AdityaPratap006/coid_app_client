import 'package:flutter/material.dart';

class SearchBoxDecoration {
  static BoxDecoration get decoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: Colors.white,
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
