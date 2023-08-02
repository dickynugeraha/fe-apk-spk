import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/siswa.dart';
import '../providers/helper.dart';

class FotoIdentitasSiswa extends StatelessWidget {
  final String nisn;
  final bool adminPage;
  const FotoIdentitasSiswa({
    Key key,
    this.nisn,
    this.adminPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var siswa;

    if (adminPage) {
      siswa =
          Provider.of<SiswaProvider>(context, listen: false).getByNisn(nisn);
    } else {
      siswa = Provider.of<SiswaProvider>(context, listen: false).item;
    }

    return Scaffold(
      appBar: AppBar(title: const SizedBox.shrink()),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: siswa.asalSekolah == null
            ? const Center(
                child: Text("Foto identitas belum di upload"),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fotoItem(
                      "profil",
                      "${Helper.domainNoApiUrl}/uploads/foto_profil/${siswa.fotoProfil}",
                    ),
                    fotoItem(
                      "ijazah",
                      "${Helper.domainNoApiUrl}/uploads/foto_ijazah/${siswa.fotoIjazah}",
                    ),
                    fotoItem(
                      "akte kelahiran",
                      "${Helper.domainNoApiUrl}/uploads/foto_akte/${siswa.fotoAkte}",
                    ),
                    fotoItem(
                      "ktp orang tua",
                      "${Helper.domainNoApiUrl}/uploads/foto_ktp_ortu/${siswa.fotoKtpOrtu}",
                    ),
                    fotoItem(
                      "kk",
                      "${Helper.domainNoApiUrl}/uploads/foto_kk/${siswa.fotoKK}",
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget fotoItem(String title, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Foto $title",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Image.network(
          url,
          width: double.infinity,
          height: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
