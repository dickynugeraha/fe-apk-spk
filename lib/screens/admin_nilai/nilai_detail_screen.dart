import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/siswa.dart';
import '../../widgets/custom_design.dart';

class NilaiDetailScreen extends StatefulWidget {
  static const routeName = "/nilai-siswa";
  const NilaiDetailScreen({Key key}) : super(key: key);

  @override
  State<NilaiDetailScreen> createState() => _NilaiDetailScreenState();
}

class _NilaiDetailScreenState extends State<NilaiDetailScreen> {
  String nisn;
  @override
  void didChangeDependencies() {
    nisn = ModalRoute.of(context).settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final siswa =
        Provider.of<SiswaProvider>(context, listen: false).getByNisn(nisn);

    return CustomDesign.adminHeader(
      action: const SizedBox.shrink(),
      barTitle: siswa.nama,
      isDrawer: false,
      child: nisn.isEmpty
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.white,
                size: 50,
              ),
            )
          : Text(siswa.nama),
    );
  }
}
