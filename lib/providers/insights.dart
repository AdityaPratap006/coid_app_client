import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Models
import '../models/stats.dart';

class InsightsProvider extends ChangeNotifier {
  List<StateInfo> _stateWiseData;

  List<StateInfo> get stateWiseData => _stateWiseData;

  Future<void> fetchAndSetData() async {
    try {
      String url = 'https://api.covid19india.org/data.json';

      final res = await http.get(url);
      dynamic data = json.decode(res.body);
      List<StateInfo> stateData = [];

      data['statewise'].forEach((state) {
        stateData.add(StateInfo(
          active: double.parse(state['active']),
          confirmed: double.parse(state['confirmed']),
          deaths: double.parse(state['deaths']),
          deltaconfirmed: double.parse(state['deltaconfirmed']),
          deltadeaths: double.parse(state['deltadeaths']),
          deltarecovered: double.parse(state['deltarecovered']),
          recovered: double.parse(state['recovered']),
          state: (state['state'] as String).toLowerCase(),
        ));
      });

      _stateWiseData = [...stateData];
      print(stateData);
      notifyListeners();

    } catch (error) {
       
       throw(error);
    }
  }
}
