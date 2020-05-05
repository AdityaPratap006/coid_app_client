import 'package:flutter/material.dart';

//Model
import '../models/stats.dart';

//Utils
import '../utils/search_box_decoration.dart';

class StateData extends StatelessWidget {
  final StateInfo data;

  StateData({
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 14.0,
        color: Colors.white,
        shadowColor: Color(0x802196f3),
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 250,
          width: 220,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            children: <Widget>[
              Text(
                '${data.state}',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).accentColor,
                ),
              ),
              Expanded(
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(5.0),
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Confirmed',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${data.confirmed.toInt()}',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            data.deltaconfirmed <= 0
                                ? ''
                                : '[+${data.deltaconfirmed.toInt()}]',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${data.active.toInt()}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Recovered',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${data.recovered.toInt()}',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            data.deltarecovered <= 0
                                ? ''
                                : '[+${data.deltarecovered.toInt()}]',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Deceased',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${data.deaths.toInt()}',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            data.deltadeaths <= 0
                                ? ''
                                : '[+${data.deltadeaths.toInt()}]',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
