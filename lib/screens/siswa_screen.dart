import 'package:flutter/material.dart';

class StudentsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _myData = List.generate(
    300,
    (index) => {
      "id": index,
      "nama": "nama$index",
      "sekolah": "smp $index depok",
    },
  );

  StudentsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/bg2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Data Siswa"),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(15),
            child: DataTable(
              sortColumnIndex: 0,
              sortAscending: true,
              columns: const [
                DataColumn(
                    label: Expanded(
                  child: Text(
                    "Nama",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    "Sekolah",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text(
                    "Action",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text("Kale")),
                    DataCell(Text("SMPN 17 Depok")),
                    DataCell(
                      Row(
                        children: const [
                          IconButton(onPressed: null, icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: null,
                              icon: Icon(Icons.details_rounded)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
