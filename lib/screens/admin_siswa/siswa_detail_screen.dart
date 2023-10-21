import 'package:flutter/material.dart';

import '../../widgets/custom_design.dart';
import '../../widgets/table_detail_siswa.dart';

class SiswaDetailScreen extends StatelessWidget {
  SiswaDetailScreen({Key? key}) : super(key: key);
  static const routeName = "/nilai-siswa";

  String nisn = "";

  // @override
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    nisn = args!;

    return CustomDesign.adminHeader(
      action: const SizedBox.shrink(),
      barTitle: "Detail calon siswa",
      isDrawer: false,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: DetailSiswaTable(nisn: nisn),
        ),
      ),
    );
  }
}
