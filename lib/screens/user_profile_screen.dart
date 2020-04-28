import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/auth.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

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
     final user = Provider.of<Auth>(context, listen: false).user;

    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${user.displayName}'),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : FlatButton(
                    color: Theme.of(context).accentColor,
                    child: Text('LOGOUT'),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });

                      try {
                        await Provider.of<Auth>(context, listen: false)
                            .logout();
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
      );
  }
}