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
  final Prestasi prestasi;

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
    this.prestasi,
  });
}

class Prestasi {
  final String nilaiSemester;
  final String nilaiUn;
  final String nilaiUas;
  final String prestasiAkademik;
  final String prestasiNonAkademik;

  Prestasi({
    this.nilaiSemester,
    this.nilaiUn,
    this.nilaiUas,
    this.prestasiAkademik,
    this.prestasiNonAkademik,
  });
}
