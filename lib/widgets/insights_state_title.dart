import 'package:flutter/material.dart';

class StateTitle extends StatelessWidget {
  final String title;
  StateTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
