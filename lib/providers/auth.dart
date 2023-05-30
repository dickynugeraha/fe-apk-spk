import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './helper.dart';

class Auth with ChangeNotifier {
  String _token;
  String _username;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isLogin {
    return token != null;
  }

  String get token {
    if (_token != null
        // && _expiryDate != null &&
        //    _expiryDate.isAfter(DateTime.now())
        ) {
      return _token;
    }
    return null;
  }

  String get username {
    return _username;
  }

  Future<void> _authenticated(
      String username, String password, String urlSegment) async {
    final url = Uri.parse("${Helper.domainUrl}$urlSegment");
    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: json.encode(
          {
            "username": username,
            "password": password,
          },
        ),
      );
      final responseBody = json.decode(response.body);
      if (responseBody["error"] != null) {
        var errorMessage = responseBody["error"]["message"];
        throw HttpException(errorMessage);
      }
      _token = responseBody["token"];
      _username = responseBody["admin"]["username"];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final adminData = json.encode({"token": token, "username": username});
      prefs.setString("adminData", adminData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(
      String username, String password, String urlSegment) async {
    return _authenticated(username, password, urlSegment);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("adminData")) {
      return false;
    }

    final extractAdminData =
        json.decode(prefs.getString("adminData")) as Map<String, dynamic>;

    _token = extractAdminData["token"];
    _username = extractAdminData["username"];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final tokenId = token.split("|")[1];
    print(tokenId);
    final url = Uri.parse("${Helper.domainUrl}/admin/logout");
    try {
      await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(
          {"username": username, "token_id": tokenId},
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (e) {
      rethrow;
    }

    _token = null;
    _username = null;
    notifyListeners();
  }
}
