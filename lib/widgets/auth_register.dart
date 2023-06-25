import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';
import '../widgets/custom_design.dart';

class AuthRegister extends StatefulWidget {
  const AuthRegister({Key key}) : super(key: key);

  @override
  State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  bool isLoading = false;
  final form = GlobalKey<FormState>();
  Map<String, String> authData = {
    "nisn": "",
    "nama": "",
    "jenis_kelamin": "L",
    "asal_sekolah": "",
    "no_hp_ortu": "",
    "alamat": "",
    "email": "",
    "password": "",
  };
  String valueJenisKelamin = "L";

  void showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          message,
          style:
              const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Okey"),
          ),
        ],
      ),
    );
  }

  Future<void> submitForm() async {
    if (!form.currentState.validate()) {
      return;
    }
    form.currentState.save();

    print(authData);

    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .register(authData, "/siswa/register");
      showMessageDialog(
        "Successfully",
        "Siswa berhasil didaftarkan, silahkan melakukan login",
      );
    } on HttpException catch (errorMessage) {
      showMessageDialog("Error Occured", errorMessage.toString());
    } catch (e) {
      showMessageDialog("Error Occured", e.toString());
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Daftar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: CustomDesign.customInputDecoration("Nisn"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return validateNullInput("Nisn", value);
                      },
                      onSaved: (newValue) {
                        authData["nisn"] = newValue.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: CustomDesign.customInputDecoration("Nama"),
                      validator: (value) {
                        return validateNullInput("Nama", value);
                      },
                      onSaved: (newValue) {
                        authData["nama"] = newValue.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const Text(
                          "Jenis kelamin",
                          style:
                              TextStyle(color: Color.fromARGB(255, 89, 89, 89)),
                        ),
                        const SizedBox(width: 20),
                        DropdownButton(
                          value: valueJenisKelamin,
                          items: const [
                            DropdownMenuItem(
                              value: "L",
                              child: Text("Laki-laki"),
                            ),
                            DropdownMenuItem(
                              value: "P",
                              child: Text("Perempuan"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              authData["jenis_kelamin"] = value;
                              valueJenisKelamin = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          CustomDesign.customInputDecoration("Asal sekolah"),
                      validator: (value) {
                        return validateNullInput("asal sekolah", value);
                      },
                      onSaved: (newValue) {
                        authData["asal_sekolah"] = newValue.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: CustomDesign.customInputDecoration("Alamat"),
                      validator: (value) {
                        return validateNullInput("alamat", value);
                      },
                      maxLines: 3,
                      onSaved: (newValue) {
                        authData["alamat"] = newValue.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          CustomDesign.customInputDecoration("No hp ortu"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return validateNullInput("no hp ortu", value);
                      },
                      onSaved: (newValue) {
                        authData["no_hp_ortu"] = newValue.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: CustomDesign.customInputDecoration("Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!value.contains("@")) {
                          return "Silahkan masukan email dengan benar";
                        }
                        return validateNullInput("email", value);
                      },
                      onSaved: (newValue) {
                        authData["email"] = newValue.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          CustomDesign.customInputDecoration("Password"),
                      validator: (value) {
                        if (value.length < 6) {
                          return "Password harus lebih dari 6 karakter";
                        }
                        return validateNullInput("password", value);
                      },
                      obscureText: true,
                      obscuringCharacter: '●',
                      onSaved: (newValue) {
                        authData["password"] = newValue.toString();
                      },
                      onEditingComplete: () {
                        submitForm();
                      },
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? SpinKitFadingCircle(
                            color: Theme.of(context).primaryColor,
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 38, 80, 196),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                            onPressed: submitForm,
                            child: const SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Register",
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
      ),
    );
  }

  String validateNullInput(String nameField, String valueEntered) {
    if (valueEntered.isEmpty) {
      return "Field $nameField harus diisi";
    }
    return null;
  }
}
