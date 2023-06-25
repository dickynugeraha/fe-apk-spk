import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/bobot_item.dart';
import '../models/kategori.dart';
import '../models/sub_bobot.dart';
import '../providers/helper.dart';

class SubBobotProvider with ChangeNotifier {
  String _token;
  String _username;
  SubBobot _item;
  SubBobot get item {
    return _item;
  }

  void update(String tokenAsign, String usernameAsign) {
    _token = tokenAsign;
    _username = usernameAsign;
    notifyListeners();
  }

  String get token {
    return _token;
  }

  String get username {
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
      if (extractData != null) {
        final loadedSubBobot = SubBobot(
          kategori: Kategori(
            id: extractData["id"],
            nama: extractData["nama"],
            sifat: extractData["sifat"],
          ),
          bobotItem: (extractData["sub_bobot"] as List<dynamic>)
              .map(
                (el) => BobotItem(
                  id: el["id"],
                  bobot: el["bobot"],
                  keterangan: el["keterangan"],
                  parameterId: el["parameter_id"],
                ),
              )
              .toList(),
        );
        _item = loadedSubBobot;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  BobotItem getById(String id) {
    return item.bobotItem.firstWhere((el) => el.id == id);
  }

  Future<void> addSubBobot(BobotItem newSubBobot) async {
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
      item.bobotItem.add(BobotItem(
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

  Future<void> editSubBobot(BobotItem newSubBobot) async {
    final url = Uri.parse("${Helper.domainUrl}/sub-bobot/${newSubBobot.id}");
    final indexSubBobot =
        item.bobotItem.indexWhere((element) => element.id == newSubBobot.id);

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

      item.bobotItem[indexSubBobot] = newSubBobot;
      notifyListeners();
    }
  }

  Future<void> deleteSubBobot(String id) async {
    final url = Uri.parse("${Helper.domainUrl}/sub-bobot/$id");
    final indexSubBobot = item.bobotItem.indexWhere((el) => el.id == id);
    var existingSubBobot = item.bobotItem[indexSubBobot];
    item.bobotItem.removeAt(indexSubBobot);
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
      item.bobotItem.insert(indexSubBobot, existingSubBobot);
      notifyListeners();
      throw HttpException(errorResponse);
    }
    existingSubBobot = null;
  }
}
