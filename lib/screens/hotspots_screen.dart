import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/hotspot_locations.dart';

//Widgets
import '../widgets/hotspots_search_box.dart';

//Models
import '../models/location.dart';

class HotspotsScreen extends StatefulWidget {
  @override
  _HotspotsScreenState createState() => _HotspotsScreenState();
}

class _HotspotsScreenState extends State<HotspotsScreen> {
  GoogleMapController _mapController;
  bool _currentLocationLoading = false;
  Set<Marker> _markers = Set();
  bool _hotspotLocationsLoading = false;

  Future<void> _searchAndNavigate(String searchAddress) async {
    if (searchAddress == null ||
        (searchAddress != null && searchAddress.trim() == '')) {
      return;
    }

    List<Placemark> placemarkList =
        await Geolocator().placemarkFromAddress(searchAddress);

    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            placemarkList[0].position.latitude,
            placemarkList[0].position.longitude,
          ),
          zoom: 16,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _showCustomDialog({String title, String content, Function action}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();

              if (action != null) {
                action();
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _currentLocationLoading = true;
    });

    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    GeolocationStatus status =
        await geolocator.checkGeolocationPermissionStatus();

    if (status != GeolocationStatus.granted) {
      _showCustomDialog(
        title: 'Can\'t access Location!',
        content: 'Turn on the location permissions for Covid Radar.',
        action: () async {
          await LocationPermissions().openAppSettings();
        },
      );
    } else {
      try {
        Position pos = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );

        BitmapDescriptor myMarkerIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(),
          'lib/assets/images/user_location.png',
        );

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('my_location'),
              icon: myMarkerIcon,
              position: LatLng(pos.latitude, pos.longitude),
            ),
          );
        });

        await _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                pos.latitude,
                pos.longitude,
              ),
              zoom: 16.0,
            ),
          ),
        );
      } catch (error) {
        _showCustomDialog(
          title: 'An error occurred!',
          content: error.toString(),
        );
      }
    }

    setState(() {
      _currentLocationLoading = false;
    });
  }

  Future<void> _setHotspotMarkers(List<LocationData> locations) async {
    // final deviceSize = MediaQuery.of(context).size;
    BitmapDescriptor hotspotIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'lib/assets/images/hotspot_location.png',
    );
    locations.forEach((loc) {
      _markers.add(
        Marker(
          markerId: MarkerId(loc.location + loc.caseCount.toString()),
          icon: hotspotIcon,
          position: LatLng(loc.coordinates.latitude, loc.coordinates.longitude),
        ),
      );
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _setHotspotMarkers(
      Provider.of<HotspotLocations>(context, listen: false).locations,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    print(
        Provider.of<HotspotLocations>(context, listen: false).locations.length);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: _hotspotLocationsLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    mapType: MapType.normal,
                    buildingsEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(23, 79),
                      zoom: 5,
                    ),
                    onMapCreated: _onMapCreated,
                    markers: _markers,
                    compassEnabled: true,
                  ),
          ),
          HotspotsSearchBox(
            searchAndNavigate: _searchAndNavigate,
          ),
          Positioned(
            bottom: 10.0,
            left: deviceSize.width * 0.30,
            right: deviceSize.width * 0.30,
            child: _currentLocationLoading
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    onPressed: _getCurrentLocation,
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).accentColor,
                    splashColor: Theme.of(context).accentColor,
                    child: Text(
                      'Locate me'.toUpperCase(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
