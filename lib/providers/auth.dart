import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../exceptions/firebase_exception.dart';
import '../exceptions/http_exception.dart';

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
      final errorOccurred = decodedResponse['error'] != null;

      if (errorOccurred) {
        throw FirebaseException(decodedResponse['error']['message']);
      }

      final tokenValidityInSeconds = int.parse(decodedResponse['expiresIn']);
      final tokenValidity = Duration(seconds: tokenValidityInSeconds);
      final tokenExpiryDate = DateTime.now().add(tokenValidity);

      _token = decodedResponse['idToken'];
      _userId = decodedResponse['localId'];
      _expiryDate = tokenExpiryDate;
    } on FirebaseException {
      rethrow;
    } catch (error) {
      throw HttpException(
        'Não foi possível se conectar. Verifique se você possui uma conexão com a internet.',
      );
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
