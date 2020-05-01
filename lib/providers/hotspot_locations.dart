import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HotspotLocations with ChangeNotifier {
  final url = 'https://covid-app-server.herokuapp.com/api/locations';

  Future<void> getAllLocations() async {
    final response = await http.get(url);
    final data = json.decode(response.body);
    final stateWiseLocationData = data['stateWiseLocations'] as Map<String, dynamic>;

    print('Response: ${stateWiseLocationData['bihar']}');

  }
}
