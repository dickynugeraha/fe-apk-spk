import 'package:flutter/material.dart';
import 'package:ppdb_prestasi/widgets/custom_design.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';
import '../screens/sekolah/sekolah_screen.dart';
import '../screens/dashboard_screen.dart';

class AuthLogin extends StatefulWidget {
  final bool isAdminSection;

  const AuthLogin(this.isAdminSection, {Key key}) : super(key: key);

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  final form = GlobalKey<FormState>();
  bool isLoading = false;
  Map<String, String> authData = {"username": "", "password": ""};

  Future<void> submitForm() async {
    if (!form.currentState.validate()) {
      return;
    }
    form.currentState.save();
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.isAdminSection) {
        await Provider.of<Auth>(context, listen: false)
            .login(authData["username"], authData["password"], "/admin/login");
        Navigator.of(context).pushReplacementNamed(SekolahScreen.routeName);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .login(authData["username"], authData["password"], "/siswa/login");
        Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
      }
    } on HttpException catch (error) {
      CustomDesign.customAwesomeDialog(
        context: context,
        title: "Error occured",
        desc: error.toString(),
        dialogSuccess: false,
        isPop: false,
      );
    } catch (e) {
      CustomDesign.customAwesomeDialog(
        context: context,
        title: "Error occured",
        desc: e.toString(),
        dialogSuccess: false,
        isPop: false,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              widget.isAdminSection ? 'Admin' : 'Siswa',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: form,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      icon: const Icon(Icons.email, color: Colors.black),
                      label: Text(
                        widget.isAdminSection ? "Username" : "Nisn",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    keyboardType: widget.isAdminSection
                        ? TextInputType.text
                        : TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.isAdminSection
                            ? "Masukkan username"
                            : "Masukkan NISN";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      authData["username"] = newValue;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      filled: true,
                      icon: const Icon(Icons.key, color: Colors.black),
                      label: const Text(
                        "Password",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    obscureText: true,
                    obscuringCharacter: '●',
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Masukkan password";
                      }
                      // if (value.length <= 5) {
                      //   return "Password harus lebih dari lima huruf";
                      // }
                      return null;
                    },
                    onEditingComplete: () => {submitForm()},
                    onSaved: (newValue) {
                      authData["password"] = newValue;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 38, 80, 196),
                      ),
                      elevation: MaterialStateProperty.all(8),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    onPressed: submitForm,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        isLoading ? "..." : "Login",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
