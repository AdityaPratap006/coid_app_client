import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/insights.dart';

//Widgets
import '../widgets/insights_state_data.dart';
import '../widgets/insights_total_card.dart';

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
      body: stateWiseData == null
          ? Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                width: deviceSize.width,
                height: deviceSize.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total (India)',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TotalData(
                        info: totalInfo,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Statewise Data',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Container(
                      height: 300.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ...stateWiseData
                                .map((data) => StateData(
                                      data: data,
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
