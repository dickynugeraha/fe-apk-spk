import 'package:flutter/material.dart';

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
}
