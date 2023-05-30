import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";
  const AuthScreen({Key key}) : super(key: key);

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
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: deviceSize.height,
            width: deviceSize.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 75),
              Text("e-Prestasi", style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: 120),
              const AuthForm()
            ]),
          ),
        ),
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm({Key key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  Map<String, String> _authData = {"username": "", "password": ""};

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("Error Occured"),
          content: Text(
            message,
            style: const TextStyle(
                color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Oke"))
          ]),
    );
  }

  Future<void> _submitForm() async {
    final isValidForm = _form.currentState.validate();
    if (!isValidForm) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      Provider.of<Auth>(context, listen: false)
          .login(_authData["username"], _authData["password"], "/admin/login");
    } on HttpException catch (error) {
      _showErrorMessage(error.toString());
    } catch (e) {
      var errorMessage = "Tidak bisa login, terjadi sesuatu kesalahan!";
      _showErrorMessage(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              ),
              icon: const Icon(Icons.email, color: Colors.black),
              label: const Text(
                "Username",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Masukkan username";
              }
              return null;
            },
            onSaved: (newValue) {
              _authData["username"] = newValue;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              ),
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
            onEditingComplete: () => {_submitForm()},
            onSaved: (newValue) {
              _authData["password"] = newValue;
            },
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ButtonStyle(
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
            onPressed: _submitForm,
            child: SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
