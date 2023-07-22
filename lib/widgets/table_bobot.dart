import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/admin_bobot/bobot_edit_screen.dart';
import '../providers/bobot.dart';

class BobotTable extends StatelessWidget {
  const BobotTable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bobots = Provider.of<BobotProvider>(context).items;

    return DataTable(
      columnSpacing: 5,
      dataRowHeight: 70,
      columns: const [
        DataColumn(
          label: Expanded(
              child: Text(
            "Kriteria",
            style: TextStyle(fontStyle: FontStyle.italic),
          )),
        ),
        DataColumn(
          label: Expanded(
              child: Text(
            "Bobot",
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
      rows: bobots.map((el) {
        return DataRow(
          cells: [
            DataCell(SizedBox(
              width: 100,
              child: Text(el.kategori.nama),
            )),
            DataCell(Text((el.bobot).toString())),
            DataCell(
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          BobotEditScreen.routeName,
                          arguments: el.id,
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
                                style: TextStyle(fontStyle: FontStyle.italic),
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
                                      await Provider.of<BobotProvider>(context,
                                              listen: false)
                                          .deleteBobot(el.id);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Bobot berhasil terhapus!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Bobot gagal terhapus!"),
                                          duration: Duration(seconds: 2),
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
    );
  }
}
