import 'package:flutter/material.dart';
import '../screens/auth_screen.dart';

class Helper {
  // static const domainUrl = "http://10.0.2.2:8000/api";
  // static const domainNoApiUrl = "http://10.0.2.2:8000";
  static const domainUrl = "https://e-prestasi.safesor.co.id/api";
  static const domainNoApiUrl = "https://e-prestasi.safesor.co.id";
  // static const domainUrl = "http://192.168.1.7:8000/api";
  // static const domainNoApiUrl = "http://192.168.1.7:8000";
  // static const domainUrl = "http://127.0.0.1:8000/api";
  // static const domainNoApiUrl = "http://127.0.0.1:8000";
  // static const domainUrl = "http://localhost:8000/api";
  // static const domainNoApiUrl = "http://localhost:8000";

  static void checkAuthentication(String token, BuildContext context) {
    if (token.isEmpty || token == null) {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }
  }
}
