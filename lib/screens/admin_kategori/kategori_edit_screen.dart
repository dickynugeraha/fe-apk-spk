// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../providers/kategori.dart';
import '../../models/kategori.dart';

class KategoriEditScreen extends StatefulWidget {
  static const routeName = "/kategori-edit";

  const KategoriEditScreen({Key? key}) : super(key: key);

  @override
  State<KategoriEditScreen> createState() => _KategoriEditScreenState();
}

class _KategoriEditScreenState extends State<KategoriEditScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _choosenSifat = "min";
  var _editingKategori = Kategori(id: null, nama: "", sifat: "");
  var _initValues = {"nama": "", "sifat": ""};
  final _form = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final kategoriId = ModalRoute.of(context)?.settings.arguments as String?;
      if (kategoriId != null) {
        _editingKategori =
            Provider.of<KategoriProvider>(context).getById(kategoriId!);
        _initValues = {
          "nama": _editingKategori.nama!,
        };
        _choosenSifat = _editingKategori.sifat!;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _formSave() async {
    final formValid = _form.currentState!.validate();
    if (!formValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editingKategori.id != null) {
      await Provider.of<KategoriProvider>(context, listen: false)
          .editKategori(_editingKategori);
    } else {
      try {
        await Provider.of<KategoriProvider>(context, listen: false)
            .addKategori(_editingKategori);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error Occured!"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/img/bg1.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(_editingKategori.id == null
              ? "Tambah Kategori"
              : "Ubah Kategori"),
          actions: [
            IconButton(
              onPressed: _formSave,
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 50,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(15),
                height: 200,
                child: Card(
                  child: Form(
                    key: _form,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListView(
                        children: [
                          TextFormField(
                            initialValue: _initValues["nama"],
                            decoration: const InputDecoration(
                                labelText: "Nama kategori"),
                            onSaved: (newValue) {
                              _editingKategori = Kategori(
                                id: _editingKategori.id,
                                nama: newValue!,
                                sifat: _choosenSifat,
                              );
                            },
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return "Silahkan input nama kategori";
                              }
                              return null;
                            }),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Text(
                                "Sifat",
                                style: TextStyle(fontSize: 13),
                              ),
                              const SizedBox(width: 20),
                              DropdownButton(
                                value: _choosenSifat,
                                items: const [
                                  DropdownMenuItem(
                                      value: "max", child: Text("Maksimum")),
                                  DropdownMenuItem(
                                      value: "min", child: Text("Minimum")),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _choosenSifat = value!;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
