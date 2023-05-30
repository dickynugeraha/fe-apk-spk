import 'package:flutter/material.dart';

import './kategori.dart';
import 'bobot_item.dart';

class SubBobot with ChangeNotifier {
  final Kategori kategori;
  final List<BobotItem> bobotItem;

  SubBobot({
    this.kategori,
    this.bobotItem,
  });
}
