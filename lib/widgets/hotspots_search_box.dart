import 'package:flutter/material.dart';

//Widgets
import '../widgets/profile_button.dart';

class HotspotsSearchBox extends StatefulWidget {
  final Function searchAndNavigate;

  HotspotsSearchBox({this.searchAndNavigate});

  @override
  _HotspotsSearchBoxState createState() => _HotspotsSearchBoxState();
}

class _HotspotsSearchBoxState extends State<HotspotsSearchBox> {
  String _searchAddress;

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
               
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search places...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await widget.searchAndNavigate(_searchAddress);
                    },
                    iconSize: 30.0,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchAddress = val;
                  });
                },
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
