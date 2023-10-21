import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/nilai.dart';
import '../../widgets/custom_design.dart';
import '../../widgets/table_nilai.dart';

class NilaiScreen extends StatefulWidget {
  static const routeName = "/nilai-ranking";
  const NilaiScreen({Key? key}) : super(key: key);

  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  bool isLoading = true;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<NilaiProvider>(context).getHasilPerhitungan().then(
            (_) => isLoading = false,
          );

      isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDesign.adminHeader(
      isDrawer: true,
      barTitle: "Nilai dan ranking",
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
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                child: const NilaiTable(),
              ),
            ),
    );
  }
}
