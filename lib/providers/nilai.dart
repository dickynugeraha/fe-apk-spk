import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './helper.dart';
import '../models/siswa.dart';

class NilaiProvider with ChangeNotifier {
  String _nisn;
  String _token;

  List<Nilai> _items;
  Nilai _item;
  bool _isAvailableNilai;

  void update(String nisnEntered, String tokenEntered) {
    _nisn = nisnEntered;
    _token = tokenEntered;
    notifyListeners();
  }

  List<Nilai> get items {
    return [..._items];
  }

  Nilai get item {
    return _item;
  }

  bool get isAvailableNilai {
    return _isAvailableNilai;
  }

  Future<void> storeNilai(List<Map<String, dynamic>> data) async {
    try {
      final response = await http.post(
        Uri.parse("${Helper.domainUrl}/nilai"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
        body: json.encode({
          "nisn": _nisn,
          "nilai": data,
        }),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setAndSetNilaiSiswa() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await http.get(
        Uri.parse("${Helper.domainUrl}/nilai/$_nisn"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      );

      // final nilai = json.decode(response.body)["nilai"];

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
