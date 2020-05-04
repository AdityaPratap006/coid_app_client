import 'package:flutter/material.dart';

class StateData extends StatelessWidget {
  final double count;
  final double delta;
  final Color color;

  StateData({
    @required this.color,
    @required this.count,
    @required this.delta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '${count.floor()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (delta > 0.0)
                  Icon(
                    Icons.arrow_drop_up,
                    color: color,
                  ),
                Text(
                  '${delta > 0.0 ? delta.floor() : ''}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
