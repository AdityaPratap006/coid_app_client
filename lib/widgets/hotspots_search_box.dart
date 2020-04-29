import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

//Widgets
import '../widgets/profile_button.dart';

//Config
import '../config/api_keys.dart';

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
    if (_searchAddress.trim() == '') {
      setState(() {
        _searchAddress = null;
      });
      return;
    }

    await widget.searchAndNavigate(_searchAddress);
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 10.0),
              blurRadius: 10.0,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -5.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: searchBoxWidth * 0.80,
              alignment: Alignment.center,
              child: TextField(
                onTap: () async {
                  Prediction prediction = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: MY_GOOGLE_MAPS_API_KEY,
                    language: 'en',
                    components: [
                      Component(Component.country, 'IN'),
                    ]
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search places...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _submitAddress,
                    iconSize: 30.0,
                  ),
                ),
                controller: _textController,
                onSubmitted: (val) async {
                  await _submitAddress();
                },
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
