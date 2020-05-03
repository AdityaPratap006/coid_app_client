import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

//Widgets
import '../widgets/profile_button.dart';

//Config
import '../config/api_keys.dart';

//Utils
import '../utils/search_box_decoration.dart';

class HotspotsSearchBox extends StatefulWidget {
  final Function(String) searchAndNavigate;

  HotspotsSearchBox({this.searchAndNavigate});

  @override
  _HotspotsSearchBoxState createState() => _HotspotsSearchBoxState();
}

class _HotspotsSearchBoxState extends State<HotspotsSearchBox> {
  String _searchAddress;

  final _textController = TextEditingController();

  void _setAddress() {
    setState(() {
      _searchAddress = _textController.text;
    });
  }

  @override
  void initState() {
    super.initState();

    _textController.addListener(_setAddress);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitAddress() async {
    FocusScope.of(context).requestFocus(FocusNode());

    await widget.searchAndNavigate(_searchAddress);
  }

  Future<void> _showPlacesSuggestions() async {
    Prediction prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: MY_GOOGLE_MAPS_API_KEY,
      language: 'en',
      mode: Mode.overlay,
      components: [
        Component(Component.country, 'IN'),
      ],
    );

    if (prediction != null) {
      final places = GoogleMapsPlaces(apiKey: MY_GOOGLE_MAPS_API_KEY);
      PlacesDetailsResponse details =
          await places.getDetailsByPlaceId(prediction.placeId);

      setState(() {
        _textController.text = details.result.formattedAddress;
        _searchAddress = details.result.formattedAddress;
        _submitAddress();
      });
    } else {
      setState(() {
        _searchAddress = null;
        _textController.text = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchBoxWidth = (MediaQuery.of(context).size.width - 30);
    return Positioned(
      top: 50,
      right: 15,
      left: 15,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: SearchBoxDecoration.decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: searchBoxWidth * 0.70,
              alignment: Alignment.center,
              child: TextField(
                onChanged: (val) {
                  _showPlacesSuggestions();
                },
                onTap: _showPlacesSuggestions,
                decoration: InputDecoration(
                  hintText: 'Search places...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 5.0),
                ),
                controller: _textController,
                onSubmitted: (val) async {
                  await _submitAddress();
                },
              ),
            ),
            Container(
              width: searchBoxWidth * 0.10,
              height: double.infinity,
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: _submitAddress,
                iconSize: 30.0,
              ),
            ),
            Container(
              width: searchBoxWidth * 0.20,
              height: double.infinity,
              alignment: Alignment.center,
              child: ProfileButton(),
            ),
          ],
        ),
      ),
    );
  }
}
