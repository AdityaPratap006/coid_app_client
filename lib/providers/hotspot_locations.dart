import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

//Models
import '../models/location.dart';

class HotspotLocations with ChangeNotifier {
  List<LocationData> _locations = [];

  List<LocationData> get locations {
    return [..._locations];
  }

  Future<void> fetchAndSetLocations() async {
    try {
      final url = 'https://covid-app-server.herokuapp.com/api/locations';

      final response = await http.get(url);
      final data = json.decode(response.body);
      final stateWiseLocationData =
          data['stateWiseLocations'] as Map<String, dynamic>;

      final List<LocationData> locationsList = [];
      stateWiseLocationData.forEach((String state, dynamic stateData) {
        final List<dynamic> locationsInState = stateData['locations'];
        locationsInState.forEach((dynamic loc) {
          if (loc['coordinates']['latitude'] is int ||
              loc['coordinates']['longitude'] is int) {
            return;
          }

          final LocationData locationData = LocationData(
            location: loc['location'],
            caseCount: loc['caseCount'],
            coordinates: LatLng(
              loc['coordinates']['latitude'],
              loc['coordinates']['longitude'],
            ),
            state: loc['state'],
          );

          locationsList.add(locationData);
        });
      });

      _locations = locationsList;
      notifyListeners();
      
      print(_locations.length);
    } catch (e) {
      throw(e);
    }
  }
}
