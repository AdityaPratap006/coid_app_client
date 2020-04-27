import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Models
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  FirebaseUser _user;
  String _token;
  DateTime _expiryTime;

  bool get isAuth {
    return token != null && _user != null;
  }

  String get token {
    if (_token != null &&
        _expiryTime != null &&
        _expiryTime.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  FirebaseUser get user {
    if (token != null) {
      return _user;
    }
    return null;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> googleSignIn() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw HttpException(message: 'Sign In Cancelled!');
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      AuthResult authResult = await _auth.signInWithCredential(credential);

      IdTokenResult tokenResult = await authResult.user.getIdToken();

      _user = authResult.user;
      _token = tokenResult.token;
      _expiryTime = tokenResult.expirationTime;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    _expiryTime = null;
    _token = null;

    notifyListeners();
  }
}
