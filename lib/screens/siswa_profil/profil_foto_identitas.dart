import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/siswa.dart';
import '../../providers/helper.dart';

class ProfilFotoIdentitas extends StatelessWidget {
  const ProfilFotoIdentitas({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final siswa = Provider.of<SiswaProvider>(context, listen: false).item;

    print(siswa.fotoProfil);

    return Scaffold(
      appBar: AppBar(title: const Text("Foto identitas")),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
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
        const SizedBox(height: 12),
        Image.network(
          url,
          width: double.infinity,
          height: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
