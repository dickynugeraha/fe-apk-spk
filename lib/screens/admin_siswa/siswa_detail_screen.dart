import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../widgets/custom_design.dart';
import '../../widgets/table_detail_siswa.dart';

class SiswaDetailScreen extends StatefulWidget {
  static const routeName = "/nilai-siswa";
  const SiswaDetailScreen({Key key}) : super(key: key);

  @override
  State<SiswaDetailScreen> createState() => _SiswaDetailScreenState();
}

class _SiswaDetailScreenState extends State<SiswaDetailScreen> {
  // String nisn;
  // @override
  // void didChangeDependencies() {
  //   nisn = ModalRoute.of(context).settings.arguments as String;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final nisn = ModalRoute.of(context).settings.arguments as String;

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
