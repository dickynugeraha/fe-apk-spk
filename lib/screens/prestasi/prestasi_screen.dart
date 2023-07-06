import 'package:flutter/material.dart';

class PrestasiScreen extends StatelessWidget {
  const PrestasiScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: Container(
              height: deviceSize * 0.37,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/profil_bg.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "(penting) proses pendataan nilai".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "1. Peserta PPDB wajib menginput data dengan se JUJUR-JUJUR nya.",
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "2. Bagi yang mencoba melakukan kecurangan, kami sebagai panitia tidak segan-segan untuk melakukan DISKUALIFIKASI secara sepihak.",
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400], width: 0.5),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white54,
            ),
            child: Text(
                "Upload seluruh rekap nilai semester 1 - 5 digabung dalam bentuk pdf"),
          ),
        ],
      ),
    );
  }
}
