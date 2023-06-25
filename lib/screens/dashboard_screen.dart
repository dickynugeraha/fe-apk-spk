import 'package:flutter/material.dart';
import './profil/profil_screen.dart';
import './nilai_prestasi/nilai_prestasi.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = "/dashboard";
  const DashboardScreen({Key key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<DashboardScreen> {
  int _indexPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {"title": "Profil", "page": const ProfilScreen()},
    {"title": "Prestasi dan nilai", "page": const NilaiPrestasi()}
  ];

  void _changePage(int index) {
    setState(() {
      _indexPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: Text(
      //     _pages[_indexPage]["title"],
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: _pages[_indexPage]["page"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexPage,
        onTap: _changePage,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            label: "Profil",
            icon: Icon(
              Icons.account_circle,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: "Prestasi",
            icon: Icon(
              Icons.format_list_numbered_rtl,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
