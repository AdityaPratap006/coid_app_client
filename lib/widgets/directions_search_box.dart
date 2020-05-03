import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

//Config
import '../config/api_keys.dart';

//Utils
import '../utils/search_box_decoration.dart';

enum SearchType {
  SOURCE,
  DESTINATION,
}

class DirectionsSearchBox extends StatefulWidget {
  final Future<void> Function({String source, String destination}) drawRoutes;

  DirectionsSearchBox({this.drawRoutes});
  @override
  _DirectionsSearchBoxState createState() => _DirectionsSearchBoxState();
}

class _DirectionsSearchBoxState extends State<DirectionsSearchBox> {
  String _source = '';
  String _destination = '';

  final _srcTextController = TextEditingController();
  final _destTextController = TextEditingController();
  final _srcFocusNode = FocusNode();
  final _destFocusNode = FocusNode();

  void _setSource() {
    setState(() {
      _source = _srcTextController.text;
    });
  }

  void _setDestination() {
    setState(() {
      _destination = _destTextController.text;
    });
  }

  Future<void> _showPlacesSuggestions(SearchType searchType) async {
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
        if (searchType == SearchType.SOURCE) {
          _srcTextController.text = details.result.formattedAddress;
          _source = details.result.formattedAddress;

          if (_destination == '') {
            // _destFocusNode.requestFocus();
          } else {
            FocusScope.of(context).requestFocus(FocusNode());

            widget.drawRoutes(source: _source, destination: _destination);
          }
        } else if (searchType == SearchType.DESTINATION) {
          _destTextController.text = details.result.formattedAddress;
          _destination = details.result.formattedAddress;

          if (_source == '') {
            // _srcFocusNode.requestFocus();
          } else {
            FocusScope.of(context).requestFocus(FocusNode());

            widget.drawRoutes(source: _source, destination: _destination);
          }
        }
      });
    } else {
      // setState(() {
      //   if (searchType == SearchType.SOURCE) {
      //     _srcTextController.text = '';
      //     _source = '';
      //   } else if (searchType == SearchType.DESTINATION) {
      //     _destTextController.text = '';
      //     _destination = '';
      //   }
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    _srcTextController.addListener(_setSource);
    _destTextController.addListener(_setDestination);
  }

  @override
  void dispose() {
    _srcTextController.dispose();
    _destTextController.dispose();
    _srcFocusNode.dispose();
    _destFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBoxWidth = (MediaQuery.of(context).size.width - 30);
    return Positioned(
      top: 50,
      left: 15,
      right: 15,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: SearchBoxDecoration.decoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: searchBoxWidth * 0.80,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: TextField(
                      // onChanged: (val) {
                      //   _showPlacesSuggestions(SearchType.SOURCE);
                      // },
                      onTap: () {
                        _showPlacesSuggestions(SearchType.SOURCE);
                      },

                      decoration: InputDecoration(
                        hintText: 'Source...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                        ),
                      ),
                      focusNode: _srcFocusNode,
                      controller: _srcTextController,
                      textInputAction: _destination == ''
                          ? TextInputAction.next
                          : TextInputAction.go,
                      onSubmitted: (val) {
                        // if (_destination == '') {
                        //   _destFocusNode.requestFocus();
                        //   return;
                        // }
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextField(
                      // onChanged: (val) {
                      //   _showPlacesSuggestions(SearchType.DESTINATION);
                      // },
                      onTap: () {
                        _showPlacesSuggestions(SearchType.DESTINATION);
                      },
                      decoration: InputDecoration(
                        hintText: 'Destination...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 5.0),
                      ),
                      focusNode: _destFocusNode,
                      textInputAction: _source == ''
                          ? TextInputAction.next
                          : TextInputAction.go,
                      controller: _destTextController,
                      onSubmitted: (val) {
                        // if (_source == '') {
                        //   _srcFocusNode.requestFocus();
                        //   return;
                        // }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: searchBoxWidth * 0.20,
              height: double.infinity,
              alignment: Alignment.center,
              child: Visibility(
                visible: _source != '' && _destination != '',
                child: FloatingActionButton(
                  child: Icon(
                    Icons.directions,
                    size: 30,
                  ),
                  onPressed: () async {
                    widget.drawRoutes(
                        source: _source, destination: _destination);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
