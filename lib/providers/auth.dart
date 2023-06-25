import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './helper.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _username;
  String _nisn;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isLogin {
    return _token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get username {
    return _username;
  }

  String get nisn {
    return _nisn;
  }

  Future<void> _authenticatedLogin(
    String username,
    String password,
    String urlSegment,
  ) async {
    final url = Uri.parse("${Helper.domainUrl}$urlSegment");

    final segmentLogin = urlSegment.split("/")[1];

    String stringIdentity = "username";

    if (segmentLogin == "siswa") {
      stringIdentity = "nisn";
    }

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(
          {
            stringIdentity: username.toString(),
            "password": password.toString(),
          },
        ),
      );
      final responseBody = json.decode(response.body);

      if (responseBody["error"] != null) {
        var errorMessage = responseBody["error"]["message"];
        throw HttpException(errorMessage);
      }

      final prefs = await SharedPreferences.getInstance();

      _token = responseBody["token"];
      _expiryDate = DateTime.now().add(const Duration(seconds: 7200));

      if (segmentLogin == "siswa") {
        _nisn = responseBody["siswa"]["nisn"];
        final siswaData = json.encode({
          "token": _token,
          "nisn": _nisn,
          "expiryDate": _expiryDate.toIso8601String(),
        });
        prefs.setString("dataAuth", siswaData);
      } else {
        _username = responseBody["admin"]["username"];
        final adminData = json.encode({
          "token": _token,
          "username": _username,
          "expiryDate": _expiryDate.toIso8601String(),
        });
        prefs.setString("dataAuth", adminData);
      }
      _autoLogout();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _authenticatedRegister(
    Map<String, String> registerData,
    String urlSegment,
  ) async {
    final url = Uri.parse("${Helper.domainUrl}$urlSegment");

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=UTF-8"
        },
        body: json.encode(
          {
            "nisn": registerData["nisn"].toString(),
            "nama": registerData["nama"].toString(),
            "jenis_kelamin": registerData["jenis_kelamin"].toString(),
            "alamat": registerData["alamat"].toString(),
            "asal_sekolah": registerData["asal_sekolah"].toString(),
            "no_hp_ortu": registerData["no_hp_ortu"].toString(),
            "email": registerData["email"].toString(),
            "password": registerData["password"].toString(),
          },
        ),
      );
      final responseBody = json.decode(response.body);

      if (responseBody["error"] != null) {
        final errorMessage = responseBody["error"]["message"];
        throw HttpException(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(
      String username, String password, String urlSegment) async {
    return _authenticatedLogin(username, password, urlSegment);
  }

  Future<void> register(
      Map<String, String> registerData, String urlSegment) async {
    return _authenticatedRegister(registerData, urlSegment);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("dataAuth")) {
      return false;
    }

    final extractDataAuth =
        json.decode(prefs.getString("dataAuth")) as Map<String, Object>;
    final expiredDate = DateTime.parse(extractDataAuth["expiryDate"]);

    if (expiredDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractDataAuth["token"];
    _username = extractDataAuth["username"];
    _nisn = extractDataAuth["nisn"];
    _expiryDate = expiredDate;
    _autoLogout();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    String segment = "admin";
    if (_nisn != null) {
      segment = "siswa";
    }
    final url = Uri.parse("${Helper.domainUrl}/$segment/logout");
    final tokenId = _token.split("|")[1];

    try {
      await http.post(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        },
        body: json.encode(
          {
            segment == 'siswa' ? "nisn" : "username":
                segment == 'siswa' ? _nisn : _username,
            "token_id": tokenId
          },
        ),
      );
      _token = null;
      _username = null;
      _nisn = null;
      if (_authTimer != null) {
        _authTimer.cancel();
        _authTimer = null;
      }
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("dataAuth");
      prefs.clear();
    } catch (e) {
      rethrow;
    }
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeExpiry = _expiryDate.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeExpiry), logout);
  }
}
