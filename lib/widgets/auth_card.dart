import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/auth.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
  };

  bool _isLoading = false;
  // bool _autoValidate = false;

  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

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

  void _showErrorDialog({String message, String title = 'An Error Occured!'}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      //Invalid!

      return;
    }

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).loginWithEmail(
          email: _authData['email'],
          password: _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signUpWithEmail(
          email: _authData['email'],
          password: _authData['password'],
        );
      }
    } on PlatformException catch (error) {
      if (error.code == 'ERROR_WRONG_PASSWORD') {
        _showErrorDialog(
          message: 'Wrong password! Please try again.',
        );
      } else if (error.code == 'ERROR_USER_NOT_FOUND') {
        _showErrorDialog(
          message: 'We couldn\'t find a user with that email.',
        );
      } else if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        _showErrorDialog(
          message: 'This email is already in use. Please use a different email.',
        );
      } else {
        _showErrorDialog(
          message: error.code,
        );
      }
    } catch (error) {
      const errorMessage =
          'We couldn\'t authenticate you. Please try again later.';
      _showErrorDialog(message: errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _authMode == AuthMode.Login ? 360 : 540,
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
          vertical: 12,
        ),
        child: Form(
          key: _formKey,
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                focusNode: _emailFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 6) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                focusNode: _passwordFocusNode,
                textInputAction: (_authMode == AuthMode.SignUp)
                    ? TextInputAction.next
                    : null,
                obscureText: true,
                onFieldSubmitted: (_) {
                  if (_authMode == AuthMode.SignUp) {
                    FocusScope.of(context)
                        .requestFocus(_confirmPasswordFocusNode);
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              if (_authMode == AuthMode.SignUp)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  enabled: _authMode == AuthMode.SignUp,
                  validator: _authMode == AuthMode.SignUp
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        }
                      : null,
                  textInputAction: (_authMode == AuthMode.SignUp)
                      ? TextInputAction.next
                      : null,
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: true,
                  onFieldSubmitted: (_) {
                    if (_authMode == AuthMode.SignUp) {
                      FocusScope.of(context).requestFocus(_nameFocusNode);
                    }
                  },
                ),
              if (_authMode == AuthMode.SignUp)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  focusNode: _nameFocusNode,
                  enabled: _authMode == AuthMode.SignUp,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name is required!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['name'] = value;
                  },
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
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
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
                                onTap: _submit,
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
                padding: const EdgeInsets.all(4.0),
                child: FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
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
