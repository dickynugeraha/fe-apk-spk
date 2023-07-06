import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/sub_bobot/sub_bobot_edit_screen.dart';
import '../providers/sub_bobot.dart';

class SubBobotTable extends StatelessWidget {
  const SubBobotTable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subBobot = Provider.of<SubBobotProvider>(context).item;

    return subBobot.bobotItem.isEmpty
        ? const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "DATA BELUM TERISI",
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
              columnSpacing: 5,
              dataRowHeight: 70,
              columns: const [
                DataColumn(
                  label: Expanded(
                      child: Text(
                    "Bobot",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )),
                ),
                DataColumn(
                  label: Expanded(
                      child: Text(
                    "Keterangan",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )),
                ),
                DataColumn(
                  label: Text(
                    "Aksi",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: subBobot.bobotItem.map((el) {
                return DataRow(
                  cells: [
                    DataCell(SizedBox(
                      width: 100,
                      child: Text((el.bobot).toString()),
                    )),
                    DataCell(Text(el.keterangan)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  SubBobotEditScreen.routeName,
                                  arguments: {
                                    "id": el.id,
                                    "kategori": subBobot.kategori.nama,
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Apakah anda yakin?"),
                                      content: const Text(
                                        "Anda akan menghapus data ini dengan permanen",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Tidak"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await Provider.of<
                                                          SubBobotProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteSubBobot(el.id);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Bobot berhasil terhapus!"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            } catch (error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Bobot gagal terhapus!"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            } finally {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: const Text("Ya"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
  }
}
