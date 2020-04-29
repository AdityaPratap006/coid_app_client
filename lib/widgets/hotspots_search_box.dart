import 'package:flutter/material.dart';

//Widgets
import '../widgets/profile_button.dart';

class HotspotsSearchBox extends StatefulWidget {
  @override
  _HotspotsSearchBoxState createState() => _HotspotsSearchBoxState();
}

class _HotspotsSearchBoxState extends State<HotspotsSearchBox> {

  @override
  Widget build(BuildContext context) {
    final searchBoxWidth = (MediaQuery.of(context).size.width - 30);
    return Positioned(
      top: 50,
      right: 15,
      left: 15,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
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
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: searchBoxWidth * 0.80,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.lightBlue,
                ),
              ),
            ),
            Container(
              width: searchBoxWidth * 0.20,
              height: double.infinity,
              alignment: Alignment.center,
              child: ProfileButton(),
            ),
          ],
        ),
      ),
    );
  }
}
