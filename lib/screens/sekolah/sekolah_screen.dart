import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/sekolah.dart';
import '../../widgets/custom_design.dart';
import "./sekolah_edit_screen.dart";

class SekolahScreen extends StatefulWidget {
  static const routeName = "/sekolah";
  const SekolahScreen({Key key}) : super(key: key);

  @override
  State<SekolahScreen> createState() => _SekolahScreenState();
}

class _SekolahScreenState extends State<SekolahScreen> {
  bool isLoading = true;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<SekolahProvider>(context)
          .getAndSetSekolahProfile()
          .then((value) => isLoading = false);
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sekolah = Provider.of<SekolahProvider>(context, listen: false).item;

    return CustomDesign.adminHeader(
      barTitle: "Profil sekolah",
      action: IconButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(SekolahEditScreen.routeName),
        icon: const Icon(Icons.edit),
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(12),
                width: double.infinity,
                child: Card(
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
                        DataCell(Text(sekolah.nama)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Keunggulan")),
                        DataCell(SizedBox(
                          width: 200,
                          child: Text(
                            sekolah.deskripsi,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Logo sekolah")),
                        DataCell(GestureDetector(
                          onTap: () {},
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
                          onTap: () {},
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
                        const DataCell(Text("Foto alur pendaftaran")),
                        DataCell(GestureDetector(
                          onTap: () {},
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
                ),
              ),
            ),
    );
  }
}
