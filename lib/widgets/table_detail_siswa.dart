import 'package:flutter/material.dart';
import 'package:ppdb_prestasi/widgets/foto_identitas_siswa.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/siswa.dart';
import '../providers/helper.dart';

class DetailSiswaTable extends StatelessWidget {
  final String nisn;
  const DetailSiswaTable({Key key, this.nisn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final siswa =
        Provider.of<SiswaProvider>(context, listen: false).getByNisn(nisn);

    return Card(
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text(
              "Title",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              "Deskripsi",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: [
          siswaItem("Nama", siswa.nama),
          siswaItem("Nisn", siswa.nisn),
          siswaItem("Email", siswa.email),
          siswaItem("Asal sekolah", siswa.asalSekolah),
          siswaItem("Alamat", siswa.alamat),
          siswaItem("Jenis Kelamin", siswa.jenisKelamin),
          siswaItem("No hp orang tua", siswa.noHpOrtu),
          DataRow(
            cells: [
              const DataCell(Text("Foto identitas")),
              DataCell(
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FotoIdentitasSiswa(
                        nisn: siswa.nisn,
                      ),
                    ));
                  },
                  child: const Text(
                    "Lihat",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              )
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text("File nilai & prestasi")),
              DataCell(
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: siswa.prestasi == null
                            ? const Text(
                                "File belum di upload",
                                textAlign: TextAlign.center,
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  fileItem(
                                    "File nilai semester",
                                    "${Helper.domainNoApiUrl}/uploads/file_prestasi/nilai_semester/${siswa.prestasi.nilaiSemester}",
                                  ),
                                  const SizedBox(height: 10),
                                  fileItem(
                                    "File nilai UAS",
                                    "${Helper.domainNoApiUrl}/uploads/file_prestasi/nilai_uas/${siswa.prestasi.nilaiUas}",
                                  ),
                                  const SizedBox(height: 10),
                                  fileItem(
                                    "File nilai UN",
                                    "${Helper.domainNoApiUrl}/uploads/file_prestasi/nilai_un/${siswa.prestasi.nilaiUn}",
                                  ),
                                  const SizedBox(height: 10),
                                  fileItem(
                                    "File prestasi akademik",
                                    "${Helper.domainNoApiUrl}/uploads/file_prestasi/prestasi_akademik/${siswa.prestasi.prestasiAkademik}",
                                  ),
                                  const SizedBox(height: 10),
                                  fileItem(
                                    "File prestasi non akademik",
                                    "${Helper.domainNoApiUrl}/uploads/file_prestasi/prestasi_non_akademik/${siswa.prestasi.prestasiNonAkademik}",
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                  child: const Text(
                    "Lihat",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  DataRow siswaItem(String title, String description) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            description,
            overflow: TextOverflow.ellipsis,
          ),
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
