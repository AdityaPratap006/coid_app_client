import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/directions_search_box.dart';

//Providers
import '../providers/directions.dart';
import '../providers/hotspot_locations.dart';

//Utils
import '../utils/search_box_decoration.dart';

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

    setState(() {
      _loadingDirections = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final directionsApi = Provider.of<DirectionsProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: deviceSize.width,
            height: deviceSize.height,
            child: GoogleMap(
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
                decoration: SearchBoxDecoration.decoration,
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
          )
        ],
      ),
    );
  }
}
