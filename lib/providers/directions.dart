import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_maps_webservice/directions.dart' as direction;

//Configs
import '../config/api_keys.dart';
//Utils
import '../utils/polyline.dart';



Future<maps.BitmapDescriptor> getCovidIcon() async {
  return maps.BitmapDescriptor.fromAssetImage(
    ImageConfiguration(),
    'lib/assets/images/hotspot_location.png',
  );
}

Future<Set<dynamic>> checkProximity(Map<String, dynamic> argumentsMap) async {
  Map<String, List<maps.LatLng>> listMap = argumentsMap['listMap'];
  List<maps.LatLng> points = listMap['points'];
  List<maps.LatLng> hotspotLocations = listMap['hotspots'];
  maps.BitmapDescriptor covidIcon = argumentsMap['covidIcon'];

  Set<maps.Marker> newMarkers = Set();

  Color color = Colors.blue;
  for (int p = 0; p < points.length; ++p) {
    maps.LatLng point = points[p];

    for (int h = 0; h < hotspotLocations.length; ++h) {
      maps.LatLng loc = hotspotLocations[h];
      double distance = calculateDistanceKM(
        point.latitude,
        point.longitude,
        loc.latitude,
        loc.longitude,
      );
      if (distance <= 2.0) {
        color = Colors.deepOrange;
        // break;
        newMarkers.add(
          maps.Marker(
            markerId: maps.MarkerId(DateTime.now().toString()),
            icon: covidIcon,
            position: loc,
          ),
        );
      }
    }
  }

  return {color, newMarkers};
}

class DirectionsProvider extends ChangeNotifier {
  direction.GoogleMapsDirections _directionsApi =
      direction.GoogleMapsDirections(
    apiKey: MY_GOOGLE_MAPS_API_KEY,
  );

  Set<maps.Polyline> _routes = Set();
  Set<maps.Polyline> get currentRoute => _routes;

  Set<maps.Marker> _markers = Set();
  Set<maps.Marker> get markers => _markers;

  void clearRoutes() {
    _routes.clear();
  }

  void clearMarkers() {
    _markers.clear();
  }

  maps.LatLng _srcCoord;
  maps.LatLng _destCoord;

  maps.LatLng get sourceCoord {
    return _srcCoord;
  }

  maps.LatLng get destinationCoord {
    return _destCoord;
  }

  Future<void> findDirections(
      {String src, String dest, List<maps.LatLng> hotspotLocations}) async {
    clearMarkers();
    clearRoutes();
    var directionResponse = await _directionsApi.directionsWithAddress(
      src,
      dest,
      travelMode: direction.TravelMode.driving,
      units: direction.Unit.metric,
      alternatives: true,
    );

    Set<maps.Polyline> newRoutes = Set();
    Set<maps.Marker> newMarkers = Set();

    if (directionResponse.isOkay) {
      // print(directionResponse.routes[0].legs[0].distance.text);
      

      List<direction.Route> routes = directionResponse.routes;

      List<maps.LatLng> points = [];

      routes.forEach((route) {});

      for (int i = 0; i < routes.length; ++i) {
        var route = routes[i];
        List<direction.Leg> legs = route.legs;

        // print('${json.encode(route)}');

        legs.forEach((leg) {
          // print('${leg.startAddress} to ${leg.endAddress}, ');
          leg.steps.forEach((step) {
            List decodedPoints = decodePoly(step.polyline.points);

            List<maps.LatLng> latLngList = convertToLatLng(decodedPoints);

            points = [...points, ...latLngList];
          });
        });

        Set<dynamic> proximityResult = await compute(
          checkProximity,
          {
            'listMap': {
              'points': points,
              'hotspots': hotspotLocations,
            },
            'covidIcon': await getCovidIcon(),
            'markers': newMarkers,
          },
        );
        Color color =  proximityResult.elementAt(0) as Color;
        Set<maps.Marker> markerSet = proximityResult.elementAt(1) as Set<maps.Marker>;

        maps.Polyline line = maps.Polyline(
          polylineId: maps.PolylineId(i.toString()),
          points: points,
          color: color,
          width: color == Colors.deepOrange ? 8 : 10,
        );
        newRoutes.add(line);
        newMarkers = {...newMarkers, ...markerSet};
        points = [];
        // print('Distance of route: $distance');
      }

      // print(routes.length);

      _routes = newRoutes;
      _markers = newMarkers;

      // print('From ${routes[0].legs[0].startAddress} to ${routes[0].legs[0].endAddress}');
      _srcCoord = maps.LatLng(routes[0].legs[0].startLocation.lat,
          routes[0].legs[0].startLocation.lng);
      _destCoord = maps.LatLng(
          routes[0].legs[0].endLocation.lat, routes[0].legs[0].endLocation.lng);

        
      _markers.add(
        maps.Marker(
          markerId: maps.MarkerId(DateTime.now().toString()),
          position: _srcCoord,
          icon: maps.BitmapDescriptor.defaultMarkerWithHue(
              maps.BitmapDescriptor.hueBlue),
        ),
      );

      _markers.add(
        maps.Marker(
          markerId: maps.MarkerId(DateTime.now().toString()),
          position: _destCoord,
          icon: maps.BitmapDescriptor.defaultMarkerWithHue(
              maps.BitmapDescriptor.hueGreen),
        ),
      );

      notifyListeners();
       
    }
  }
}
