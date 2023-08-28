import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './helper.dart';
import '../models/bobot.dart';
import '../models/kategori.dart';

class BobotProvider with ChangeNotifier {
  String _token;
  String _username;

  List<Bobot> _items = [];
  List<Bobot> get items {
    return [..._items];
  }

  String get token {
    return _token;
  }

  String get username {
    return _username;
  }

  BobotProvider(this._token, this._username, this._items);

  Bobot findById(String bobotId) {
    return _items.firstWhere((bobot) => bobot.id == bobotId);
  }

  Future<void> addBobot(String parameterId, Bobot valueBobot) async {
    final url = Uri.parse("${Helper.domainUrl}/bobot");
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
            "parameter_id": parameterId,
            "bobot": valueBobot.bobot,
          },
        ),
      );
      final newBobot = Bobot(
        id: json.decode(response.body)["bobot_id"],
        bobot: valueBobot.bobot,
        parameterId: parameterId,
        kategori: Kategori(
          id: parameterId,
          nama: valueBobot.kategori.nama,
          sifat: valueBobot.kategori.sifat,
        ),
      );
      _items.add(newBobot);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editBobot(Bobot newBobot) async {
    final bobotIndex = _items.indexWhere((el) => el.id == newBobot.id);
    final url = Uri.parse("${Helper.domainUrl}/bobot/${newBobot.id}");
    if (bobotIndex >= 0) {
      await http.put(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "bobot": newBobot.bobot,
        }),
      );
      _items[bobotIndex] = newBobot;
      notifyListeners();
    }
  }

  Future<void> deleteBobot(String bobotId) async {
    final bobotIndex = _items.indexWhere((element) => element.id == bobotId);
    var choosenBobot = _items[bobotIndex];
    _items.removeAt(bobotIndex);
    notifyListeners();
    final url = Uri.parse("${Helper.domainUrl}/bobot/$bobotId");
    final response = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });
    final responseData = json.decode(response.body);
    if (responseData["error"] != null) {
      _items.insert(bobotIndex, choosenBobot);
      notifyListeners();
      throw HttpException(responseData["error"]);
    }
    choosenBobot = null;
  }

  Future<void> fetchAndSetBobot() async {
    final url = Uri.parse('${Helper.domainUrl}/bobot');
    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      List<Bobot> bobotLoaded = [];
      final bobotList = json.decode(response.body)["data"] as List<dynamic>;
      for (var el in bobotList) {
        bobotLoaded.add(Bobot(
          id: el["id"],
          bobot: double.parse(el["bobot"]),
          parameterId: el["parameter_id"],
          kategori: Kategori(
            id: el["parameter"]["id"],
            nama: el["parameter"]["nama"],
            sifat: el["parameter"]["sifat"],
          ),
        ));
        _items = bobotLoaded;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
