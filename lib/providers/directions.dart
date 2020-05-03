import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_maps_webservice/directions.dart' as direction;

//Configs
import '../config/api_keys.dart';
//Utils
import '../utils/polyline.dart';

class DirectionsProvider extends ChangeNotifier {
  direction.GoogleMapsDirections directionsApi = direction.GoogleMapsDirections(
    apiKey: MY_GOOGLE_MAPS_API_KEY,
  );

  Set<maps.Polyline> _routes = Set();

  Set<maps.Polyline> get currentRoute => _routes;

  double _calculateDistanceKM(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> findDirections(
      {String src, String dest, List<maps.LatLng> hotspotLocations}) async {
    var directionResponse = await directionsApi.directionsWithAddress(
      src,
      dest,
      travelMode: direction.TravelMode.driving,
      units: direction.Unit.metric,
      alternatives: true,
    );

    Set<maps.Polyline> newRoutes = Set();

    if (directionResponse.isOkay) {
      // print(directionResponse.routes[0].legs[0].distance.text);
      List<direction.Route> routes = directionResponse.routes;

      double distance = 0.0;
      List<maps.LatLng> points = [];

      routes.forEach((route) {});

      for (int i = 0; i < routes.length; ++i) {
        var route = routes[i];
        List<direction.Leg> legs = route.legs;

        // print('${json.encode(route)}');
        distance = 0.0;
        legs.forEach((leg) {
          // print('${leg.startAddress} to ${leg.endAddress}, ');
          leg.steps.forEach((step) {
            distance += step.distance.value;

            List decodedPoints = decodePoly(step.polyline.points);

            List<maps.LatLng> latLngList = convertToLatLng(decodedPoints);

            points = [...points, ...latLngList];
          });
        });

        var color = Colors.blue;
        points.forEach((point) {
          hotspotLocations.forEach((loc) {
            double distance = _calculateDistanceKM(
              point.latitude,
              point.longitude,
              loc.latitude,
              loc.longitude,
            );
            if (distance <= 4.0) {
              color = Colors.red;
            }
          });
        });

        maps.Polyline line = maps.Polyline(
          polylineId: maps.PolylineId(i.toString()),
          points: points,
          color: color,
          width: 10,
        );
        newRoutes.add(line);
        points = [];
        // print('Distance of route: $distance');
      }

      // print(routes.length);

      _routes = newRoutes;

      // for (int index = 0; index < _routes.length; ++index) {
      //   var polyline = _routes.elementAt(index);
      //   if (index == 0) {
      //     _routes.remove(polyline);
      //     polyline = maps.Polyline(
      //       polylineId: maps.PolylineId(DateTime.now().toString()),
      //       color: Colors.blue,
      //       width: 12,
      //       points: polyline.points,

      //     );

      //     _routes.add(polyline);
      //   }
      // }
      notifyListeners();
    }
  }
}
