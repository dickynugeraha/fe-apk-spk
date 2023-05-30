import 'package:flutter/material.dart';
import 'package:ppdb_prestasi/models/bobot_item.dart';
import 'package:ppdb_prestasi/providers/kategori.dart';
import '../../models/kategori.dart';
import '../../providers/sub_bobot.dart';
import 'package:provider/provider.dart';

class SubBobotEditScreen extends StatefulWidget {
  static const routeName = "/sub-bobot-edit.dart";
  const SubBobotEditScreen({Key key}) : super(key: key);

  @override
  State<SubBobotEditScreen> createState() => _SubBobotEditScreenState();
}

class _SubBobotEditScreenState extends State<SubBobotEditScreen> {
  String kategoriId_selected;
  var _isInit = true;
  var _isLoading = false;
  var _editingSubBobot = BobotItem(
    id: null,
    bobot: 0,
    keterangan: "",
    parameterId: "",
  );
  var _initValue = {
    "id": "",
    "nama": "",
    "bobot": 0,
    "keterangan": "",
    "parameterId": "",
  };
  final _form = GlobalKey<FormState>();
  List<Kategori> kategories;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      kategories = Provider.of<KategoriProvider>(context, listen: false).items;

      if (args != null) {
        _editingSubBobot =
            Provider.of<SubBobotProvider>(context).getById(args['id']);
        _initValue = {
          "id": _editingSubBobot.id,
          "nama": args["kategori"],
          "bobot": _editingSubBobot.bobot,
          "keterangan": _editingSubBobot.keterangan,
          "parameterId": _editingSubBobot.parameterId,
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
    try {
      if (_editingSubBobot.id != null) {
        // edit
        await Provider.of<SubBobotProvider>(context, listen: false)
            .editSubBobot(_editingSubBobot);
      } else {
        // create
        await Provider.of<SubBobotProvider>(context, listen: false)
            .addSubBobot(_editingSubBobot);
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Berhasil menambah/mengedit data !"),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      print(e.toString());
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(e.toString()),
      //   duration: const Duration(seconds: 2),
      // ));
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
          title: Text(
              "${_editingSubBobot.id == null ? "Tambah" : "Ubah"} Sub Bobot"),
          actions: [
            IconButton(
              onPressed: _formSave,
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          height: 250,
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
                          const SizedBox(width: 20),
                          _editingSubBobot.id != null
                              ? Text(
                                  _initValue["nama"],
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                )
                              : DropdownButton(
                                  value: kategoriId_selected,
                                  items: kategoriesDropdown,
                                  onChanged: (newValue) {
                                    setState(() {
                                      kategoriId_selected = newValue;
                                      _editingSubBobot = BobotItem(
                                        id: _editingSubBobot.id,
                                        keterangan: _editingSubBobot.keterangan,
                                        bobot: _editingSubBobot.bobot,
                                        parameterId: newValue,
                                      );
                                    });
                                  },
                                ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: "Keterangan"),
                        initialValue: _initValue["keterangan"],
                        onSaved: (newValue) {
                          _editingSubBobot = BobotItem(
                            id: _editingSubBobot.id,
                            keterangan: newValue,
                            bobot: _editingSubBobot.bobot,
                            parameterId: _editingSubBobot.parameterId,
                          );
                        },
                        validator: ((value) {
                          if (value.isEmpty) {
                            return "Silahkan input keterangan";
                          }
                          return null;
                        }),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Bobot"),
                        initialValue: _initValue["bobot"].toString(),
                        onSaved: (newValue) {
                          _editingSubBobot = BobotItem(
                            id: _editingSubBobot.id,
                            keterangan: _editingSubBobot.keterangan,
                            bobot: int.parse(newValue),
                            parameterId: _editingSubBobot.parameterId,
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
