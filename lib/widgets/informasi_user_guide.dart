import 'package:flutter/material.dart';

class InformasiUserGuide extends StatelessWidget {
  const InformasiUserGuide({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white54,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "Panduan pemakaian aplikasi".toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "1. Peserta PPDB tidak bisa mendaftarkan akun diluar waktu pendaftaran yang disediakan.",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              "2. Peserta yang sudah melakukan registrasi akun, segera melengkapi foto identitas diri dengan melengkapi profil.",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              "3. Data profil bisa diubah dengan mengupload dan atau tidak mengupload foto. Jika ingin mengubah satu foto, maka harus mengupload semua foto.",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              "4. Foto yang sudah di upload terkadang mengalami crash dan tidak terload, tetapi jangan khawatir, foto sudah terdata didalam database.",
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
