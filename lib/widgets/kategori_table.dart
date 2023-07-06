import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/kategori/kategori_edit_screen.dart';
import '../screens/sub_bobot/sub_bobot_screen.dart';
import '../providers/kategori.dart';

class KategoriTable extends StatelessWidget {
  final bool isKategoriPage;
  const KategoriTable(this.isKategoriPage, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kategories = Provider.of<KategoriProvider>(context).items;

    return DataTable(
      columnSpacing: 5,
      dataRowHeight: 70,
      columns: const [
        DataColumn(
          label: Expanded(
            child: Text(
              "Nama",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              "Aksi",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
      rows: kategories.map((kategori) {
        return DataRow(
          cells: [
            DataCell(Text(kategori.nama)),
            DataCell(
              Row(
                children: [
                  if (isKategoriPage)
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          KategoriEditScreen.routeName,
                          arguments: kategori.id,
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  if (isKategoriPage)
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Hapus kategori"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Batal",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await Provider.of<KategoriProvider>(
                                              context,
                                              listen: false)
                                          .deleteKategori(kategori.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Kategori terhapus!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(error.toString()),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    } finally {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text("Ya"),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  if (!isKategoriPage)
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            SubBobotScreen.routeName,
                            arguments: kategori.id);
                      },
                      icon: const Icon(Icons.align_horizontal_left_rounded),
                    )
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
