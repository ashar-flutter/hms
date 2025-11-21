import 'package:flutter/material.dart';

class DocField extends StatelessWidget {
  final String text;
  final FocusNode? focusNode;

  final TextEditingController? controller;
  const DocField({
    super.key,
    required this.text,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        focusNode: focusNode,

        controller: controller,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
        style: const TextStyle(
          fontFamily: "poppins",
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
        cursorColor: Colors.grey.shade800,
        decoration: InputDecoration(
          hintText: text,
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 13,
            fontFamily: "poppins",
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey.shade300.withValues(alpha: 0.9),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
          ),
        ),
      ),
    );
  }
}
