import 'package:flutter/material.dart';
import 'profil_edit_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: Container(
            height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/profil_bg.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ProfilEditScreen.routeName,
                            arguments: "uuid",
                          );
                        },
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/img/dummy_profile.jpeg",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Nama Lengkap Siswa (NISN)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Asal Sekolah Siswa",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
            height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  profilItem(Icons.numbers, "NISN", "1445"),
                  const Divider(),
                  profilItem(Icons.supervised_user_circle_outlined, "Nama",
                      "John Doe"),
                  const Divider(),
                  profilItem(Icons.male, "Jenis Kelamin", "Pria"),
                  const Divider(),
                  profilItem(Icons.email, "Email", "example@gmail.com"),
                  const Divider(),
                  profilItem(Icons.store_mall_directory_sharp, "Alamat",
                      "jl. jalan yuk"),
                  const Divider(),
                  profilItem(Icons.phone, "No Hp Orang tua", "0888"),
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
