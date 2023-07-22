import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/siswa.dart';
import '../screens/admin_nilai/nilai_detail_screen.dart';

class NilaiTable extends StatelessWidget {
  const NilaiTable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final siswa = Provider.of<SiswaProvider>(context, listen: false).items;

    return siswa.isEmpty
        ? const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "BELUM ADA SISWA YANG MENDAFTAR",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 15,
              ),
            ),
          )
        : Card(
            child: DataTable(
              columns: const [
                DataColumn(
                  label: Expanded(
                    child: Text(
                      "Nama",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      "Detail",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: siswa.map(
                (siswa) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(siswa.nama),
                      ),
                      DataCell(
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              NilaiDetailScreen.routeName,
                              arguments: siswa.nisn,
                            );
                          },
                          icon: const Icon(Icons.align_horizontal_left_rounded),
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          );
  }
}
