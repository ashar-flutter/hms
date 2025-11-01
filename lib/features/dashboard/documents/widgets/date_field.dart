import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final TextEditingController controller;
  const DateField({super.key, required this.controller});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

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
        controller: controller,
        readOnly: true,
        style: const TextStyle(
          fontFamily: "poppins",
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
        cursorColor: Colors.grey.shade800,
        decoration: InputDecoration(
          hintText: "DD/MM/YYYY",
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey.shade900, fontSize: 15),
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
          suffixIcon: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => _selectDate(context),
            child: Icon(Icons.calendar_today_rounded, color: Color(0xFF00008B)),
          ),
        ),
      ),
    );
  }
}
