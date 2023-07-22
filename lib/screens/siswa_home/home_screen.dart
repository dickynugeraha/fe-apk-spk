import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:provider/provider.dart";

import '../../providers/sekolah.dart';
import '../../providers/helper.dart';
import '../../providers/kategori.dart';
import '../../widgets/home_informasi_ppdb.dart';
import '../../widgets/home_informasi_user_guide.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<KategoriProvider>(context).fetchKategoriWithSubBobot();

      Provider.of<SekolahProvider>(context)
          .getAndSetSekolahProfile()
          .then((_) => isLoading = false);

      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final sekolah = Provider.of<SekolahProvider>(context, listen: false).item;

    // List<String> fotoCarousel = sekolah.fotoIdentitasSekolah?.split("|");

    // List<Widget> listCarousel() {
    //   List<Widget> items = [];

    //   for (var i = 0; i < fotoCarousel?.length; i++) {
    //     items.add(
    //       carouselItem(
    //         "${Helper.domainNoApiUrl}/uploads/foto_identitas_sekolah/${fotoCarousel[i]}",
    //       ),
    //     );
    //   }
    //   return items;
    // }

    return SafeArea(
      child: isLoading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Theme.of(context).primaryColor, size: 50),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: deviceSize.height * 0.32,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sekolah.nama.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Image.network(
                                  // "http://192.168.56.1:8000/uploads/foto_logo/${sekolah.fotoLogo}",
                                  "${Helper.domainNoApiUrl}/uploads/foto_logo/${sekolah.fotoLogo}",
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          CarouselSlider(
                            items: [
                              carouselItem(
                                "${Helper.domainNoApiUrl}/uploads/foto_identitas_sekolah/${sekolah.fotoIdentitasSekolah.split("|").first}",
                              ),
                              carouselItem(
                                "${Helper.domainNoApiUrl}/uploads/foto_identitas_sekolah/${sekolah.fotoIdentitasSekolah.split("|")[1]}",
                              ),
                              carouselItem(
                                "${Helper.domainNoApiUrl}/uploads/foto_identitas_sekolah/${sekolah.fotoIdentitasSekolah.split("|").last}",
                              ),
                            ],
                            options: CarouselOptions(
                              height: 160,
                              // autoPlay: true,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              enlargeCenterPage: true,
                              aspectRatio: 16 / 9,
                              enableInfiniteScroll: true,
                              viewportFraction: 0.8,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "UNGGULAN",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            // scrollDirection: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              unggulanItem(
                                  Icons.account_balance_sharp, "Bersih"),
                              unggulanItem(
                                  Icons.location_on_sharp, "Strategis"),
                              unggulanItem(
                                  Icons.access_alarm_sharp, "Disiplin"),
                              unggulanItem(Icons.mosque_sharp, "Agamis"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "INFORMASI",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: deviceSize.height * 0.33,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            linkItem(
                              link: "https://www.siap-ppdb.com/",
                              imageUrl:
                                  "https://png.pngtree.com/png-clipart/20230403/original/pngtree-ppdb-logo-design-vector-png-image_9019669.png",
                              title: "PPDB",
                              subtitle:
                                  "Peraturan perundang-undangan yang mengatur PPDB di Indonesia",
                            ),
                            const SizedBox(height: 12),
                            linkItem(
                              link: "https://ppdb.jabarprov.go.id/",
                              imageUrl:
                                  "https://bapenda.jabarprov.go.id/wp-content/uploads/2017/05/Logo-propinsi-jawa-barat.png",
                              title: "PPDB Jawa Barat",
                              subtitle: "Pelaksanaan PPDB wilayah Jawa Barat",
                            ),
                            const SizedBox(height: 12),
                            linkItem(
                              link: "https://ppdb.jakarta.go.id/#/",
                              imageUrl:
                                  "https://th.bing.com/th/id/OIP.7SNuM4tCEvQoa5DSQoOmFgHaE8?w=247&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
                              title: "PPDB DKI Jakarta",
                              subtitle: "Pelaksanaan PPDB wilayah DKI Jakarta",
                            ),
                            const SizedBox(height: 12),
                            linkItem(
                              imageUrl:
                                  "${Helper.domainNoApiUrl}/uploads/foto_logo/${sekolah.fotoLogo}",
                              isPopup: true,
                              title:
                                  "Pendaftaran jalur prestasi di ${sekolah.nama.toUpperCase()}",
                              subtitle:
                                  "Alur dan tahapan pendaftaran jalur prestasi meliputi tata cara dan peraturan.",
                            ),
                            const SizedBox(height: 12),
                            linkItem(
                              imageUrl:
                                  "https://www.pngitem.com/pimgs/m/80-803581_service-manual-icon-17708-large-user-manual-logo.png",
                              isPopup: true,
                              isInfoPPDB: false,
                              title: "Panduan pemakaian aplikasi",
                              subtitle:
                                  "Beberapa catatan penting yang harus diperhatikan user saat menggunakan aplikasi ini.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget linkItem({
    bool isInfoPPDB = true,
    bool isPopup = false,
    String link,
    String imageUrl,
    String title,
    String subtitle,
  }) {
    return InkWell(
      onTap: () async {
        if (isPopup) {
          showModalBottomSheet(
            context: context,
            builder: (context) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: isInfoPPDB
                    ? const InformasiPPDB()
                    : const InformasiUserGuide(),
              ),
            ),
          );
        } else {
          final url = Uri.parse(link);
          await launchUrl(url);
        }
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget carouselItem(String imgUrl) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget unggulanItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200),
            border: Border.all(color: Colors.amber),
          ),
          child: Icon(
            icon,
            color: Colors.amber,
            size: 20,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        )
      ],
    );
  }
}
