// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ppdb_prestasi/widgets/file_prestasi.dart';
import 'package:provider/provider.dart';

import '../../providers/kategori.dart';
import '../../providers/siswa.dart';
import '../../widgets/custom_design.dart';

class PrestasiScreen extends StatefulWidget {
  const PrestasiScreen({Key? key}) : super(key: key);

  @override
  State<PrestasiScreen> createState() => _PrestasiScreenState();
}

class _PrestasiScreenState extends State<PrestasiScreen> {
  bool isInit = true;
  bool isLoading = true;

  File? nilaiSemester;
  File? nilaiUas;
  File? nilaiUN;
  File? prestasiAkademik;
  File? prestasiNonAkademik;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<KategoriProvider>(context).fetchKategoriWithSubBobot();

      Provider.of<SiswaProvider>(context)
          .fetchAndSetSingleSiswa()
          .then((_) => isLoading = false);

      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.height;

    final siswa = Provider.of<SiswaProvider>(context).item;

    Future<void> submitUploadFile() async {
      if (nilaiUN == null) {
        CustomDesign.customAwesomeDialog(
          context: context,
          dialogSuccess: false,
          isPop: false,
          title: "Gagal",
          desc: "Semua file harus di upload",
        );
        return;
      }
      setState(() {
        isLoading = true;
      });

      try {
        await Provider.of<SiswaProvider>(context, listen: false)
            .updateFilePrestasiSiswa(
          {
            "nilai_semester": nilaiSemester!.path,
            "nilai_un": nilaiUN!.path,
            "nilai_uas": nilaiUas!.path,
            "prestasi_akademik": prestasiAkademik!.path,
            "prestasi_non_akademik": prestasiNonAkademik!.path,
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

    return isLoading
        ? Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          )
        : SingleChildScrollView(
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
                            "Upload file nilai dan prestasi".toUpperCase(),
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
                          const SizedBox(height: 10),
                          const Text(
                            "3. Siswa hanya diberi kesempatan sekali upload file, jadi pastikan file yang diisi sudah benar.",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        FilePrestasi(
                          nilaiSemester: siswa!.prestasi!.nilaiSemester,
                          nilaiUas: siswa.prestasi!.nilaiUas,
                          nilaiUn: siswa.prestasi!.nilaiUn,
                          prestasiAkademik: siswa.prestasi!.prestasiAkademik,
                          prestasiNonAkademik:
                              siswa.prestasi!.prestasiNonAkademik,
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
    required String title,
    Function()? onPress,
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
          label: Text(title),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
