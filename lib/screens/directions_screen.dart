import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/directions_search_box.dart';
import '../widgets/direction_legends.dart';

//Providers
import '../providers/directions.dart';
import '../providers/hotspot_locations.dart';

//Utils
import '../utils/search_box_decoration.dart';
import '../utils/polyline.dart';

class DirectionsScreen extends StatefulWidget {
  @override
  _DirectionsScreenState createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> {
  GoogleMapController _mapController;
  bool _loadingDirections = false;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  Future<void> _drawRoutes({String source, String destination}) async {
    var hotspotLocations =
        Provider.of<HotspotLocations>(context, listen: false).locations;
    var directionsApi = Provider.of<DirectionsProvider>(context, listen: false);

    directionsApi.clearMarkers();
    directionsApi.clearRoutes();

    setState(() {
      _loadingDirections = true;
    });

    await directionsApi.findDirections(
      src: source,
      dest: destination,
      hotspotLocations: hotspotLocations.map((loc) {
        return LatLng(loc.coordinates.latitude, loc.coordinates.longitude);
      }).toList(),
    );

    LatLng srcCoord = directionsApi.sourceCoord;
    LatLng destCoord = directionsApi.destinationCoord;
    LatLng midPoint = LatLng((srcCoord.latitude + destCoord.latitude) / 2,
        (srcCoord.longitude + destCoord.longitude) / 2);
    // LatLngBounds bounds = LatLngBounds(northeast: srcCoord, southwest: destCoord);

    double distance = calculateDistanceKM(srcCoord.latitude, srcCoord.longitude,
        destCoord.latitude, destCoord.longitude);
    double zoom;
    if (distance >= 1000) {
      zoom = 4;
    } else if (distance >= 500 && distance < 1000) {
      zoom = 5;
    } else if (distance >= 100 && distance < 500) {
      zoom = 6;
    } else if (distance >= 50 && distance < 100) {
      zoom = 8;
    } else if (distance >= 10 && distance < 50) {
      zoom = 10;
    } else {
      zoom = 12;
    }

    // await _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 10.0));
    await _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(midPoint, zoom));
    setState(() {
      _loadingDirections = false;
    });
  }

  @override
  void initState() {
    var directionsApi = Provider.of<DirectionsProvider>(context, listen: false);
    directionsApi.clearMarkers();
    directionsApi.clearRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final directionsApi = Provider.of<DirectionsProvider>(
    //   context,
    //   listen: false,
    // );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: deviceSize.width,
            height: deviceSize.height,
            child: Consumer<DirectionsProvider>(
              builder: (ctx, directionsApi, _) => GoogleMap(
                mapType: MapType.normal,
                buildingsEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(23, 79),
                  zoom: 5,
                ),
                onMapCreated: _onMapCreated,
                polylines: directionsApi.currentRoute,
                markers: directionsApi.markers,
              ),
            ),
          ),
          if (_loadingDirections == false)
            DirectionsSearchBox(
              drawRoutes: _drawRoutes,
            ),
          Positioned(
            top: 200,
            left: 15,
            right: 15,
            child: Visibility(
              visible: _loadingDirections,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: deviceSize.height * 0.30,
                decoration: SearchBoxDecoration.decoration(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: Text(
                    'Calculating routes. Please wait...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 8,
            child: Consumer<DirectionsProvider>(
              builder: (ctx, directionsApi, _) => Visibility(
                visible: directionsApi.currentRoute.isNotEmpty,
                child: DirectionLegends(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
