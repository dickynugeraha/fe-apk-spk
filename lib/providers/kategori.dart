import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './helper.dart';
import '../models/kategori.dart';

class KategoriProvider with ChangeNotifier {
  String tokenValue;
  String username;

  List<Kategori> _items = [];
  List<Kategori> get items {
    return [..._items];
  }

  KategoriProvider(this.tokenValue, this.username, this._items);

  Future<void> addKategori(Kategori kategori) async {
    final url = Uri.parse('${Helper.domainUrl}/parameter');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(
          {
            'nama': kategori.nama,
            'sifat': kategori.sifat,
          },
        ),
      );

      final newKategori = Kategori(
        id: json.decode(response.body)["parameter_id"],
        nama: kategori.nama,
        sifat: kategori.sifat,
      );
      _items.add(newKategori);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetKategories() async {
    final url = Uri.parse('${Helper.domainUrl}/parameter');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $tokenValue"
        },
      );
      final kategories = json.decode(response.body)["data"] as List<dynamic>;
      final List<Kategori> loadedKategories = [];

      for (var kategori in kategories) {
        loadedKategories.add(Kategori(
          id: kategori["id"],
          nama: kategori["nama"],
          sifat: kategori["sifat"],
        ));
      }
      _items = loadedKategories;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Kategori getById(String kategoriId) {
    return _items.firstWhere((kategori) => kategori.id == kategoriId);
  }

  Future<void> editKategori(Kategori newKategori) async {
    final indexKat =
        _items.indexWhere((kategori) => kategori.id == newKategori.id);
    final url = Uri.parse('${Helper.domainUrl}/parameter/${newKategori.id}');
    if (indexKat >= 0) {
      await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          "Authorization": "Bearer $tokenValue"
        },
        body: json.encode(
          {"nama": newKategori.nama, "sifat": newKategori.sifat},
        ),
      );
      _items[indexKat] = newKategori;
      notifyListeners();
    }
  }

  Future<void> deleteKategori(String kategoriId) async {
    final indexKategori =
        _items.indexWhere((kategori) => kategori.id == kategoriId);
    var choosenKategori = _items[indexKategori];
    _items.removeAt(indexKategori);
    notifyListeners();
    final url = Uri.parse('${Helper.domainUrl}/parameter/$kategoriId');
    final response = await http.delete(url, headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      "Authorization": "Bearer $tokenValue"
    });
    final responseData = json.decode(response.body);

    if (responseData["error"] != null) {
      _items.insert(indexKategori, choosenKategori);
      notifyListeners();
      throw HttpException(responseData["error"]);
    }
    choosenKategori = null;
  }
}
