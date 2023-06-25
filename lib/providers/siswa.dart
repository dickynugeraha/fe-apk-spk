// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../models/siswa.dart';
import 'helper.dart';

class SiswaProvider with ChangeNotifier {
  Siswa _item;
  String _nisn;
  String _token;

  void update(String tokenAsign, String nisnAsign) {
    _token = tokenAsign;
    _nisn = nisnAsign;
    notifyListeners();
  }

  Siswa get item {
    return _item;
  }

  Future<void> fetchAndSetSiswa() async {
    final url = Uri.parse("${Helper.domainUrl}/siswa/$_nisn");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        },
      );

      final responseBody = json.decode(response.body);
      final dataSiswa = responseBody["siswa"];
      final loadedData = Siswa(
        nisn: dataSiswa["nisn"],
        asalSekolah: dataSiswa["asal_sekolah"],
        nama: dataSiswa["nama"],
        alamat: dataSiswa["alamat"],
        jenisKelamin: dataSiswa["jenis_kelamin"],
        email: dataSiswa["email"],
        noHpOrtu: dataSiswa["no_hp_ortu"],
      );
      _item = loadedData;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
