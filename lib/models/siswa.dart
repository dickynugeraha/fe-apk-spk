import 'package:flutter/material.dart';

class Siswa {
  final String nisn;
  final String asalSekolah;
  final String nama;
  final String alamat;
  final String jenisKelamin;
  final String email;
  final String noHpOrtu;
  final String fotoProfil;
  final String fotoAkte;
  final String fotoIjazah;
  final String fotoKK;
  final String fotoKtpOrtu;

  Siswa({
    @required this.nisn,
    @required this.asalSekolah,
    @required this.nama,
    @required this.alamat,
    @required this.jenisKelamin,
    @required this.email,
    @required this.noHpOrtu,
    this.fotoProfil,
    this.fotoAkte,
    this.fotoIjazah,
    this.fotoKK,
    this.fotoKtpOrtu,
  });
}
