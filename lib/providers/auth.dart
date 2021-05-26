import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p_shop/models/http_exception.dart';
import 'dart:async';

class Auth extends ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

// urlSegment = signUp || signInWithPassword
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBwuo12zWcI-lPIxVsDHhrfpNnd4NWfMO8';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token =
          responseData['idToken']; //ID xác thực cho người dùng đã xác thực.
      _userId = responseData['localId']; //uid nguoi dung duoc xac thuc
      // thoi gian het han cua token
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      final prest = await SharedPreferences.getInstance();
      prest.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

// sign up
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

//login
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  //try autologin
  Future<void> tryAutoLogin() async {
    final prest = await SharedPreferences.getInstance();
    if (!prest.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prest.getString('userData')) as Map<String, Object>;
    final expiryData = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryData.isBefore(DateTime.now())) {
      return false;
    }
    _userId = extractedUserData['userId'];
    _token = extractedUserData['token'];
    _expiryDate = expiryData;
    notifyListeners();
    autoLogout();
    return true;
  }

  //logout
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prest = await SharedPreferences.getInstance();
    prest.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
