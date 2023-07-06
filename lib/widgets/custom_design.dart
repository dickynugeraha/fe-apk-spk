import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'app_drawer.dart';

class CustomDesign {
  static InputDecoration customInputDecoration(String label) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      border: OutlineInputBorder(
          borderSide: const BorderSide(style: BorderStyle.none, width: 0),
          borderRadius: BorderRadius.circular(20)),
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      label: Text(
        label,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  static AwesomeDialog customAwesomeDialog({
    BuildContext context,
    String title,
    String desc,
    bool dialogSuccess,
    bool isPop = true,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogSuccess ? DialogType.success : DialogType.error,
      title: title,
      desc: desc,
      btnOkOnPress: isPop ? () => Navigator.of(context).pop() : () => {},
      btnOkColor: Colors.grey,
      btnOkText: "Oke",
    ).show();
  }

  static Container adminHeader({
    String barTitle,
    Widget action,
    Widget child,
    bool isDrawer = true,
  }) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/bg1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(barTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [action],
        ),
        drawer: isDrawer ? const AppDrawer() : null,
        body: child,
      ),
    );
  }
}
