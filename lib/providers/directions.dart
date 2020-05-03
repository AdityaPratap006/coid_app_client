import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_maps_webservice/directions.dart' as direction;

//Configs
import '../config/api_keys.dart';
//Utils
import '../utils/polyline.dart';

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
    var directionResponse = await _directionsApi.directionsWithAddress(
      src,
      dest,
      travelMode: direction.TravelMode.driving,
      units: direction.Unit.metric,
      alternatives: true,
    );

    Set<maps.Polyline> newRoutes = Set();

    if (directionResponse.isOkay) {
      // print(directionResponse.routes[0].legs[0].distance.text);
      maps.BitmapDescriptor covidIcon =
          await maps.BitmapDescriptor.fromAssetImage(
              ImageConfiguration(), 'lib/assets/images/hotspot_location.png');
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

        var color = Colors.blue;
        points.forEach((point) {
          hotspotLocations.forEach((loc) {
            double distance = calculateDistanceKM(
              point.latitude,
              point.longitude,
              loc.latitude,
              loc.longitude,
            );
            if (distance <= 2.0) {
              color = Colors.deepOrange;

              _markers.add(
                maps.Marker(
                  markerId: maps.MarkerId(DateTime.now().toString()),
                  icon: covidIcon,
                  position: loc,
                ),
              );
            }
          });
        });

        maps.Polyline line = maps.Polyline(
          polylineId: maps.PolylineId(i.toString()),
          points: points,
          color: color,
          width: color == Colors.deepOrange ? 8 : 10,
        );
        newRoutes.add(line);
        points = [];
        // print('Distance of route: $distance');
      }

      // print(routes.length);

      _routes = newRoutes;

      // print('From ${routes[0].legs[0].startAddress} to ${routes[0].legs[0].endAddress}');
      _srcCoord = maps.LatLng(routes[0].legs[0].startLocation.lat,
          routes[0].legs[0].startLocation.lng);
      _destCoord = maps.LatLng(
          routes[0].legs[0].endLocation.lat, routes[0].legs[0].endLocation.lng);

      _markers.add(
        maps.Marker(
          markerId: maps.MarkerId(DateTime.now().toString()),
          position: _srcCoord,
          icon: maps.BitmapDescriptor.defaultMarkerWithHue(maps.BitmapDescriptor.hueBlue),
        ),
      );

      _markers.add(
        maps.Marker(
          markerId: maps.MarkerId(DateTime.now().toString()),
          position: _destCoord,
          icon: maps.BitmapDescriptor.defaultMarkerWithHue(maps.BitmapDescriptor.hueGreen),
        ),
      );

      notifyListeners();
    }
  }
}
