import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/kategori.dart';
import '../models/sub_bobot.dart';
import '../providers/helper.dart';

class SubBobotProvider with ChangeNotifier {
  String? _token;
  String? _username;
  SubBobotWithKategori? _item;
  SubBobotWithKategori? get item {
    return _item;
  }

  void update(String? tokenAsign, String usernameAsign) {
    _token = tokenAsign;
    _username = usernameAsign;
    notifyListeners();
  }

  String? get token {
    return _token;
  }

  String? get username {
    return _username;
  }

  Future<void> fetchAndSetSubBobot(String kategoriId) async {
    final url =
        Uri.parse("${Helper.domainUrl}/parameter/$kategoriId/sub-bobot");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token",
        },
      );
      final extractData =
          json.decode(response.body)["data"][0] as Map<String, dynamic>;
      final loadedSubBobot = SubBobotWithKategori(
        kategori: Kategori(
          id: extractData["id"],
          nama: extractData["nama"],
          sifat: extractData["sifat"],
        ),
        subBobot: (extractData["sub_bobot"] as List<dynamic>)
            .map(
              (el) => SubBobot(
                id: el["id"],
                bobot: int.parse(el["bobot"]),
                keterangan: el["keterangan"],
                parameterId: el["parameter_id"],
              ),
            )
            .toList(),
      );
      _item = loadedSubBobot;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  SubBobot getById(String id) {
    return item!.subBobot!.firstWhere((el) => el.id == id);
  }

  Future<void> addSubBobot(SubBobot newSubBobot) async {
    final url = Uri.parse("${Helper.domainUrl}/sub-bobot");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(
          {
            "parameter_id": newSubBobot.parameterId,
            "bobot": newSubBobot.bobot,
            "keterangan": newSubBobot.keterangan,
          },
        ),
      );
      final subBobotId = json.decode(response.body)["sub_bobot_id"] as String;
      _item!.subBobot!.add(SubBobot(
        id: subBobotId,
        bobot: newSubBobot.bobot,
        keterangan: newSubBobot.keterangan,
        parameterId: newSubBobot.parameterId,
      ));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editSubBobot(SubBobot newSubBobot) async {
    final url = Uri.parse("${Helper.domainUrl}/sub-bobot/${newSubBobot.id}");
    final indexSubBobot =
        item!.subBobot!.indexWhere((element) => element.id == newSubBobot.id);

    if (indexSubBobot >= 0) {
      await http.put(
        url,
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(
          {
            "bobot": newSubBobot.bobot,
            "keterangan": newSubBobot.keterangan,
          },
        ),
      );

      item!.subBobot![indexSubBobot] = newSubBobot;
      notifyListeners();
    }
  }

  Future<void> deleteSubBobot(String id) async {
    final url = Uri.parse("${Helper.domainUrl}/sub-bobot/$id");
    final indexSubBobot = item!.subBobot!.indexWhere((el) => el.id == id);
    SubBobot? existingSubBobot = item!.subBobot![indexSubBobot];
    item!.subBobot!.removeAt(indexSubBobot);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final errorResponse = json.decode(response.body)["error"];
    if (errorResponse != null) {
      item!.subBobot!.insert(indexSubBobot, existingSubBobot);
      notifyListeners();
      throw HttpException(errorResponse);
    }
    existingSubBobot = null;
  }
}
