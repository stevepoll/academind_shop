import 'dart:async';
import 'dart:convert';

import 'package:academind_shop/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isLoggedIn {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  static const API_KEY = 'AIzaSyCkvcglIYmDR2gGFAdxFA8Kk58vB1JSo48';

  Future<void> _authenticate(String email, String pw, String urlAction) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlAction?key=';
    try {
      final response = await http.post(
        '$url$API_KEY',
        body: json.encode({
          'email': email,
          'password': pw,
          'returnSecureToken': true,
        }),
      );
      final resData = json.decode(response.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }

      final expireSeconds = int.parse(resData['expiresIn']);
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: expireSeconds));

      _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final userData = json.decode(prefs.get('userData'));
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    _autoLogout();

    notifyListeners();
    return true;
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
