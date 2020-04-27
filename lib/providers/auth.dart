import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Models
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expiryTime;
  Timer _authTimer;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuth {
    return token != null && _userId != null;
  }

  Stream<FirebaseUser> get onAuthStateChanged {
    return FirebaseAuth.instance.onAuthStateChanged;
  }

  String get token {
    if (_expiryTime != null &&
        _expiryTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

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

      FirebaseUser currentUser = authResult.user;

      IdTokenResult tokenResult = await currentUser.getIdToken();

      _userId = currentUser.uid;
      _token = tokenResult.token;
      _expiryTime = tokenResult.expirationTime;

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'expiryTime': _expiryTime.toIso8601String(),
        'token': _token,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final _auth = FirebaseAuth.instance;
    final currentUser = await _auth.currentUser();

    // print('auto login: ${prefs.getString('userData')}');
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    // final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    final idTokenResult = await currentUser.getIdToken();

    final expiryDate = idTokenResult.expirationTime;

    if (expiryDate.isBefore(DateTime.now())) {
      // token is invalid
      print('token expired');
      return false;
    }

    _token = idTokenResult.token;
    _userId = currentUser.uid;
    _expiryTime = expiryDate;

    print('userData: $extractedUserData');
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _userId = null;
    _expiryTime = null;
    _token = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    Duration difference = _expiryTime.difference(DateTime.now());

    _authTimer = Timer(difference, () {
      logout();
    });
  }
}
