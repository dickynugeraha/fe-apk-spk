import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../widgets/auth_login.dart';
import '../widgets/auth_register.dart';

enum AuthMode { Login, Register }

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  const AuthScreen({Key key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var authMode = AuthMode.Login;
  bool isAdminSection = true;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
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
                    child: Center(
                      child: Text(
                        "e-Prestasi",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
                  authMode == AuthMode.Login
                      ? AuthLogin(isAdminSection)
                      : SizedBox(
                          height: deviceSize.height * 0.65,
                          child: const AuthRegister(),
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

// class AuthForm extends StatefulWidget {
//   const AuthForm({Key key}) : super(key: key);

//   @override
//   State<AuthForm> createState() => _AuthFormState();
// }

// class _AuthFormState extends State<AuthForm> {
//   final _form = GlobalKey<FormState>();
//   final passwordController = TextEditingController();
//   bool _isLoading = false;
//   Map<String, String> _authData = {"username": "", "password": ""};

//   void _showErrorMessage(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//           title: const Text("Error Occured"),
//           content: Text(
//             message,
//             style: const TextStyle(
//                 color: Colors.grey, fontStyle: FontStyle.italic),
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text("Oke"))
//           ]),
//     );
//   }

//   Future<void> _submitForm() async {
//     final isValidForm = _form.currentState.validate();
//     if (!isValidForm) {
//       return;
//     }
//     _form.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       Provider.of<Auth>(context, listen: false)
//           .login(_authData["username"], _authData["password"], "/admin/login");
//     } on HttpException catch (error) {
//       _showErrorMessage(error.toString());
//     } catch (e) {
//       var errorMessage = "Tidak bisa login, terjadi sesuatu kesalahan!";
//       _showErrorMessage(errorMessage);
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(25),
//         child: Column(
//           children: [
//             const Text(
//               "Login admin",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Form(
//               key: _form,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                               width: 0, style: BorderStyle.none)),
//                       filled: true,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide:
//                             const BorderSide(width: 0, style: BorderStyle.none),
//                       ),
//                       icon: const Icon(Icons.email, color: Colors.black),
//                       label: const Text(
//                         "Username",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return "Masukkan username";
//                       }
//                       return null;
//                     },
//                     onSaved: (newValue) {
//                       _authData["username"] = newValue;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                               width: 0, style: BorderStyle.none)),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide:
//                             const BorderSide(width: 0, style: BorderStyle.none),
//                       ),
//                       filled: true,
//                       icon: const Icon(Icons.key, color: Colors.black),
//                       label: const Text(
//                         "Password",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                     obscureText: true,
//                     obscuringCharacter: '●',
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return "Masukkan password";
//                       }
//                       // if (value.length <= 5) {
//                       //   return "Password harus lebih dari lima huruf";
//                       // }
//                       return null;
//                     },
//                     onEditingComplete: () => {_submitForm()},
//                     onSaved: (newValue) {
//                       _authData["password"] = newValue;
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                         // elevation: 8,
//                         // backgroundColor: const Color.fromARGB(255, 4, 85, 206),
//                         ),
//                     onPressed: _submitForm,
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: _isLoading
//                           ? const CircularProgressIndicator()
//                           : const Text(
//                               "Login",
//                               textAlign: TextAlign.center,
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
