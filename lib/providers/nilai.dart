import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './helper.dart';
import '../models/siswa.dart';

class NilaiProvider with ChangeNotifier {
  String _nisn;
  String _token;

  List<Ranking> _items;
  Ranking _item;

  void update(String nisnEntered, String tokenEntered) {
    _nisn = nisnEntered;
    _token = tokenEntered;
    notifyListeners();
  }

  List<Ranking> get items {
    return [..._items];
  }

  Ranking get item {
    return _item;
  }

  Future<void> storeNilai(List<Map<String, dynamic>> data) async {
    try {
      await http.post(
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

  Future<void> getHasilPerhitungan() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await http.get(
        Uri.parse("${Helper.domainUrl}/nilai"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      );
      final dataSeleksi = json.decode(response.body)["data"];

      List<Ranking> loadedData = [];

      for (var siswa in dataSeleksi) {
        loadedData.add(
          Ranking(
            nama: siswa["nama"],
            nisn: siswa["nisn"],
            asalSekolah: siswa["asal_sekolah"],
            nilai: siswa["ranking"],
          ),
        );
      }
      _items = loadedData;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
