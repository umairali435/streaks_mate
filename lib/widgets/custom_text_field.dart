import 'package:flutter/material.dart';
import 'package:streaksmate/utils/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    this.validator,
    required this.controller,
    required this.labelText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryColor,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        validator: widget.validator,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          labelText: widget.labelText,
          focusedErrorBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          labelStyle: const TextStyle(
            color: AppColors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
        ),
      ),
    );
  }
}
