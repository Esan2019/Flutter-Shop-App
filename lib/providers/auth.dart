import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../constants.dart';

const _baseAuthUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:';

class Auth with ChangeNotifier {
  String _token, _userId;
  DateTime _expiryDate;

  bool get isAuth {
    if (token == null) return false;
    if (_isExpired) return false;
    return true;
  }

  bool get _isExpired => DateTime.now().isAfter(_expiryDate);

  String get token => _token;

  Future<void> signUp(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = '$_baseAuthUrl$urlSegment?key=$firebaseWebApi';
    final payload = _buildPayload(email, password);

    try {
      final response = await http.post(url, body: payload);

      final decodedResponse = json.decode(response.body);

      final expiryDateInSeconds = int.parse(decodedResponse['expiresIn']);
      final now = DateTime.now();

      _token = decodedResponse['idToken'];
      _userId = decodedResponse['localId'];

      // Extracted 2 seconds just to be sure it'll never try to use an
      // expired token
      _expiryDate = now.add(Duration(seconds: expiryDateInSeconds - 2));
    } catch (error) {
      throw error;
    }
    
    notifyListeners();
  }

  String _buildPayload(String email, String password) {
    final mapPayload = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final jsonPayload = json.encode(mapPayload);

    return jsonPayload;
  }
}
