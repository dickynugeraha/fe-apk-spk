import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/kategori.dart';
import './providers/bobot.dart';
import './providers/sub_bobot.dart';
import './providers/auth.dart';
// admin screen
import './screens/sub_bobot/sub_bobot_screen.dart';
import './screens/sub_bobot/sub_bobot_edit_screen.dart';
import './screens/kategori/kategori_screen.dart';
import './screens/kategori/kategori_edit_screen.dart';
import './screens/bobot/bobot_screen.dart';
import './screens/bobot/bobot_edit_screen.dart';
// siswa screen
import './screens/profil/profil_edit_screen.dart';
import './screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, KategoriProvider>(
            create: (_) => KategoriProvider("", "", []),
            update: (_, auth, previousKategori) => KategoriProvider(
                auth.token, auth.username, previousKategori.items ?? []),
          ),
          ChangeNotifierProxyProvider<Auth, BobotProvider>(
            create: (_) => BobotProvider("", "", []),
            update: (_, auth, prevBobot) =>
                BobotProvider(auth.token, auth.username, prevBobot.items ?? []),
          ),
          ChangeNotifierProxyProvider<Auth, SubBobotProvider>(
            create: (_) => SubBobotProvider(),
            update: (_, auth, previousSubBobot) =>
                previousSubBobot..update(auth.token, auth.username),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            theme: ThemeData(
              fontFamily: "Montserrat",
              primaryColor: Colors.blue,
              splashColor: Colors.amber,
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                  .copyWith(secondary: Colors.amber),
              errorColor: const Color.fromARGB(255, 210, 51, 75),
              textTheme: const TextTheme(
                headline1: TextStyle(
                  fontFamily: "Kaushan Script",
                  fontSize: 40,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  letterSpacing: 5,
                ),
              ),
            ),
            home: auth.isLogin
                ? const KategoriScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, authSnapshot) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const DashboardScreen(),
                  ),
            routes: {
              AuthScreen.routeName: (context) => const AuthScreen(),
              DashboardScreen.routeName: (context) => const DashboardScreen(),
              KategoriScreen.routeName: (context) => const KategoriScreen(),
              KategoriEditScreen.routeName: (context) =>
                  const KategoriEditScreen(),
              BobotScreen.routeName: (context) => const BobotScreen(),
              BobotEditScreen.routeName: (context) => const BobotEditScreen(),
              SubBobotScreen.routeName: (context) => const SubBobotScreen(),
              SubBobotEditScreen.routeName: (context) =>
                  const SubBobotEditScreen(),
              ProfilEditScreen.routeName: (context) => const ProfilEditScreen(),
            },
          ),
        ));
  }
}
