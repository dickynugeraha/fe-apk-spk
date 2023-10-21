import 'package:flutter/material.dart';
import '../providers/helper.dart';
import 'package:flutter/services.dart';

class FilePrestasi extends StatelessWidget {
  final String? nilaiSemester;
  final String? nilaiUn;
  final String? nilaiUas;
  final String? prestasiAkademik;
  final String? prestasiNonAkademik;

  const FilePrestasi({
    Key? key,
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
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: url));
            },
            child: const Text(
              "Copy url",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
