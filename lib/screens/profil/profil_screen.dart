import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/siswa.dart';
import './profil_edit_screen.dart';
import '../../providers/auth.dart';
import '../../screens/auth_screen.dart';
import '../splash_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key key}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _isLoading = true;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<SiswaProvider>(context)
          .fetchAndSetSiswa()
          .then((_) => _isLoading = false);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final siswa = Provider.of<SiswaProvider>(context, listen: false).item;
    final mediaQuery = MediaQuery.of(context);
    return _isLoading
        ? const SplashScreen()
        : Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Container(
                  height: (mediaQuery.size.height) * 0.4,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/profil_bg.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage("assets/img/dummy_profile.jpeg"),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${siswa.nama} (${siswa.nisn})",
                            // "Nama (Nisn)",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                                ProfilEditScreen.routeName,
                                arguments: "uuid"),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        siswa.asalSekolah,
                        // "Sekolah asal",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(AuthScreen.routeName);
                          Provider.of<Auth>(context, listen: false).logout();
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: (mediaQuery.size.height) * 0.5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        profilItem(Icons.numbers, "NISN", siswa.nisn),
                        const Divider(),
                        profilItem(
                          Icons.supervised_user_circle_outlined,
                          "Nama",
                          siswa.nama,
                        ),
                        const Divider(),
                        profilItem(
                          Icons.male,
                          "Jenis Kelamin",
                          siswa.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan',
                        ),
                        const Divider(),
                        profilItem(
                          Icons.email,
                          "Email",
                          siswa.email,
                        ),
                        const Divider(),
                        profilItem(
                          Icons.store_mall_directory_sharp,
                          "Alamat",
                          siswa.alamat,
                        ),
                        const Divider(),
                        profilItem(
                          Icons.phone,
                          "No Hp Orang tua",
                          siswa.noHpOrtu,
                        ),
                        const Divider(),
                      ],
                    ),
                  )),
            ],
          );
  }

  Widget profilItem(IconData icon, String title, String valueText) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 10,
            ),
            Text(title)
          ],
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(left: 35),
          child: Text(valueText),
        ),
      ),
    );
  }
}
