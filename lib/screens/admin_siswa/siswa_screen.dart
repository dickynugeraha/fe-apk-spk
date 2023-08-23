import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_design.dart';
import '../../providers/siswa.dart';
import '../../widgets/table_siswa.dart';

class SiswaScreen extends StatefulWidget {
  static const routeName = "/siswa";
  const SiswaScreen({Key key}) : super(key: key);

  @override
  State<SiswaScreen> createState() => _SiswaScreenState();
}

class _SiswaScreenState extends State<SiswaScreen> {
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
      barTitle: "Calon siswa",
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
                child: const SiswaTable(),
              ),
            ),
    );
  }
}
