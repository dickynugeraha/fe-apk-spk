import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../models/siswa.dart';
import '../../widgets/custom_design.dart';
import '../../providers/siswa.dart';
import '../../models/http_exception.dart';

class ProfilEditScreen extends StatefulWidget {
  static const routeName = "/profil-edit";
  const ProfilEditScreen({Key key}) : super(key: key);

  @override
  State<ProfilEditScreen> createState() => _ProfilEditScreenState();
}

class _ProfilEditScreenState extends State<ProfilEditScreen> {
  bool isInit = true;
  bool isUpdateFoto = false;
  bool isLoading = false;

  var _genderValue = "L";
  File fotoProfil;
  File fotoAkte;
  File fotoIjazah;
  File fotoKK;
  File fotoKtpOrtu;

  TextEditingController nisnController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noHpOrtuController = TextEditingController();
  TextEditingController asalSekolahController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (isInit) {
      final siswa = Provider.of<SiswaProvider>(context, listen: false).item;
      nisnController.text = siswa.nisn;
      namaController.text = siswa.nama;
      alamatController.text = siswa.alamat;
      emailController.text = siswa.email;
      asalSekolahController.text = siswa.asalSekolah;
      noHpOrtuController.text = siswa.noHpOrtu;
      _genderValue = siswa.jenisKelamin;
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();
    // final mediaQuery = MediaQuery.of(context);

    Future<void> submitEdit() async {
      if (!form.currentState.validate()) {
        return;
      }
      form.currentState.save();
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<SiswaProvider>(context, listen: false)
            .updateDataSiswa(
          isUpdateFoto
              ? Siswa(
                  nisn: nisnController.text,
                  asalSekolah: asalSekolahController.text,
                  nama: namaController.text,
                  alamat: alamatController.text,
                  jenisKelamin: _genderValue,
                  email: emailController.text,
                  noHpOrtu: noHpOrtuController.text,
                  fotoAkte: fotoAkte.path,
                  fotoIjazah: fotoIjazah.path,
                  fotoKK: fotoKK.path,
                  fotoKtpOrtu: fotoKtpOrtu.path,
                  fotoProfil: fotoProfil.path,
                )
              : Siswa(
                  nisn: nisnController.text,
                  asalSekolah: asalSekolahController.text,
                  nama: namaController.text,
                  alamat: alamatController.text,
                  jenisKelamin: _genderValue,
                  email: emailController.text,
                  noHpOrtu: noHpOrtuController.text,
                ),
          isUpdateFoto,
        );
        CustomDesign.customAwesomeDialog(
          title: "Berhasil",
          desc: "Data siswa berhasil di ubah!",
          context: context,
          dialogSuccess: true,
        );
      } on HttpException catch (errMessage) {
        CustomDesign.customAwesomeDialog(
          title: "Gagal",
          desc: "Data siswa gagal di ubah, ${errMessage.toString()}",
          context: context,
          dialogSuccess: false,
          isPop: false,
        );
      } catch (e) {
        CustomDesign.customAwesomeDialog(
          title: "Gagal",
          desc: "Terjadi kesalahan, ${e.toString()}",
          context: context,
          dialogSuccess: false,
          isPop: false,
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit profil"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: submitEdit,
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: form,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  decoration: CustomDesign.customInputDecoration("Nisn"),
                  controller: nisnController,
                  readOnly: true,
                  onSaved: (newValue) {
                    nisnController.text = newValue;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Jenis kelamin"),
                    const SizedBox(width: 15),
                    DropdownButton(
                      value: _genderValue,
                      items: const [
                        DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                        DropdownMenuItem(value: "P", child: Text("Perempuan")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _genderValue = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: CustomDesign.customInputDecoration("Nama"),
                  controller: namaController,
                  onSaved: (newValue) {
                    namaController.text = newValue;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: CustomDesign.customInputDecoration("Email"),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) {
                    emailController.text = newValue;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: CustomDesign.customInputDecoration("Alamat"),
                  maxLines: 3,
                  controller: alamatController,
                  onSaved: (newValue) {
                    alamatController.text = newValue;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: CustomDesign.customInputDecoration(
                    "No hp orang tua",
                  ),
                  controller: noHpOrtuController,
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    noHpOrtuController.text = newValue;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: CustomDesign.customInputDecoration(
                    "Asal sekolah",
                  ),
                  controller: asalSekolahController,
                  onSaved: (newValue) {
                    asalSekolahController.text = newValue;
                  },
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text("Update data foto"),
                  value: isUpdateFoto,
                  onChanged: (value) {
                    setState(() {
                      isUpdateFoto = value;
                    });
                  },
                ),
                if (isUpdateFoto)
                  Column(
                    children: [
                      inputTypeFile(
                        // path: fotoAkte.path,
                        title: "profil",
                        onPressed: () async {
                          final pickedFile =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                          );
                          setState(() {
                            if (pickedFile != null) {
                              fotoProfil = File(pickedFile.files.single.path);
                            }
                          });
                        },
                      ),
                      inputTypeFile(
                        // path: fotoAkte.path,
                        title: "akte",
                        onPressed: () async {
                          final pickedFile =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                          );
                          setState(() {
                            if (pickedFile != null) {
                              fotoAkte = File(pickedFile.files.single.path);
                            }
                          });
                        },
                      ),
                      inputTypeFile(
                        title: "ijazah",
                        // path: fotoIjazah.path,
                        onPressed: () async {
                          final pickedFile =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                          );
                          setState(() {
                            if (pickedFile != null) {
                              fotoIjazah = File(pickedFile.files.single.path);
                            }
                          });
                        },
                      ),
                      inputTypeFile(
                        title: "kk",
                        // path: fotoKK.path,
                        onPressed: () async {
                          final pickedFile =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                          );
                          setState(() {
                            if (pickedFile != null) {
                              fotoKK = File(pickedFile.files.single.path);
                            }
                          });
                        },
                      ),
                      inputTypeFile(
                        title: "ktp ortu",
                        // path: fotoKK.path,
                        onPressed: () async {
                          final pickedFile =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                          );
                          setState(() {
                            if (pickedFile != null) {
                              fotoKtpOrtu = File(pickedFile.files.single.path);
                            }
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputTypeFile({
    // String path,
    String title,
    Function onPressed,
  }) {
    return Row(children: [
      TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_a_photo_rounded),
        label: Text("Foto $title"),
      ),
    ]);
  }
}
