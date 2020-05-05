import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/auth.dart';

//Utils
import '../utils/search_box_decoration.dart';

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
    final user = Provider.of<Auth>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: user == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 10.0,
                      ),
                      padding: EdgeInsets.all(10.0),
                      height: 350,
                      width: double.infinity,
                      decoration: SearchBoxDecoration.decoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: user.photoUrl != null &&
                                    user.photoUrl != ''
                                ? NetworkImage(user.photoUrl)
                                : AssetImage('lib/assets/images/profile.png'),
                          ),
                          Text(
                            '${user.displayName}',
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          _loading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.all(20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Text(
                                    'LOGOUT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _loading = true;
                                    });

                                    try {
                                      await Provider.of<Auth>(context,
                                              listen: false)
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
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 10.0,
                      ),
                      padding: EdgeInsets.all(10.0),
                      height: 150,
                      width: double.infinity,
                      decoration: SearchBoxDecoration.decoration(),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'About App',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Data Source',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Covid19-India API',
                            style: TextStyle(
                              fontSize: 20,
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
