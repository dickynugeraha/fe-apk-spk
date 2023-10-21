import 'package:flutter/material.dart';
import '../screens/auth_screen.dart';

class Helper {
  // static const domainUrl = "http://10.0.2.2:8000/api";
  // static const domainNoApiUrl = "http://10.0.2.2:8000";
  static const domainUrl = "https://e-prestasi.safesor.co.id/api";
  static const domainNoApiUrl = "https://e-prestasi.safesor.co.id";

  static void checkAuthentication(String token, BuildContext context) {
    if (token.isEmpty) {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }
  }
}
