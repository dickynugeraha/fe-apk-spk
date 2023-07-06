import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/kategori/kategori_screen.dart';
import "../screens/bobot/bobot_screen.dart";
import "../screens/auth_screen.dart";
import '../screens/sekolah/sekolah_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget navItem(IconData icon, String title, String routeName) {
      return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        onTap: () => Navigator.of(context).pushReplacementNamed(routeName),
      );
    }

    return Drawer(
      child: Column(children: [
        Container(
          height: 120,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: const Center(
            child: Text(
              "Menu",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
            child: Column(
          children: [
            navItem(Icons.school_sharp, "Sekolah", SekolahScreen.routeName),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.category,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text("Kategori"),
              onTap: () => Navigator.of(context).pushReplacementNamed(
                KategoriScreen.routeName,
                arguments: true,
              ),
            ),
            const Divider(),
            navItem(Icons.scale, "Bobot", BobotScreen.routeName),
            const Divider(),
            // navItem(Icons.line_weight, "Sub Bobot", SubBobotScreen.routeName),
            ListTile(
              leading: Icon(
                Icons.line_weight,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text("Sub Bobot"),
              onTap: () => Navigator.of(context).pushReplacementNamed(
                KategoriScreen.routeName,
                arguments: false,
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName);
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            const Divider(),
          ],
        )),
      ]),
    );
  }
}
