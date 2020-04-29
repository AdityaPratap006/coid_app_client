import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  Future<void> _searchAndNavigate(String searchAddress) async {
    if (searchAddress == null || searchAddress.trim() == '') {
      return;
    }

    List<Placemark> placemarkList =
        await Geolocator().placemarkFromAddress(searchAddress);

    print('Country: ${placemarkList[0].country}');

    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            placemarkList[0].position.latitude,
            placemarkList[0].position.longitude,
          ),
          zoom: 14,
        ),
      ),
    );
  }

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
          HotspotsSearchBox(
            searchAndNavigate: _searchAndNavigate,
          ),
        ],
      ),
    );
  }
}
