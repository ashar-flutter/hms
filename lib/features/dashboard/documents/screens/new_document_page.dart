import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/documents/screens/show_data_page.dart';
import 'package:hr_flow/features/dashboard/documents/widgets/date_field.dart';
import 'package:hr_flow/features/dashboard/documents/widgets/doc_attach_box.dart';
import 'package:hr_flow/features/dashboard/documents/widgets/doc_field.dart';
import 'package:hr_flow/features/dashboard/documents/widgets/doc_type_field.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/snakbar_helper.dart';

class NewDocumentPage extends StatefulWidget {
  const NewDocumentPage({super.key});

  @override
  State<NewDocumentPage> createState() => _NewDocumentPageState();
}

class _NewDocumentPageState extends State<NewDocumentPage> {
  final TextEditingController docNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedType;
  XFile? attachedFile;

  @override
  void dispose() {
    docNameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (docNameController.text.trim().isEmpty) {
      SnackbarHelper.showError(context, "Please enter document name");
      return;
    }

    if (selectedType == null || selectedType!.isEmpty) {
      SnackbarHelper.showError(context, "Please select document type");
      return;
    }

    if (dateController.text.trim().isEmpty) {
      SnackbarHelper.showError(context, "Please select expiry date");
      return;
    }

    if (attachedFile == null) {
      SnackbarHelper.showError(context, "Please attach a file");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ShowDataPage(
          docName: docNameController.text.trim(),
          docType: selectedType!,
          expiryDate: dateController.text.trim(),
          fileName: attachedFile!.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(size: 20, Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text(
            "Add New Document",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height / 1.2),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Document Name",
                  style: TextStyle(fontFamily: "bold", color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 5),
            DocField(text: "enter doc name...", controller: docNameController),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Document Type",
                  style: TextStyle(fontFamily: "bold", color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DocTypeField(
              hintText: "Select type",
              onChanged: (val) {
                setState(() {
                  selectedType = val;
                });
              },
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Expire",
                  style: TextStyle(fontFamily: "bold", color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DateField(controller: dateController),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Attachments",
                  style: TextStyle(fontFamily: "bold", color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DocAttachBox(
              onFilePicked: (file) {
                setState(() {
                  attachedFile = file;
                });
              },
            ),
            SizedBox(height: AppBar().preferredSize.height * 2),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 40,
              spreadRadius: 6,
              offset: const Offset(0, 12),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          color: Colors.white,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A11CB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: _onSave,
            child: const Text(
              "Save",
              style: TextStyle(
                fontFamily: "bold",
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
