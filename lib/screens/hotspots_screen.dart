import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Providers

//Widgets
import '../widgets/hotspots_search_box.dart';

class HotspotsScreen extends StatefulWidget {
  @override
  _HotspotsScreenState createState() => _HotspotsScreenState();
}

class _HotspotsScreenState extends State<HotspotsScreen> {
  GoogleMapController _mapController;
  String _searchAddress;

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
            height: deviceSize.height,
            width: deviceSize.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(23, 79),
                zoom: 5,
              ),
              onMapCreated: _onMapCreated,
            ),
          ),
          HotspotsSearchBox(),
        ],
      ),
    );
  }
}
