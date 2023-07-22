import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// provider
import './providers/kategori.dart';
import './providers/bobot.dart';
import './providers/sub_bobot.dart';
import './providers/auth.dart';
import './providers/siswa.dart';
import './providers/sekolah.dart';
import './providers/nilai.dart';
// admin screen
import 'screens/admin_sub_bobot/sub_bobot_screen.dart';
import 'screens/admin_sub_bobot/sub_bobot_edit_screen.dart';
import 'screens/admin_kategori/kategori_screen.dart';
import 'screens/admin_kategori/kategori_edit_screen.dart';
import 'screens/admin_bobot/bobot_screen.dart';
import 'screens/admin_bobot/bobot_edit_screen.dart';
import 'screens/admin_sekolah/sekolah_screen.dart';
import 'screens/admin_sekolah/sekolah_edit_screen.dart';
import 'screens/admin_nilai/nilai_screen.dart';
import 'screens/admin_nilai/nilai_detail_screen.dart';
// siswa screen
import 'screens/siswa_profil/profil_edit_screen.dart';
import 'screens/siswa_home/home_screen.dart';
import './screens/auth_screen.dart';
import './widgets/siswa_tab.dart';
import './screens/splash_screen.dart';

// String token;
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   final dataAuth =
//       json.decode(prefs.getString("dataAuth")) as Map<String, Object>;
//   token = dataAuth["token"];

//   runApp(const MyApp());
// }
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
          create: (_) => SekolahProvider(),
          update: (_, auth, prevSekolah) => prevSekolah..update(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, NilaiProvider>(
          create: (_) => NilaiProvider(),
          update: (_, auth, prevNilai) =>
              prevNilai..update(auth.nisn, auth.token),
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
          home:
              // token != null
              auth.isLogin
                  ? auth.username != null
                      ? const SekolahScreen()
                      : const DashboardScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, authSnapshot) =>
                          authSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const SplashScreen()
                              : const AuthScreen(),
                    ),
          routes: {
            AuthScreen.routeName: (_) => const AuthScreen(),
            DashboardScreen.routeName: (_) => const DashboardScreen(),
            HomeScreen.routeName: (_) => const HomeScreen(),
            ProfilEditScreen.routeName: (_) => const ProfilEditScreen(),
            SekolahEditScreen.routeName: (_) => const SekolahEditScreen(),
            SekolahScreen.routeName: (_) => const SekolahScreen(),
            KategoriScreen.routeName: (_) => const KategoriScreen(),
            KategoriEditScreen.routeName: (_) => const KategoriEditScreen(),
            BobotScreen.routeName: (_) => const BobotScreen(),
            BobotEditScreen.routeName: (_) => const BobotEditScreen(),
            SubBobotScreen.routeName: (_) => const SubBobotScreen(),
            SubBobotEditScreen.routeName: (_) => const SubBobotEditScreen(),
            NilaiScreen.routeName: (_) => const NilaiScreen(),
            NilaiDetailScreen.routeName: (_) => const NilaiDetailScreen(),
          },
        ),
      ),
    );
  }
}
