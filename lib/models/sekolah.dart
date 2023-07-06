import 'package:flutter/material.dart';

class Sekolah {
  final String nama;
  final String deskripsi;
  final String pendaftaranDibuka;
  final String pendaftaranDitutup;
  final String pengumumanSeleksi;
  final String fotoLogo;
  final String fotoIdentitasSekolah;
  final String fotoAlurPendaftaran;

  Sekolah({
    @required this.nama,
    @required this.deskripsi,
    @required this.pendaftaranDibuka,
    @required this.pendaftaranDitutup,
    @required this.pengumumanSeleksi,
    this.fotoLogo,
    this.fotoIdentitasSekolah,
    this.fotoAlurPendaftaran,
  });
}
