import 'package:flutter/material.dart';

//Utils
import '../utils/search_box_decoration.dart';

class DirectionLegends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: SearchBoxDecoration.decoration(color: Colors.white),
      width: 150,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.deepOrange,
              height: 6,
              width: double.infinity,
            ),
            Text(
              'Routes close to covid zones',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 10,
              ),
            ),
            Container(
              color: Colors.blue,
              height: 6,
              width: double.infinity,
            ),
            Text(
              'Safe Routes',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
