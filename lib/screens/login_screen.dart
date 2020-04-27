import 'package:flutter/material.dart';

//widgets
import '../widgets/auth_card.dart';
import '../widgets/google_login_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget horizontalLine({double width}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: width,
          height: 2,
          color: Colors.black26.withOpacity(0.2),
        ),
      );

  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  void _moveUp() {
    _controller.animateTo(_controller.offset - 200,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  void _moveDown() {
    _controller.animateTo(_controller.offset + 200,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
          width: deviceSize.width,
          height: deviceSize.height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Image.asset(
                      "lib/assets/images/doctor_fights.jpg",
                      width: deviceSize.width * 0.60,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Expanded(
                    child: ClipRRect(
                       borderRadius: BorderRadius.vertical(top: Radius.elliptical(deviceSize.width, 100)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                controller: _controller,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Image.asset(
                                'lib/assets/images/logo.png',
                                width: 100,
                              ),
                              Text(
                                'COVID RADAR',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GoogleLoginButton(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          horizontalLine(width: deviceSize.width * 0.20),
                          Text(
                            'OR',
                            style: TextStyle(fontSize: 20),
                          ),
                          horizontalLine(width: deviceSize.width * 0.20),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AuthCard(
                        moveUp: _moveUp,
                        moveDown: _moveDown,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}


