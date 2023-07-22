import 'dart:io';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/kategori.dart';
import '../../providers/siswa.dart';
import '../../widgets/custom_design.dart';

class PrestasiScreen extends StatefulWidget {
  const PrestasiScreen({Key key}) : super(key: key);

  @override
  State<PrestasiScreen> createState() => _PrestasiScreenState();
}

class _PrestasiScreenState extends State<PrestasiScreen> {
  bool isInit = true;
  bool isLoading = true;
  bool isAvailablePrestasi = false;

  File nilaiSemester;
  File nilaiUas;
  File nilaiUN;
  File prestasiAkademik;
  File prestasiNonAkademik;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<KategoriProvider>(context).fetchKategoriWithSubBobot();
      isAvailablePrestasi =
          Provider.of<SiswaProvider>(context).item.prestasi == null
              ? false
              : true;
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.height;

    Future<void> submitUploadFile() async {
      if (nilaiSemester == null ||
          nilaiUN == null ||
          nilaiUas == null ||
          prestasiAkademik == null ||
          prestasiNonAkademik == null) {
        CustomDesign.customAwesomeDialog(
          context: context,
          dialogSuccess: false,
          isPop: false,
          title: "Gagal",
          desc: "Semua field harus di upload",
        );
        return;
      }
      setState(() {
        isLoading = true;
      });
      // print(nilaiSemester.path);
      // print(nilaiUN.path);
      // print(nilaiUas.path);
      // print(prestasiAkademik.path);
      // print(prestasiNonAkademik.path);
      // return;
      try {
        await Provider.of<SiswaProvider>(context, listen: false)
            .updateFilePrestasiSiswa(
          {
            "nilai_semester": nilaiSemester.path,
            "nilai_un": nilaiUN.path,
            "nilai_uas": nilaiUas.path,
            "prestasi_akademik": prestasiAkademik.path,
            "prestasi_non_akademik": prestasiNonAkademik.path,
          },
        );
        CustomDesign.customAwesomeDialog(
          dialogSuccess: true,
          context: context,
          title: "Berhasil",
          desc: "Data prestasi berhasil di upload",
          isPop: false,
        );
      } on Exception catch (e) {
        CustomDesign.customAwesomeDialog(
          dialogSuccess: false,
          context: context,
          title: "Gagal",
          desc: e.toString(),
          isPop: false,
        );
      } catch (err) {
        CustomDesign.customAwesomeDialog(
          dialogSuccess: false,
          context: context,
          title: "Gagal",
          desc: err.toString(),
          isPop: false,
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    return
        //  isLoading
        //     ? Center(
        //         child: LoadingAnimationWidget.fourRotatingDots(
        //             color: Theme.of(context).primaryColor, size: 50),
        //       )
        //     :
        SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: Container(
              height: deviceSize * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/profil_bg.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "(penting) proses pendataan nilai".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "1. Peserta PPDB wajib menginput data dengan se JUJUR-JUJUR nya.",
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "2. Bagi yang mencoba melakukan kecurangan, kami sebagai panitia tidak segan-segan untuk melakukan DISKUALIFIKASI secara sepihak.",
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    isAvailablePrestasi == null
                        ? "Upload berkas nilai".toUpperCase()
                        : "Data bobot sudah diisi, silahkan tunggu hasil pengumuman hasil seleksi!"
                            .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  if (isAvailablePrestasi == null)
                    Column(
                      children: [
                        inputFile(
                          title: "nilai semester 1 - 5",
                          onPress: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                            );
                            if (result != null) {
                              setState(() {
                                nilaiSemester = File(result.files.single.path);
                              });
                            }
                          },
                        ),
                        inputFile(
                          title: "nilai UN",
                          onPress: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                            );
                            if (result != null) {
                              setState(() {
                                nilaiUN = File(result.files.single.path);
                              });
                            }
                          },
                        ),
                        inputFile(
                          title: "nilai UAS",
                          onPress: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                            );
                            if (result != null) {
                              setState(() {
                                nilaiUas = File(result.files.single.path);
                              });
                            }
                          },
                        ),
                        inputFile(
                          title: "prestasi akademik",
                          onPress: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                            );
                            if (result != null) {
                              setState(() {
                                prestasiAkademik =
                                    File(result.files.single.path);
                              });
                            }
                          },
                        ),
                        inputFile(
                          title: "prestasi Non-Akademik",
                          onPress: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                            );
                            if (result != null) {
                              setState(() {
                                prestasiNonAkademik =
                                    File(result.files.single.path);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: submitUploadFile,
                            child: const Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputFile({
    String title,
    Function onPress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload seluruh rekap $title digabung menjadi satu file pdf, dan gambar terlihat jelas (tidak blur).",
          textAlign: TextAlign.justify,
        ),
        TextButton.icon(
          onPressed: onPress,
          icon: const Icon(Icons.file_open),
          label: Text(toBeginningOfSentenceCase(title)),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
