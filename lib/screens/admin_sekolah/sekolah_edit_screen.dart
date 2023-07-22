import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../widgets/custom_design.dart';
import '../../providers/sekolah.dart';
import '../../models/sekolah.dart';

class SekolahEditScreen extends StatefulWidget {
  static const routeName = "/sekolah-edit";

  const SekolahEditScreen({Key key}) : super(key: key);

  @override
  State<SekolahEditScreen> createState() => _SekolahEditScreenState();
}

class _SekolahEditScreenState extends State<SekolahEditScreen> {
  var sekolahId = "";
  bool isLoading = false;
  bool isInit = true;
  bool isUpdateFoto = false;
  final form = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final pendaftaranBukaController = TextEditingController();
  final pendaftaranTutupController = TextEditingController();
  final pengumumanSeleksiController = TextEditingController();
  File fotoLogo;
  File fotoIdentitas1;
  File fotoIdentitas2;
  File fotoIdentitas3;
  File fotoAlurPendaftaran;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final sekolah = Provider.of<SekolahProvider>(context, listen: false).item;
      namaController.text = sekolah.nama;
      deskripsiController.text = sekolah.deskripsi;
      pendaftaranBukaController.text = sekolah.pendaftaranDibuka;
      pendaftaranTutupController.text = sekolah.pendaftaranDitutup;
      pengumumanSeleksiController.text = sekolah.pengumumanSeleksi;
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submitForm() async {
      if (!form.currentState.validate()) {
        return;
      }
      form.currentState.save();
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<SekolahProvider>(context, listen: false)
            .updateSekolah(
          isUpdateFoto
              ? Sekolah(
                  deskripsi: deskripsiController.text,
                  nama: namaController.text,
                  pendaftaranDibuka: pendaftaranBukaController.text,
                  pendaftaranDitutup: pendaftaranTutupController.text,
                  pengumumanSeleksi: pengumumanSeleksiController.text,
                  fotoIdentitasSekolah:
                      "${fotoIdentitas1.path}|${fotoIdentitas2.path}|${fotoIdentitas3.path}",
                  fotoLogo: fotoLogo.path,
                  fotoAlurPendaftaran: fotoAlurPendaftaran.path,
                )
              : Sekolah(
                  deskripsi: deskripsiController.text,
                  nama: namaController.text,
                  pendaftaranDibuka: pendaftaranBukaController.text,
                  pendaftaranDitutup: pendaftaranTutupController.text,
                  pengumumanSeleksi: pengumumanSeleksiController.text,
                ),
          isUpdateFoto,
        );
        CustomDesign.customAwesomeDialog(
          context: context,
          title: "Berhasil",
          desc: "Berhasil edit profil sekolah",
          dialogSuccess: true,
        );
      } on HttpException catch (err) {
        CustomDesign.customAwesomeDialog(
          context: context,
          title: "Gagal",
          desc: err.toString(),
          isPop: false,
          dialogSuccess: false,
        );
      } catch (e) {
        CustomDesign.customAwesomeDialog(
          context: context,
          title: "Gagal",
          desc: e.toString(),
          isPop: false,
          dialogSuccess: false,
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    return CustomDesign.adminHeader(
      action: IconButton(
        onPressed: submitForm,
        icon: const Icon(Icons.save),
      ),
      isDrawer: false,
      barTitle: "Edit profil sekolah",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: form,
                child: Column(
                  children: [
                    TextFormField(
                      decoration:
                          CustomDesign.customInputDecoration("Nama sekolah"),
                      controller: namaController,
                      onSaved: (newValue) {
                        setState(() {
                          namaController.text = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration:
                          CustomDesign.customInputDecoration("Keunggulan"),
                      controller: deskripsiController,
                      maxLines: 4,
                      onSaved: (newValue) {
                        setState(() {
                          deskripsiController.text = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text("Update foto"),
                      value: isUpdateFoto,
                      onChanged: (value) {
                        setState(() {
                          isUpdateFoto = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    if (isUpdateFoto)
                      Column(
                        children: [
                          inputTypeFile(
                            title: "logo",
                            onPressed: () async {
                              final pickedFile =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                              );
                              setState(() {
                                fotoLogo = File(pickedFile.files.single.path);
                              });
                            },
                          ),
                          inputTypeFile(
                            title: "alur pendaftaran",
                            onPressed: () async {
                              final pickedFile =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                              );
                              setState(() {
                                fotoAlurPendaftaran =
                                    File(pickedFile.files.single.path);
                              });
                            },
                          ),
                          inputTypeFile(
                            title: "identitas 1",
                            onPressed: () async {
                              final pickedFile =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                              );
                              setState(() {
                                fotoIdentitas1 =
                                    File(pickedFile.files.single.path);
                              });
                            },
                          ),
                          inputTypeFile(
                            title: "identitas 2",
                            onPressed: () async {
                              final pickedFile =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                              );
                              setState(() {
                                fotoIdentitas2 =
                                    File(pickedFile.files.single.path);
                              });
                            },
                          ),
                          inputTypeFile(
                            title: "identitas 3",
                            onPressed: () async {
                              final pickedFile =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                              );
                              setState(() {
                                fotoIdentitas3 =
                                    File(pickedFile.files.single.path);
                              });
                            },
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: CustomDesign.customInputDecoration(
                          "Pendaftaran dibuka"),
                      readOnly: true,
                      controller: pendaftaranBukaController,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );

                        setState(() {
                          pendaftaranBukaController.text =
                              DateFormat("dd-MM-yyyy").format(date);
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: CustomDesign.customInputDecoration(
                          "Pendaftaran ditutup"),
                      readOnly: true,
                      controller: pendaftaranTutupController,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );

                        setState(() {
                          pendaftaranTutupController.text =
                              DateFormat("dd-MM-yyyy").format(date);
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: CustomDesign.customInputDecoration(
                          "Pengumuman seleksi"),
                      readOnly: true,
                      controller: pengumumanSeleksiController,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );

                        setState(() {
                          pengumumanSeleksiController.text =
                              DateFormat("dd-MM-yyyy").format(date);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> inputDate(BuildContext context) async {
  //   showBottomSheet(
  //     context: context,
  //     builder: (context) => Container(
  //       padding: const EdgeInsets.all(20),
  //       child: ,
  //     ),
  //   );
  // }

  Widget inputTypeFile({
    // String path,
    String title,
    Function onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(
          "Foto $title",
          // path != null ? path : "Foto $title",
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        )),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: onPressed,
            child: Row(children: [
              const Icon(Icons.add_a_photo_rounded),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }
}
