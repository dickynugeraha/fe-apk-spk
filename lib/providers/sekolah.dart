import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import '../models/sekolah.dart';
import './helper.dart';

class SekolahProvider with ChangeNotifier {
  String _token;
  Sekolah _item;

  Sekolah get item {
    return _item;
  }

  void update(String tokenRequired) {
    _token = tokenRequired;

    notifyListeners();
  }

  Future<void> getAndSetSekolahProfile() async {
    final url = Uri.parse("${Helper.domainUrl}/sekolah");

    try {
      await Future.delayed(const Duration(seconds: 1));

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
          "Accept": "applicatiion/json",
          "Authorization": "Bearer $_token",
        },
      );
      final sekolah = json.decode(response.body)["sekolah"];
      Sekolah loadedData = Sekolah(
        nama: sekolah["nama"],
        deskripsi: sekolah["deskripsi"],
        fotoLogo: sekolah["foto_logo"],
        fotoIdentitasSekolah: sekolah["foto_identitas"],
        fotoAlurPendaftaran: sekolah["foto_alur_pendaftaran"],
        pendaftaranDibuka: sekolah["pendaftaran_buka"],
        pendaftaranDitutup: sekolah["pendaftaran_tutup"],
        pengumumanSeleksi: sekolah["pengumuman_seleksi"],
      );
      _item = loadedData;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSekolah(Sekolah newSekolah, bool isUpdateFoto) async {
    final url = Uri.parse("${Helper.domainUrl}/sekolah/update");

    try {
      final request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Content-Type": "application/json;charset=UTF-8",
        "Accept": "applicatiion/json",
        "Authorization": "Bearer $_token",
      });

      request.fields.addAll({
        "nama": newSekolah.nama,
        "deskripsi": newSekolah.deskripsi,
        "pendaftaran_buka": newSekolah.pendaftaranDibuka,
        "pendaftaran_tutup": newSekolah.pendaftaranDitutup,
        "pengumuman_seleksi": newSekolah.pengumumanSeleksi,
        "is_update_foto": isUpdateFoto ? "1" : "0",
      });

      if (isUpdateFoto) {
        List<String> getPathFotoIdentitas =
            newSekolah.fotoIdentitasSekolah.split("|");

        File fotoLogo = File(newSekolah.fotoLogo);
        File fotoAlurPendaftaran = File(newSekolah.fotoAlurPendaftaran);
        File fotoIdentitas1 = File(getPathFotoIdentitas[0]);
        File fotoIdentitas2 = File(getPathFotoIdentitas[1]);
        File fotoIdentitas3 = File(getPathFotoIdentitas[2]);

        request.files.add(http.MultipartFile(
          "foto_logo",
          fotoLogo.readAsBytes().asStream(),
          fotoLogo.lengthSync(),
          filename: fotoLogo.path.split("/").last,
        ));

        request.files.add(http.MultipartFile(
          "foto_alur_pendaftaran",
          fotoAlurPendaftaran.readAsBytes().asStream(),
          fotoAlurPendaftaran.lengthSync(),
          filename: fotoAlurPendaftaran.path.split("/").last,
        ));

        request.files.add(http.MultipartFile(
          "foto_identitas_1",
          fotoIdentitas1.readAsBytes().asStream(),
          fotoIdentitas1.lengthSync(),
          filename: fotoIdentitas1.path.split("/").last,
        ));

        request.files.add(http.MultipartFile(
          "foto_identitas_2",
          fotoIdentitas2.readAsBytes().asStream(),
          fotoIdentitas2.lengthSync(),
          filename: fotoIdentitas2.path.split("/").last,
        ));

        request.files.add(http.MultipartFile(
          "foto_identitas_3",
          fotoIdentitas3.readAsBytes().asStream(),
          fotoIdentitas3.lengthSync(),
          filename: fotoIdentitas3.path.split("/").last,
        ));
      }

      final response = await request.send();
      final responseStr = json.decode(await response.stream.bytesToString());

      final updatedSekolah = Sekolah(
        nama: newSekolah.nama,
        deskripsi: newSekolah.deskripsi,
        pendaftaranDibuka: newSekolah.pendaftaranDibuka,
        pendaftaranDitutup: newSekolah.pendaftaranDitutup,
        pengumumanSeleksi: newSekolah.pengumumanSeleksi,
        fotoAlurPendaftaran:
            newSekolah.fotoAlurPendaftaran ?? _item.fotoAlurPendaftaran,
        fotoIdentitasSekolah:
            newSekolah.fotoIdentitasSekolah ?? _item.fotoIdentitasSekolah,
        fotoLogo: newSekolah.fotoLogo ?? _item.fotoLogo,
      );

      _item = updatedSekolah;
      notifyListeners();

      if (response.statusCode != 200) {
        throw HttpException(responseStr["error"]["message"]);
      }
      if (responseStr["error"] != null) {
        throw HttpException(responseStr["error"]["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
