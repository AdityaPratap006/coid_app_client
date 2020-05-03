import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';


double calculateDistanceKM(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

// !DECODE POLY
List decodePoly(String poly) {
  var list = poly.codeUnits;
  var lList = new List();
  int index = 0;
  int len = poly.length;
  int c = 0;
// repeating until all attributes are decoded
  do {
    var shift = 0;
    int result = 0;

    // for decoding value of one attribute
    do {
      c = list[index] - 63;
      result |= (c & 0x1F) << (shift * 5);
      index++;
      shift++;
    } while (c >= 32);
    /* if value is negetive then bitwise not the value */
    if (result & 1 == 1) {
      result = ~result;
    }
    var result1 = (result >> 1) * 0.00001;
    lList.add(result1);
  } while (index < len);

/*adding to previous value as done in encoding */
  for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

  // print(lList.toString());

  return lList;
}

// ! CREATE LATLNG LIST
  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }