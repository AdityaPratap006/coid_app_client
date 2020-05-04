import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Models
import '../models/stats.dart';

class InsightsProvider extends ChangeNotifier {
  List<StateInfo> _stateWiseData;
  StateInfo _totalData;

  List<StateInfo> get stateWiseData => _stateWiseData;
  StateInfo get totalData => _totalData;

  Future<void> fetchAndSetData() async {
    try {
      String url = 'https://api.covid19india.org/data.json';

      final res = await http.get(url);
      dynamic data = json.decode(res.body);
      List<StateInfo> stateData = [];

      data['statewise'].forEach((state) {
        stateData.add(StateInfo(
          active: double.parse(state['active'] as String),
          confirmed: double.parse(state['confirmed'] as String),
          deaths: double.parse(state['deaths'] as String),
          deltaconfirmed: double.parse(state['deltaconfirmed'] as String),
          deltadeaths: double.parse(state['deltadeaths'] as String),
          deltarecovered: double.parse(state['deltarecovered'] as String),
          recovered: double.parse(state['recovered'] as String),
          state: state['state'] as String,
        ));
      });

      _stateWiseData = stateData.where((data) {
        return data.state.toLowerCase() != 'total';
      }).toList();

      _totalData = stateData.firstWhere((data) {
        return data.state.toLowerCase() == 'total';
      });

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
