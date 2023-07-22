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
  final Nilai nilai;

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
    this.nilai,
  });
}

class Prestasi {
  final String id;
  final String nisn;
  final String nilaiSemester;
  final String nilaiUn;
  final String nilaiUas;
  final String prestasiAkademik;
  final String prestasiNonAkademik;

  Prestasi({
    this.id,
    this.nisn,
    this.nilaiSemester,
    this.nilaiUn,
    this.nilaiUas,
    this.prestasiAkademik,
    this.prestasiNonAkademik,
  });
}

class Nilai {
  final String id;
  final String nisn;
  final String parameterId;
  final String namaParameter;
  final int nilai;

  Nilai({
    @required this.id,
    @required this.nisn,
    @required this.parameterId,
    @required this.namaParameter,
    @required this.nilai,
  });
}
