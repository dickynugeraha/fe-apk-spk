import 'package:flutter/material.dart';

import './kategori.dart';

class SubBobotWithKategori with ChangeNotifier {
  final Kategori? kategori;
  final List<SubBobot>? subBobot;

  SubBobotWithKategori({
    this.kategori,
    this.subBobot,
  });
}

class SubBobot {
  final String? id;
  final int? bobot;
  final String? keterangan;
  final String? parameterId;

  SubBobot({
    this.id,
    this.bobot,
    this.keterangan,
    this.parameterId,
  });
}
