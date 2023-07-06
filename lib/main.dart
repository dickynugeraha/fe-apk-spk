import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/kategori.dart';
import './providers/bobot.dart';
import './providers/sub_bobot.dart';
import './providers/auth.dart';
import './providers/siswa.dart';
import './providers/sekolah.dart';
// admin screen
import './screens/sub_bobot/sub_bobot_screen.dart';
import './screens/sub_bobot/sub_bobot_edit_screen.dart';
import './screens/kategori/kategori_screen.dart';
import './screens/kategori/kategori_edit_screen.dart';
import './screens/bobot/bobot_screen.dart';
import './screens/bobot/bobot_edit_screen.dart';
import './screens/sekolah/sekolah_screen.dart';
import './screens/sekolah/sekolah_edit_screen.dart';
// siswa screen
import './screens/profil/profil_edit_screen.dart';
import './screens/home/home_screen.dart';
import './screens/auth_screen.dart';
import './screens/dashboard_screen.dart';
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
            auth.token,
            auth.username,
            previousKategori.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, BobotProvider>(
          create: (_) => BobotProvider("", "", []),
          update: (_, auth, prevBobot) => BobotProvider(
            auth.token,
            auth.username,
            prevBobot.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, SubBobotProvider>(
          create: (_) => SubBobotProvider(),
          update: (_, auth, previousSubBobot) =>
              previousSubBobot..update(auth.token, auth.username),
        ),
        ChangeNotifierProxyProvider<Auth, SiswaProvider>(
          create: (_) => SiswaProvider(),
          update: (_, auth, prevSiswa) =>
              prevSiswa..update(auth.token, auth.nisn),
        ),
        ChangeNotifierProxyProvider<Auth, SekolahProvider>(
          create: (context) => SekolahProvider(),
          update: (context, auth, prevSekolah) =>
              prevSekolah..update(auth.token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xffF1F1F9),
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
              ? auth.username != null
                  ? const SekolahScreen()
                  : const DashboardScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            AuthScreen.routeName: (_) => const AuthScreen(),
            DashboardScreen.routeName: (_) => const DashboardScreen(),
            HomeScreen.routeName: (_) => const HomeScreen(),
            SekolahScreen.routeName: (_) => const SekolahScreen(),
            SekolahEditScreen.routeName: (_) => const SekolahEditScreen(),
            KategoriScreen.routeName: (_) => const KategoriScreen(),
            KategoriEditScreen.routeName: (_) => const KategoriEditScreen(),
            BobotScreen.routeName: (_) => const BobotScreen(),
            BobotEditScreen.routeName: (_) => const BobotEditScreen(),
            SubBobotScreen.routeName: (_) => const SubBobotScreen(),
            SubBobotEditScreen.routeName: (_) => const SubBobotEditScreen(),
            ProfilEditScreen.routeName: (_) => const ProfilEditScreen(),
          },
        ),
      ),
    );
  }
}
