import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/insights.dart';

//Widgets
import '../widgets/insights_state_title.dart';
import '../widgets/insights_state_data.dart';
import '../widgets/insights_total_card.dart';

//Utils
import '../utils/search_box_decoration.dart';

class InsightsScreen extends StatefulWidget {
  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<InsightsProvider>(context, listen: false).fetchAndSetData();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final stateWiseData = Provider.of<InsightsProvider>(context).stateWiseData;
    final totalInfo = Provider.of<InsightsProvider>(context).totalData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
      ),
      body: SingleChildScrollView(
        child: stateWiseData == null
            ? Container(
                width: deviceSize.width,
                height: deviceSize.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                width: deviceSize.width,
                height: deviceSize.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    TotalData(
                      info: totalInfo,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Swipe Left/Right to view complete info',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      height: deviceSize.height * 0.36,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 5.0),
                              blurRadius: 5.0,
                            ),
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -2.0),
                              blurRadius: 2.0,
                            ),
                          ]),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: deviceSize.width * 1.8,
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                border: TableBorder(
                                  // verticalInside:
                                  //     BorderSide(color: Colors.grey.shade200),
                                  horizontalInside:
                                      BorderSide(color: Colors.grey.shade200),
                                ),

                                columnWidths: {
                                  0: FractionColumnWidth(0.2),
                                  1: FractionColumnWidth(0.2),
                                  2: FractionColumnWidth(0.2),
                                  3: FractionColumnWidth(0.2),
                                  4: FractionColumnWidth(0.2),
                                },
                                children: [
                                  TableRow(children: [
                                    StateTitle(
                                      title: 'State/UT',
                                    ),
                                    StateTitle(
                                      title: 'Confirmed',
                                    ),
                                    StateTitle(
                                      title: 'Active',
                                    ),
                                    StateTitle(
                                      title: 'Recovered',
                                    ),
                                    StateTitle(
                                      title: 'Deceased',
                                    ),
                                  ]),
                                  ...stateWiseData
                                      .map((data) => TableRow(children: [
                                            StateTitle(title: data.state),
                                            StateData(
                                              count: data.confirmed,
                                              delta: data.deltaconfirmed,
                                              color: Colors.red,
                                            ),
                                            StateData(
                                              count: data.active,
                                              delta: 0,
                                              color: Colors.blue,
                                            ),
                                            StateData(
                                              count: data.recovered,
                                              delta: data.deltarecovered,
                                              color: Colors.green,
                                            ),
                                            StateData(
                                              count: data.deaths,
                                              delta: data.deltadeaths,
                                              color: Colors.grey.shade700,
                                            ),
                                          ]))
                                      .toList(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
