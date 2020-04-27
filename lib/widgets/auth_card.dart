import 'package:flutter/material.dart';

enum AuthMode {
  SignUp,
  Login,
}

class AuthCard extends StatefulWidget {
  final Function moveUp;
  final Function moveDown;

  const AuthCard({
    Key key,
    this.moveUp,
    this.moveDown,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  AuthMode _authMode = AuthMode.Login;

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      widget.moveDown();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      widget.moveUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _authMode == AuthMode.Login ? 330 : 440,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 15.0),
            blurRadius: 15.0,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -10.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        child: Form(
          child: Column(
            children: <Widget>[
              Text(
                '${_authMode == AuthMode.SignUp ? 'Sign Up' : 'Login'}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (_authMode == AuthMode.SignUp) 
               TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                focusNode: _emailFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                focusNode: _passwordFocusNode,
                textInputAction: (_authMode == AuthMode.SignUp) ? TextInputAction.next : null,
                obscureText: true,
                onFieldSubmitted: (_) {
                  if (_authMode == AuthMode.SignUp) {
                    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                  }
                  
                },
              ),
               if (_authMode == AuthMode.SignUp) 
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                focusNode: _confirmPasswordFocusNode,
                
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    hoverColor: Colors.red,
                    child: Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).accentColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6078ea).withOpacity(.3),
                            offset: Offset(0.0, 8.0),
                            blurRadius: 8.0,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: Text(
                              '${_authMode == AuthMode.SignUp ? 'SIGNUP' : 'LOGIN'}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                 
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
               Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text(
                          '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                      onPressed: _switchAuthMode,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
