import 'package:flutter/material.dart';

//Utils
import '../utils/search_box_decoration.dart';

//Models
import '../models/stats.dart';

class TotalData extends StatelessWidget {
  final StateInfo info;

  TotalData({
    @required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 260,
      child: GridView.count(
        shrinkWrap: true,
        childAspectRatio: ((MediaQuery.of(context).size.width) / 2) / 120,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Material(
            color: Colors.red,
            elevation: 6.0,
            borderRadius: BorderRadius.circular(9.0),
            shadowColor: Color(0x802196f3),
            child: Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Confirmed',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${info.confirmed.toInt()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '[+${info.deltaconfirmed.toInt()}]',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.blue,
            elevation: 6.0,
            borderRadius: BorderRadius.circular(9.0),
            shadowColor: Color(0x802196f3),
            child: Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${info.active.toInt()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.green,
            elevation: 6.0,
            borderRadius: BorderRadius.circular(9.0),
            shadowColor: Color(0x802196f3),
            child: Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Recovered',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${info.recovered.toInt()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '[+${info.deltarecovered.toInt()}]',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.grey.shade500,
            elevation: 6.0,
            borderRadius: BorderRadius.circular(9.0),
            shadowColor: Color(0x802196f3),
            child: Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Deceased',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${info.deaths.toInt()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '[+${info.deltadeaths.toInt()}]',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
