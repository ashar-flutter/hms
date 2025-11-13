import 'package:flutter/material.dart';

class DocTypeField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String?>? onChanged;
  const DocTypeField({super.key, required this.hintText, this.onChanged});

  @override
  State<DocTypeField> createState() => _DocTypeFieldState();
}

class _DocTypeFieldState extends State<DocTypeField> {
  String? selectedType;
  final List<String> types = [
    "Admin document",
    "pdf",
    "excel file",
    "task file",
  ];

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
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        child: DropdownButtonHideUnderline(
          child: SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              value: selectedType,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.hintText,
                  style: const TextStyle(
                    fontFamily: "poppins",
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              icon: const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
              isExpanded: true,
              borderRadius: BorderRadius.circular(30),
              selectedItemBuilder: (BuildContext context) {
                return types.map((type) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontFamily: "poppins",
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  );
                }).toList();
              },
              items: types.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontFamily: "poppins",
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
                if (widget.onChanged != null) widget.onChanged!(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
