import 'package:flutter/material.dart';
import 'package:maismaisbolso/view/configs/colors_config.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool validate;

  const MyTextField(
      {super.key, required this.hintText, required this.controller, required this.inputType, required this.validate});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: ColorsConfig.yellowOne,
      keyboardType: inputType,
      decoration: InputDecoration(
        errorText: validate ? "Preencha esse campo" : null,
        fillColor: Colors.blue,
        hoverColor: Colors.blue,
        contentPadding: EdgeInsets.all(8),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black54,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsConfig.yellowOne,
            width: 2,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsConfig.yellowOne,
            width: 2,
          ),
        ),
        border: const OutlineInputBorder(
        ),
      ),
    );
  }
}
