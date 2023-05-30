import 'dart:ffi';

import 'package:flutter/material.dart';

class ProfilEditScreen extends StatelessWidget {
  static const routeName = "/profil-edit";
  const ProfilEditScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit or create profile"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height:
                      (mediaQuery.size.height - mediaQuery.padding.top) * 0.2,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            "assets/img/dummy_profile.jpeg",
                            width: 100,
                            height: 100,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height:
                      (mediaQuery.size.height - mediaQuery.padding.top) * 0.67,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      child: ListView(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(label: Text("Nama")),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(label: Text("Email")),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(label: Text("Alamat")),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration:
                                InputDecoration(label: Text("No hp orang tua")),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
