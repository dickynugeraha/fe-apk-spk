import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_design.dart';
import '../../providers/siswa.dart';
import '../../widgets/table_nilai.dart';

class NilaiScreen extends StatefulWidget {
  static const routeName = "/nilai";
  const NilaiScreen({Key key}) : super(key: key);

  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  bool isLoading = true;
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<SiswaProvider>(context).fetchAndSetAllSiswa().then(
            (value) => isLoading = false,
          );

      isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDesign.adminHeader(
      barTitle: "Nilai",
      isDrawer: true,
      action: const SizedBox.shrink(),
      child: isLoading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.white,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                child: const NilaiTable(),
              ),
            ),
    );
  }
}
