import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsScreen extends StatefulWidget {
  @override
  _DirectionsScreenState createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> {
  GoogleMapController  _mapController;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: deviceSize.width,
            height: deviceSize.height,
            child: GoogleMap(
              mapType: MapType.normal,
              buildingsEnabled: true,
              trafficEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(23, 79),
                zoom: 5,
              ),
              onMapCreated: _onMapCreated,
            ),
          ),
        ],
      ),
    );
  }
}
