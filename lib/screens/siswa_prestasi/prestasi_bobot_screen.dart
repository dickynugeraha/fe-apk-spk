import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/kategori.dart';
import '../../models/sub_bobot.dart';
import '../../providers/nilai.dart';
import '../../providers/siswa.dart';
import '../../widgets/custom_design.dart';

class PrestasiBobotScreen extends StatefulWidget {
  const PrestasiBobotScreen({Key key}) : super(key: key);

  @override
  State<PrestasiBobotScreen> createState() => _PrestasiBobotScreenState();
}

class _PrestasiBobotScreenState extends State<PrestasiBobotScreen> {
  bool isInit = true;
  bool isLoading = false;

  List<SubBobotWithKategori> kategoriWithSubBobot = [];
  final List<Map<String, dynamic>> dynamicSlectedId = [];

  @override
  void didChangeDependencies() {
    if (isInit) {
      kategoriWithSubBobot =
          Provider.of<KategoriProvider>(context, listen: false).itemsSubBobot;
      int count = 0;
      for (var kategoriItem in kategoriWithSubBobot) {
        dynamicSlectedId.add({
          "kategoriId$count": kategoriItem.kategori.id,
          "kategoriNama$count": kategoriItem.kategori.nama,
          "subBobotId$count": kategoriItem.subBobot[0].id,
          "nilai$count": kategoriItem.subBobot[0].bobot,
        });
        count++;
      }
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final siswa = Provider.of<SiswaProvider>(context, listen: false).item;

    Future<void> submitBobot() async {
      // print(dynamicSlectedId);
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<NilaiProvider>(context, listen: false)
            .storeNilai(dynamicSlectedId);
        CustomDesign.customAwesomeDialog(
          context: context,
          title: "Success",
          isPop: false,
          desc: "Berhasil menambah nilai",
          dialogSuccess: true,
        );
      } catch (e) {
        CustomDesign.customAwesomeDialog(
          context: context,
          title: "Error",
          isPop: false,
          desc: e.toString(),
          dialogSuccess: false,
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    return isLoading
        ? Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          )
        : Column(
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
              const SizedBox(height: 20),
              Text(
                siswa.nilai == null
                    ? "Isi bobot diri".toUpperCase()
                    : "Data bobot sudah diisi, silahkan tunggu hasil pengumuman hasil seleksi!"
                        .toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (siswa.nilai == null)
                SizedBox(
                  height: deviceHeight * 0.5,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 8,
                    ),
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
                            items: _dropdownItems(
                                kategoriWithSubBobot[index].subBobot),
                            onChanged: (value) {
                              setState(() {
                                dynamicSlectedId[index]["subBobotId$index"] =
                                    value;
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
              if (siswa.nilai == null)
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
                    onPressed: submitBobot,
                    child: const Text("Submit"),
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
