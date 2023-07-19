import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/kategori.dart';
import '../../models/sub_bobot.dart';

class PrestasiBobotScreen extends StatefulWidget {
  const PrestasiBobotScreen({Key key}) : super(key: key);

  @override
  State<PrestasiBobotScreen> createState() => _PrestasiBobotScreenState();
}

class _PrestasiBobotScreenState extends State<PrestasiBobotScreen> {
  bool isInit = true;

  List<SubBobotWithKategori> kategoriWithSubBobot = [];
  final List<Map<String, String>> dynamicSlectedId = [];

  @override
  void didChangeDependencies() {
    if (isInit) {
      kategoriWithSubBobot =
          Provider.of<KategoriProvider>(context, listen: false).itemsSubBobot;
      int count = 0;
      for (var kategoriItem in kategoriWithSubBobot) {
        dynamicSlectedId.add({"subBobotId$count": kategoriItem.subBobot[0].id});
        count++;
      }
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: Container(
            height: deviceHeight * 0.3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/profil_bg.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pembobotan".toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Silahkan kalkulasi nilai rata-rata per kategori (0-100). Jika terindikasi melakukan kecurangan dengan menambahkan point nilai, akan langsung kami DISKUALIFIKASI dan dinyatakan TIDAK DITERIMA dalam pelaksanaan PPDB tahun ini.",
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: deviceHeight * 0.5,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            shrinkWrap: true,
            itemCount: kategoriWithSubBobot.length,
            itemBuilder: (context, index) => SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategoriWithSubBobot[index].kategori.nama,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  DropdownButton(
                    value: dynamicSlectedId[index]["subBobotId$index"],
                    items: _dropdownItems(kategoriWithSubBobot[index].subBobot),
                    onChanged: (value) {
                      setState(() {
                        dynamicSlectedId[index]["subBobotId$index"] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Submit"),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  List<DropdownMenuItem<String>> _dropdownItems(List<SubBobot> subBobots) {
    List<DropdownMenuItem<String>> items = [];
    for (var subBobot in subBobots) {
      items.add(
        DropdownMenuItem(
          value: subBobot.id,
          child: Text(subBobot.keterangan),
        ),
      );
    }
    return items;
  }
}
