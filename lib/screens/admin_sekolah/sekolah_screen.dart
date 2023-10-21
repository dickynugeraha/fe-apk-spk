import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/sekolah.dart';
import '../../widgets/custom_design.dart';
import '../../widgets/table_sekolah.dart';
import "./sekolah_edit_screen.dart";

class SekolahScreen extends StatefulWidget {
  static const routeName = "/sekolah";
  const SekolahScreen({Key? key}) : super(key: key);

  @override
  State<SekolahScreen> createState() => _SekolahScreenState();
}

class _SekolahScreenState extends State<SekolahScreen> {
  bool isLoading = true;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<SekolahProvider>(context)
          .getAndSetSekolahProfile()
          .then((value) => isLoading = false);
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDesign.adminHeader(
      barTitle: "Profil sekolah",
      action: IconButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(SekolahEditScreen.routeName),
        icon: const Icon(Icons.edit),
      ),
      child: isLoading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.white,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(12),
                width: double.infinity,
                child: const SekolahTable(),
              ),
            ),
    );
  }
}
