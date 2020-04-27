import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Something Went Wrong:'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${Provider.of<Auth>(context).user.displayName}'),
            FlatButton(
              color: Theme.of(context).accentColor,
              child: Text('LOGOUT'),
              onPressed: () async {

                setState(() {
                  _loading = true;
                });

                try {
                  await Provider.of<Auth>(context, listen: false).logout();
                } catch (error) {
                  var errorMessage = error.toString();

                  _showErrorDialog(errorMessage);
                }

                setState(() {
                  _loading = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
