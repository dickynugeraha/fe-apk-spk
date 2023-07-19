import 'package:flutter/material.dart';
import './profil/profil_screen.dart';
import './prestasi/prestasi_screen.dart';
import './home/home_screen.dart';
import './prestasi/prestasi_bobot_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = "/dashboard";
  const DashboardScreen({Key key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<DashboardScreen> {
  int _indexPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {"title": "Home", "page": const HomeScreen()},
    {"title": "Profil", "page": const ProfilScreen()},
    {"title": "Prestasi", "page": const PrestasiScreen()},
    {"title": "Pembobotan", "page": const PrestasiBobotScreen()},
  ];

  void _changePage(int index) {
    setState(() {
      _indexPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_indexPage]["page"],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _indexPage,
        onTap: _changePage,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 20,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            label: "Profil",
            icon: Icon(
              Icons.account_circle,
              size: 20,
            ),
          ),
          BottomNavigationBarItem(
            label: "Prestasi",
            icon: Icon(
              Icons.format_list_numbered_rtl,
              size: 20,
            ),
          ),
          BottomNavigationBarItem(
            label: "Bobot",
            icon: Icon(
              Icons.numbers,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
