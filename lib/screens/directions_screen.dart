import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/directions_search_box.dart';

//Providers
import '../providers/directions.dart';
import '../providers/hotspot_locations.dart';

class DirectionsScreen extends StatefulWidget {
  @override
  _DirectionsScreenState createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> {
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();

    var hotspotLocations =
        Provider.of<HotspotLocations>(context, listen: false).locations;
    var directionsApi = Provider.of<DirectionsProvider>(context, listen: false);

    directionsApi.findDirections(
      src: 'Amethiya Nagar Road, Amitha Nagar, Namkum, Ranchi, Jharkhand',
      dest:
          '-301 Degree Farhenheit Ice Cream Parlour, New Barhi Toli, Ranchi, Jharkhand 834001',
      hotspotLocations: hotspotLocations.map((loc) {
        return LatLng(loc.coordinates.latitude, loc.coordinates.longitude);
      }).toList(),
    );
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
            child: Consumer<DirectionsProvider>(
              builder: (ctx, directionApi, _) => GoogleMap(
                mapType: MapType.normal,
                buildingsEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(23, 79),
                  zoom: 5,
                ),
                onMapCreated: _onMapCreated,
                polylines: directionApi.currentRoute,
              ),
            ),
          ),
          DirectionsSearchBox(),
        ],
      ),
    );
  }
}
