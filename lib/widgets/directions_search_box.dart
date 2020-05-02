import 'package:flutter/material.dart';

//Utils
import '../utils/search_box_decoration.dart';


class DirectionsSearchBox extends StatefulWidget {
  @override
  _DirectionsSearchBoxState createState() => _DirectionsSearchBoxState();
}

class _DirectionsSearchBoxState extends State<DirectionsSearchBox> {
  String _source;
  String _destination;

  final _srcTextController = TextEditingController();
  final _destTextController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 15,
      right: 15,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: SearchBoxDecoration.decoration,
        child: null,
      ),
    );
  }
}
