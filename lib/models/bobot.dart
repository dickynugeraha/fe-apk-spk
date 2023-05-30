import 'package:flutter/material.dart';
import './kategori.dart';

class Bobot {
  final String id;
  final double bobot;
  final String parameterId;
  final Kategori kategori;

  Bobot({
    @required this.id,
    @required this.bobot,
    @required this.parameterId,
    @required this.kategori,
  });
}
