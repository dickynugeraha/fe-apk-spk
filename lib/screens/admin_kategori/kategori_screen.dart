import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/kategori.dart';
import '../../widgets/admin_drawer.dart';
import './kategori_edit_screen.dart';
import '../../widgets/table_kategori.dart';

class KategoriScreen extends StatefulWidget {
  static const routeName = "/kategori";

  const KategoriScreen({Key? key}) : super(key: key);

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  var _isInit = true;
  var _isLoading = true;
  bool? _isKategoriPage;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isKategoriPage = ModalRoute.of(context)?.settings.arguments as bool;
      _isKategoriPage ??= true;
      Provider.of<KategoriProvider>(context)
          .fetchAndSetKategories()
          .then((_) => _isLoading = false);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(_isKategoriPage! ? "Kategori" : "Sub Bobot"),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        drawer: const AdminDrawer(),
        body: _isLoading
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 50,
                ),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: const EdgeInsets.all(15),
                    child: KategoriTable(_isKategoriPage!),
                  ),
                ),
              ),
        floatingActionButton: _isKategoriPage!
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(KategoriEditScreen.routeName);
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
