import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/auth.dart' as authProvider;


class GoogleLoginButton extends StatefulWidget {
  @override
  _GoogleLoginButtonState createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RaisedButton(
              color: Theme.of(context).accentColor,
              splashColor: Theme.of(context).primaryColor,
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'lib/assets/images/google_logo.png',
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'Sign In with Google'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                try {
                  await Provider.of<authProvider.Auth>(
                    context,
                    listen: false,
                  ).googleSignIn();

                } catch (e) {
                  var errorMessage = e.toString();

                  _showErrorDialog(errorMessage);
                }

                setState(() {
                  _loading = false;
                });
              },
            ),
    );
  }
}
