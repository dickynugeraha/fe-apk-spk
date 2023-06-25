import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_design.dart';
import '../../providers/siswa.dart';

class ProfilEditScreen extends StatefulWidget {
  static const routeName = "/profil-edit";
  const ProfilEditScreen({Key key}) : super(key: key);

  @override
  State<ProfilEditScreen> createState() => _ProfilEditScreenState();
}

class _ProfilEditScreenState extends State<ProfilEditScreen> {
  var _genderValue = "L";
  String imageName;

  @override
  Widget build(BuildContext context) {
    final siswa = Provider.of<SiswaProvider>(context, listen: false).item;

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit or create profile"),
        elevation: 0,
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height:
                    (mediaQuery.size.height - mediaQuery.padding.top) * 0.25,
                width: double.infinity,
                child: const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage("assets/img/dummy_profile.jpeg"),
                  ),
                ),
              ),
              SizedBox(
                height:
                    (mediaQuery.size.height - mediaQuery.padding.top) * 0.65,
                child: Form(
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          decoration:
                              CustomDesign.customInputDecoration("Nama"),
                          initialValue: siswa.nama,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          decoration:
                              CustomDesign.customInputDecoration("Email"),
                          initialValue: siswa.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          decoration:
                              CustomDesign.customInputDecoration("Alamat"),
                          maxLines: 3,
                          initialValue: siswa.alamat,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          decoration: CustomDesign.customInputDecoration(
                            "No hp orang tua",
                          ),
                          initialValue: siswa.noHpOrtu,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text(
                              "Jenis kelamin",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 15),
                            DropdownButton(
                              value: _genderValue,
                              items: const [
                                DropdownMenuItem(
                                    value: "L", child: Text("Laki-laki")),
                                DropdownMenuItem(
                                    value: "P", child: Text("Perempuan")),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _genderValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      inputTypeFile(imageName, "Profil"),
                      inputTypeFile(imageName, "Akte Kelahiran"),
                      inputTypeFile(imageName, "Ijazah"),
                      inputTypeFile(imageName, "KK"),
                      inputTypeFile(imageName, "Ktp Ortu"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget inputTypeFile(String inputCheck, String inputTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Text(
            inputCheck ?? "Foto $inputTitle",
            style: TextStyle(overflow: TextOverflow.ellipsis),
          )),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                final file = result.files.first;
                await OpenFilex.open(file.path);

                setState(() {
                  inputCheck = file.name;
                });
              },
              child: Row(children: [
                const Icon(Icons.add_a_photo_rounded),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    inputTitle,
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
