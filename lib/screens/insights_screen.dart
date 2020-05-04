import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/insights.dart';

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
    final stateWiseData =
        Provider.of<InsightsProvider>(context).stateWiseData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              stateWiseData == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text('${stateWiseData[0].confirmed} cases'),
            ],
          ),
        ),
      ),
    );
  }
}
