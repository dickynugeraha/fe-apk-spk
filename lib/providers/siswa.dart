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
      await Future.delayed(const Duration(seconds: 1));

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
        final prestasi = siswa["prestasi"] != null
            ? Prestasi(
                id: siswa["prestasi"]["id"],
                nisn: siswa["prestasi"]["nisn"],
                nilaiSemester: siswa["prestasi"]["nilai_semester"],
                nilaiUas: siswa["prestasi"]["nilai_uas"],
                nilaiUn: siswa["prestasi"]["nilai_un"],
                prestasiAkademik: siswa["prestasi"]["prestasi_akademik"],
                prestasiNonAkademik: siswa["prestasi"]["prestasi_non_akademik"],
              )
            : null;

        final nilai = siswa["nilai"] != null
            ? Nilai(
                id: siswa["nilai"]["id"],
                nisn: siswa["nilai"]["nisn"],
                parameterId: siswa["nilai"]["parameter_id"],
                namaParameter: siswa["nilai"]["nama_parameter"],
                nilai: int.parse(siswa["nilai"]["nilai"]),
              )
            : null;

        loadedDataSiswa.add(
          Siswa(
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
            prestasi: prestasi,
            nilai: nilai,
          ),
        );
      }
      _items = loadedDataSiswa;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Siswa getByNisn(String nisn) {
    return items.firstWhere((siswa) => siswa.nisn == nisn);
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
        },
      );

      final responseBody = json.decode(response.body);
      final siswa = responseBody["siswa"];

      final prestasi = siswa["prestasi"] != null
          ? Prestasi(
              id: siswa["prestasi"]["id"],
              nisn: siswa["prestasi"]["nisn"],
              nilaiSemester: siswa["prestasi"]["nilai_semester"],
              nilaiUas: siswa["prestasi"]["nilai_uas"],
              nilaiUn: siswa["prestasi"]["nilai_un"],
              prestasiAkademik: siswa["prestasi"]["prestasi_akademik"],
              prestasiNonAkademik: siswa["prestasi"]["prestasi_non_akademik"],
            )
          : null;

      final nilai = siswa["nilai"] == null
          ? null
          : Nilai(
              id: siswa["nilai"]["id"],
              nisn: siswa["nilai"]["nisn"],
              parameterId: siswa["nilai"]["parameter_id"],
              namaParameter: siswa["nilai"]["nama_parameter"],
              nilai: int.parse(siswa["nilai"]["nilai"]),
            );

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
        prestasi: prestasi,
        nilai: nilai,
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

      Siswa newSiswaUpdate = Siswa(
        nisn: newSiswa.nisn,
        asalSekolah: newSiswa.asalSekolah,
        nama: newSiswa.nama,
        alamat: newSiswa.alamat,
        jenisKelamin: newSiswa.jenisKelamin,
        email: newSiswa.email,
        noHpOrtu: newSiswa.noHpOrtu,
        fotoProfil: newSiswa.fotoProfil ?? _item.fotoProfil,
        fotoAkte: newSiswa.fotoAkte ?? _item.fotoAkte,
        fotoIjazah: newSiswa.fotoIjazah ?? _item.fotoIjazah,
        fotoKK: newSiswa.fotoKK ?? _item.fotoKK,
        fotoKtpOrtu: newSiswa.fotoKtpOrtu ?? _item.fotoKtpOrtu,
      );

      _item = newSiswaUpdate;
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

      Siswa newSiswaUpdate = Siswa(
        nisn: item.nisn,
        asalSekolah: item.asalSekolah,
        nama: item.nama,
        alamat: item.alamat,
        jenisKelamin: item.jenisKelamin,
        email: item.email,
        noHpOrtu: item.noHpOrtu,
        fotoProfil: item.fotoProfil,
        fotoAkte: item.fotoAkte,
        fotoIjazah: item.fotoIjazah,
        fotoKK: item.fotoKK,
        fotoKtpOrtu: item.fotoKtpOrtu,
        prestasi: Prestasi(
          id: "UUID",
          nilaiSemester: nilaiSemesterFile.path.split("/").last,
          nilaiUn: nilaiUnFile.path.split("/").last,
          nilaiUas: nilaiUasFile.path.split("/").last,
          prestasiAkademik: prestasiAkademikFile.path.split("/").last,
          prestasiNonAkademik: prestasiNonAkademikFile.path.split("/").last,
        ),
      );

      _item = newSiswaUpdate;
      notifyListeners();

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

  Future<void> storeBobotSiswa(List<Map<String, dynamic>> data) async {
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

      Siswa newSiswaUpdate = Siswa(
        nisn: item.nisn,
        asalSekolah: item.asalSekolah,
        nama: item.nama,
        alamat: item.alamat,
        jenisKelamin: item.jenisKelamin,
        email: item.email,
        noHpOrtu: item.noHpOrtu,
        fotoProfil: item.fotoProfil,
        fotoAkte: item.fotoAkte,
        fotoIjazah: item.fotoIjazah,
        fotoKK: item.fotoKK,
        fotoKtpOrtu: item.fotoKtpOrtu,
        prestasi: item.prestasi != null
            ? Prestasi(
                id: "UUID",
                nilaiSemester: item.prestasi.nilaiSemester,
                nilaiUn: item.prestasi.nilaiUn,
                nilaiUas: item.prestasi.nilaiUas,
                prestasiAkademik: item.prestasi.prestasiAkademik,
                prestasiNonAkademik: item.prestasi.prestasiNonAkademik,
              )
            : null,
        nilai: Nilai(
          id: "UUID",
          namaParameter: "Kategori1",
          nilai: 4,
          nisn: _nisn,
          parameterId: "UUID",
        ),
      );

      _item = newSiswaUpdate;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
