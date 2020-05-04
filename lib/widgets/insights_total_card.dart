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
      height: 200,
      decoration: SearchBoxDecoration.decoration(),
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 6.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Confirmed',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              Text(
                '${info.confirmed.toInt()}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
              Text(
                '[+${info.deltaconfirmed.toInt()}]',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Active',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              Text(
                '${info.active.toInt()}',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              Text(
                '',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Recovered',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              Text(
                '${info.recovered.toInt()}',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
              Text(
                '[+${info.deltarecovered.toInt()}]',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Deceased',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${info.deaths.toInt()}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 18,
                ),
              ),
              Text(
                '[+${info.deltadeaths.toInt()}]',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
