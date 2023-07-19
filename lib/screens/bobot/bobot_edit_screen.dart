import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/kategori.dart';
import '../../providers/bobot.dart';
import '../../models/bobot.dart';
import '../../models/kategori.dart';

class BobotEditScreen extends StatefulWidget {
  static const routeName = "/bobot-edit";
  const BobotEditScreen({Key key}) : super(key: key);

  @override
  State<BobotEditScreen> createState() => _BobotEditScreenState();
}

class _BobotEditScreenState extends State<BobotEditScreen> {
  var _isLoading = false;
  var _isInit = true;
  var _editingBobot = Bobot(
    id: null,
    bobot: 0.0,
    parameterId: "",
    kategori: Kategori(id: "", nama: "", sifat: ""),
  );
  var _initValue = {
    "id": "",
    "bobot": "",
    "parameterId": "",
    "kategori": {
      "id": "",
      "nama": "",
      "sifat": "",
    },
  };
  final _form = GlobalKey<FormState>();
  List<Kategori> kategories;
  String kategoriId_selected;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final bobotId = ModalRoute.of(context).settings.arguments as String;
      kategories = Provider.of<KategoriProvider>(context, listen: false).items;

      if (bobotId != null) {
        _editingBobot = Provider.of<BobotProvider>(context, listen: false)
            .findById(bobotId);
        _initValue = {
          "id": _editingBobot.id,
          "bobot": _editingBobot.bobot,
          "parameterId": _editingBobot.parameterId,
          "kategori": {
            "id": _editingBobot.kategori.id,
            "nama": _editingBobot.kategori.nama,
            "sifat": _editingBobot.kategori.sifat,
          }
        };
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  List<DropdownMenuItem<String>> get kategoriesDropdown {
    List<DropdownMenuItem<String>> items = [];
    for (var el in kategories) {
      items.add(DropdownMenuItem(value: el.id, child: Text(el.nama)));
    }
    return items;
  }

  Future<void> _formSave() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editingBobot.id != null) {
      await Provider.of<BobotProvider>(context, listen: false)
          .editBobot(_editingBobot);
    } else {
      try {
        await Provider.of<BobotProvider>(context, listen: false).addBobot(
          kategoriId_selected,
          _editingBobot,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 2),
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
          title: Text("${_editingBobot.id == null ? "Tambah" : "Ubah"} Bobot"),
          actions: [
            IconButton(
              onPressed: _formSave,
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).splashColor),
              )
            : Container(
                padding: const EdgeInsets.all(15),
                height: 180,
                child: Card(
                  child: Form(
                      key: _form,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: ListView(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Kategori :",
                                  style: TextStyle(fontSize: 15),
                                ),
                                _editingBobot.id != null
                                    ? Text(
                                        _editingBobot.kategori.nama,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      )
                                    : DropdownButton(
                                        value: kategoriId_selected,
                                        items: kategoriesDropdown,
                                        onChanged: (value) {
                                          final kategoriSelected =
                                              Provider.of<KategoriProvider>(
                                            context,
                                            listen: false,
                                          ).getById(value);

                                          setState(
                                            () {
                                              kategoriId_selected = value;
                                              _editingBobot = Bobot(
                                                id: _editingBobot.id,
                                                parameterId:
                                                    _editingBobot.parameterId,
                                                bobot: _editingBobot.bobot,
                                                kategori: Kategori(
                                                  id: _editingBobot.kategori.id,
                                                  nama: kategoriSelected.nama,
                                                  sifat: _editingBobot
                                                      .kategori.sifat,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              initialValue: _initValue["bobot"].toString(),
                              decoration:
                                  const InputDecoration(labelText: "Bobot"),
                              onSaved: (newValue) {
                                _editingBobot = Bobot(
                                  id: _editingBobot.id,
                                  parameterId: _editingBobot.parameterId,
                                  bobot: double.parse(newValue),
                                  kategori: Kategori(
                                    id: _editingBobot.kategori.id,
                                    nama: _editingBobot.kategori.nama,
                                    sifat: _editingBobot.kategori.sifat,
                                  ),
                                );
                              },
                              keyboardType: TextInputType.number,
                              validator: ((value) {
                                if (value.isEmpty) {
                                  return "Silahkan input nama kategori";
                                }
                                return null;
                              }),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
      ),
    );
  }
}
