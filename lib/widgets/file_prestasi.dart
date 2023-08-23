import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/helper.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class FilePrestasi extends StatelessWidget {
  final String nilaiSemester;
  final String nilaiUn;
  final String nilaiUas;
  final String prestasiAkademik;
  final String prestasiNonAkademik;

  const FilePrestasi({
    Key key,
    this.nilaiSemester,
    this.nilaiUas,
    this.nilaiUn,
    this.prestasiAkademik,
    this.prestasiNonAkademik,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        "${Helper.domainNoApiUrl}/uploads/file_prestasi/nilai_semester/$nilaiSemester");
    // print(nilaiUas);
    // print(nilaiUn);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        fileItem(
          "File nilai semester",
          "${Helper.domainNoApiUrl}/uploads/file_prestasi/nilai_semester/$nilaiSemester",
        ),
        const SizedBox(height: 10),
        fileItem(
          "File nilai UAS",
          "${Helper.domainNoApiUrl}/uploads/file_prestasi/nilai_uas/$nilaiUas",
        ),
        const SizedBox(height: 10),
        fileItem(
          "File nilai UN",
          "${Helper.domainNoApiUrl}/uploads/file_prestasi/nilai_un/$nilaiUn",
        ),
        const SizedBox(height: 10),
        fileItem(
          "File prestasi akademik",
          "${Helper.domainNoApiUrl}/uploads/file_prestasi/prestasi_akademik/$prestasiAkademik",
        ),
        const SizedBox(height: 10),
        fileItem(
          "File prestasi non akademik",
          "${Helper.domainNoApiUrl}/uploads/file_prestasi/prestasi_non_akademik/$prestasiNonAkademik",
        ),
      ],
    );
  }

  Widget fileItem(String title, String url) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap:
              //  () {
              //   OpenFilex.open(url);
              // },
              () async {
            await launchUrl(
              Uri.parse(url),
            );
          },
          child: const Text(
            "Lihat",
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}