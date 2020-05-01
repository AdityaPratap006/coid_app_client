import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  final String location;
  final String state;
  final int caseCount;
  final LatLng coordinates;

  LocationData({
    @required this.location,
    @required this.state,
    @required this.caseCount,
    @required this.coordinates,
  });
}
