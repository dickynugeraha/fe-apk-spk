import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import './sub_bobot_edit_screen.dart';
import '../../providers/sub_bobot.dart';
import '../../widgets/table_sub_bobot.dart';

class SubBobotScreen extends StatefulWidget {
  static const routeName = "/sub-bobot";

  const SubBobotScreen({Key? key}) : super(key: key);

  @override
  State<SubBobotScreen> createState() => _SubBobotScreenState();
}

class _SubBobotScreenState extends State<SubBobotScreen> {
  var _isInit = true;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final kategoriId = ModalRoute.of(context)?.settings.arguments as String?;
      if (kategoriId != null) {
        Provider.of<SubBobotProvider>(context)
            .fetchAndSetSubBobot(kategoriId!)
            .then((_) => _isLoading = false);
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final subBobot = Provider.of<SubBobotProvider>(context).item;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/bg1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(_isLoading ? "" : subBobot!.kategori!.nama!),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: _isLoading
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 50,
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  width: double.infinity,
                  child: const SubBobotTable(),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SubBobotEditScreen.routeName);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
