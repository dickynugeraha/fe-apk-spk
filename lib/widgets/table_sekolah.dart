import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/helper.dart';
import '../providers/sekolah.dart';

class SekolahTable extends StatelessWidget {
  const SekolahTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sekolah = Provider.of<SekolahProvider>(context).item;

    return Card(
      child: DataTable(
        dataRowHeight: 70,
        columns: const [
          DataColumn(
              label: Text(
            "Title",
            style: TextStyle(fontStyle: FontStyle.italic),
          )),
          DataColumn(
              label: Text(
            "Deskripsi",
            style: TextStyle(fontStyle: FontStyle.italic),
          )),
        ],
        rows: [
          DataRow(cells: [
            const DataCell(Text("Nama sekolah")),
            DataCell(Text(sekolah!.nama!)),
          ]),
          DataRow(cells: [
            const DataCell(Text("Keunggulan")),
            DataCell(SizedBox(
              width: 200,
              child: Text(
                sekolah.deskripsi!,
                overflow: TextOverflow.ellipsis,
              ),
            )),
          ]),
          DataRow(cells: [
            const DataCell(Text("Logo sekolah")),
            DataCell(GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Image.network(
                      "${Helper.domainNoApiUrl}/uploads/foto_logo/${sekolah.fotoLogo}",
                    ),
                  ),
                );
              },
              child: const Text(
                "Lihat",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )),
          ]),
          DataRow(cells: [
            const DataCell(Text("Foto identitas sekolah")),
            DataCell(GestureDetector(
              onTap: () {
                var fotoSekolah = sekolah.fotoIdentitasSekolah!.split("|");

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            "${Helper.domainNoApiUrl}/uploads/foto_identitas_sekolah/${fotoSekolah[0]}",
                          ),
                          const Divider(),
                          Image.network(
                            "${Helper.domainNoApiUrl}/uploads/foto_identitas_sekolah/${fotoSekolah[1]}",
                          ),
                          const Divider(),
                          Image.network(
                            "${Helper.domainNoApiUrl}/uploads/foto_identitas_sekolah/${fotoSekolah[2]}",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                "Lihat",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )),
          ]),
          DataRow(cells: [
            const DataCell(Text("Pendaftaran dibuka")),
            DataCell(
              Text(
                DateFormat(sekolah.pendaftaranDibuka).format(
                  DateTime.now(),
                ),
              ),
            ),
          ]),
          DataRow(cells: [
            const DataCell(Text("Pendaftaran ditutup")),
            DataCell(
              Text(
                DateFormat(sekolah.pendaftaranDitutup).format(
                  DateTime.now(),
                ),
              ),
            ),
          ]),
          DataRow(cells: [
            const DataCell(Text("Pengumuman hasil")),
            DataCell(
              Text(
                DateFormat(sekolah.pengumumanSeleksi).format(
                  DateTime.now(),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
