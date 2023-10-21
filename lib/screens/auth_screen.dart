import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/auth_login.dart';
import '../widgets/auth_register.dart';
import '../providers/sekolah.dart';

enum AuthMode { Login, Register }

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var authMode = AuthMode.Login;
  bool isAdminSection = true;
  bool isLoading = true;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<SekolahProvider>(context, listen: false)
          .getAndSetSekolahProfile()
          .then((_) => isLoading = false);

      isInit = false;
    }
    super.didChangeDependencies();
  }

  void registerSuccessfully() {
    setState(() {
      authMode = AuthMode.Login;
      isAdminSection = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sekolah = Provider.of<SekolahProvider>(context).item;

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/img/bg2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: deviceSize.height,
                  width: deviceSize.width,
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: deviceSize.height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "e-Prestasi",
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              Text(
                                "PPDB ${sekolah!.nama!}",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                        authMode == AuthMode.Login
                            ? AuthLogin(isAdminSection)
                            : SizedBox(
                                height: deviceSize.height * 0.65,
                                child: AuthRegister(
                                    changeSection: registerSuccessfully),
                              ),
                        if (authMode == AuthMode.Login)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Apakah kamu ${isAdminSection ? 'siswa' : 'admin'}?"),
                              TextButton(
                                onPressed: () {
                                  if (isAdminSection) {
                                    // lagi di section admin
                                    setState(() {
                                      isAdminSection = false;
                                    });
                                  } else {
                                    setState(() {
                                      isAdminSection = true;
                                    });
                                  }
                                },
                                child: Text(
                                    "Login  ${isAdminSection ? 'siswa' : 'admin'}"),
                              ),
                            ],
                          ),
                        if (!isAdminSection && authMode == AuthMode.Login)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Belum memiliki akun?"),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    authMode = AuthMode.Register;
                                  });
                                },
                                child: const Text("Register"),
                              ),
                            ],
                          ),
                        if (authMode == AuthMode.Register)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Sudah memiliki akun?"),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    authMode = AuthMode.Login;
                                    isAdminSection = false;
                                  });
                                },
                                child: const Text("Login siswa"),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
