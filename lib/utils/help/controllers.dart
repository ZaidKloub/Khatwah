import 'package:flutter/material.dart';

class FormControllers {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
  }
}