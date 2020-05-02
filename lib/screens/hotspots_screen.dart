import 'dart:math';

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
  LatLng _currentLocation;
  Set<Marker> _markers = Set();
  bool _hotspotLocationsLoading = false;
  double _cameraBearing = 0.0;
  LatLng _cameraTarget = LatLng(23, 79);
  double _cameraZoom = 14;

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
        if (_currentLocation == null) {
          Position pos = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          );

          BitmapDescriptor myMarkerIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            'lib/assets/images/user_location.png',
          );

          setState(() {
            _currentLocation = LatLng(pos.latitude, pos.longitude);
            _markers.add(
              Marker(
                markerId: MarkerId('my_location'),
                icon: myMarkerIcon,
                position: LatLng(pos.latitude, pos.longitude),
                infoWindow: InfoWindow(
                  title: 'My Location',
                ),
              ),
            );
          });
        }

        await _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentLocation,
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
          infoWindow: InfoWindow(
            title: loc.location.trimLeft()[0] == ','
                ? loc.location.trimLeft().substring(1)
                : loc.location.trimLeft(),
            snippet: 'There are multiple covid cases within 6 KM radius.',
          ),
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
                    compassEnabled: false,
                    onCameraMove: (CameraPosition pos) {
                      setState(() {
                        _cameraBearing = pos.bearing;
                        _cameraTarget = pos.target;
                        _cameraZoom = pos.zoom;
                      });
                    },
                  ),
          ),
          HotspotsSearchBox(
            searchAndNavigate: _searchAndNavigate,
          ),
          Positioned(
            top: 120.0,
            right: 8.0,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentLocationLoading) {
                  return;
                }

                _getCurrentLocation();
              },
              backgroundColor: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).accentColor,
              child: Icon(Icons.location_searching),
            ),
          ),
          Positioned(
            top: 200.0,
            right: 8.0,
            child: FloatingActionButton(
              child: Transform.rotate(
                angle: -(pi / 180) * _cameraBearing,
                child: Icon(Icons.navigation),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).accentColor,
              onPressed: () async {
                setState(() {
                  _cameraBearing = 0.0;
                });
                await _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _cameraTarget,
                      bearing: 0.0,
                      zoom: _cameraZoom,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
