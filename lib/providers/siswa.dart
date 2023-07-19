// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../models/http_exception.dart';

import '../models/siswa.dart';
import 'helper.dart';

class SiswaProvider with ChangeNotifier {
  Siswa _item;
  List<Siswa> _items;
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

  List<Siswa> get items {
    return [..._items];
  }

  Future<void> fetchAndSetAllSiswa() async {
    final url = Uri.parse("${Helper.domainUrl}/siswa");

    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        },
      );

      final responseBody = json.decode(response.body);
      final allSiswa = responseBody["siswa"];
      if (responseBody["error"] != null) {
        throw HttpException(responseBody["error"]["message"]);
      }
      List<Siswa> loadedDataSiswa = [];

      for (var siswa in allSiswa) {
        loadedDataSiswa.add(Siswa(
          nisn: siswa["nisn"],
          asalSekolah: siswa["asal_sekolah"],
          nama: siswa["nama"],
          alamat: siswa["alamat"],
          jenisKelamin: siswa["jenis_kelamin"],
          email: siswa["email"],
          noHpOrtu: siswa["no_hp_ortu"],
          fotoProfil: siswa["foto_profil"],
          fotoAkte: siswa["foto_akte"],
          fotoIjazah: siswa["foto_ijazah"],
          fotoKK: siswa["foto_kk"],
          fotoKtpOrtu: siswa["foto_ktp_ortu"],
        ));
      }
      _items = loadedDataSiswa;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetSingleSiswa() async {
    final url = Uri.parse("${Helper.domainUrl}/siswa/$_nisn");

    try {
      // _token = null;
      // _nisn = null;
      // final prefs = await SharedPreferences.getInstance();
      // prefs.remove("dataAuth");
      // prefs.clear();

      await Future.delayed(const Duration(seconds: 1));

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
          "Authorization": "Bearer $_token",
          "Accept": "application/json",
          'Connection': 'Keep-Alive',
        },
      );

      final responseBody = json.decode(response.body);
      final siswa = responseBody["siswa"];
      final loadedData = Siswa(
        nisn: siswa["nisn"],
        asalSekolah: siswa["asal_sekolah"],
        nama: siswa["nama"],
        alamat: siswa["alamat"],
        jenisKelamin: siswa["jenis_kelamin"],
        email: siswa["email"],
        noHpOrtu: siswa["no_hp_ortu"],
        fotoProfil: siswa["foto_profil"],
        fotoAkte: siswa["foto_akte"],
        fotoIjazah: siswa["foto_ijazah"],
        fotoKK: siswa["foto_kk"],
        fotoKtpOrtu: siswa["foto_ktp_ortu"],
        prestasi: Prestasi(
          nilaiSemester: siswa["prestasi"]["nilai_semester"],
          nilaiUas: siswa["prestasi"]["nilai_uas"],
          nilaiUn: siswa["prestasi"]["nilai_un"],
          prestasiAkademik: siswa["prestasi"]["prestasi_akademik"],
          prestasiNonAkademik: siswa["prestasi"]["prestasi_non_akademik"],
        ),
      );
      _item = loadedData;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDataSiswa(Siswa newSiswa, bool isUpdateFoto) async {
    final url = Uri.parse("${Helper.domainUrl}/siswa/${newSiswa.nisn}/update");

    try {
      final request = http.MultipartRequest("POST", url);

      request.headers.addAll(
        {
          "Content-Type": "multipart/form-data",
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        },
      );

      request.fields.addAll({
        "nama": newSiswa.nama,
        "alamat": newSiswa.alamat,
        "email": newSiswa.email,
        "no_hp_ortu": newSiswa.noHpOrtu,
        "asal_sekolah": newSiswa.asalSekolah,
        "jenis_kelamin": newSiswa.jenisKelamin,
        "is_update_foto": isUpdateFoto ? "1" : "0",
      });

      if (isUpdateFoto) {
        final profilFile = File(newSiswa.fotoProfil);
        final akteFile = File(newSiswa.fotoAkte);
        final ijazahFile = File(newSiswa.fotoIjazah);
        final kkFile = File(newSiswa.fotoKK);
        final ktpOrtuFile = File(newSiswa.fotoKtpOrtu);

        request.files.add(
          http.MultipartFile(
            "foto_profil",
            profilFile.readAsBytes().asStream(),
            profilFile.lengthSync(),
            filename: profilFile.path.split("/").last,
          ),
        );
        request.files.add(
          http.MultipartFile(
            "foto_akte",
            akteFile.readAsBytes().asStream(),
            akteFile.lengthSync(),
            filename: akteFile.path.split("/").last,
          ),
        );
        request.files.add(
          http.MultipartFile(
            "foto_kk",
            kkFile.readAsBytes().asStream(),
            kkFile.lengthSync(),
            filename: kkFile.path.split("/").last,
          ),
        );
        request.files.add(
          http.MultipartFile(
            "foto_ktp_ortu",
            ktpOrtuFile.readAsBytes().asStream(),
            ktpOrtuFile.lengthSync(),
            filename: ktpOrtuFile.path.split("/").last,
          ),
        );
        request.files.add(
          http.MultipartFile(
            "foto_ijazah",
            ijazahFile.readAsBytes().asStream(),
            ijazahFile.lengthSync(),
            filename: ijazahFile.path.split("/").last,
          ),
        );
      }

      final response = await request.send();
      final responseStr = json.decode(await response.stream.bytesToString());
      if (responseStr["error"] != null) {
        throw HttpException(responseStr["error"]["message"]);
      }

      _item = newSiswa;
      // _items[indexSiswa] = newSiswa;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFilePrestasiSiswa(Map<String, String> filePath) async {
    final url = Uri.parse("${Helper.domainUrl}/prestasi/$_nisn/update");

    File nilaiSemesterFile = File(filePath["nilai_semester"]);
    File nilaiUnFile = File(filePath["nilai_un"]);
    File nilaiUasFile = File(filePath["nilai_uas"]);
    File prestasiAkademikFile = File(filePath["prestasi_akademik"]);
    File prestasiNonAkademikFile = File(filePath["prestasi_non_akademik"]);

    try {
      final request = http.MultipartRequest("POST", url);

      request.headers.addAll(
        {
          "Content-Type": "multipart/form-data",
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        },
      );

      request.files.add(
        http.MultipartFile(
          "nilai_semester",
          nilaiSemesterFile.readAsBytes().asStream(),
          nilaiSemesterFile.lengthSync(),
          filename: nilaiSemesterFile.path.split("/").last,
        ),
      );

      request.files.add(
        http.MultipartFile(
          "nilai_un",
          nilaiUnFile.readAsBytes().asStream(),
          nilaiUnFile.lengthSync(),
          filename: nilaiUnFile.path.split("/").last,
        ),
      );

      request.files.add(
        http.MultipartFile(
          "nilai_uas",
          nilaiUasFile.readAsBytes().asStream(),
          nilaiUasFile.lengthSync(),
          filename: nilaiUasFile.path.split("/").last,
        ),
      );

      request.files.add(
        http.MultipartFile(
          "prestasi_akademik",
          prestasiAkademikFile.readAsBytes().asStream(),
          prestasiAkademikFile.lengthSync(),
          filename: prestasiAkademikFile.path.split("/").last,
        ),
      );

      request.files.add(
        http.MultipartFile(
          "prestasi_non_akademik",
          prestasiNonAkademikFile.readAsBytes().asStream(),
          prestasiNonAkademikFile.lengthSync(),
          filename: prestasiNonAkademikFile.path.split("/").last,
        ),
      );

      final response = await request.send();
      final responseStr = json.decode(await response.stream.bytesToString());

      if (response.statusCode != 200) {
        throw HttpException("Error");
      }
      if (responseStr["error"] != null) {
        throw HttpException(responseStr["error"]["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
