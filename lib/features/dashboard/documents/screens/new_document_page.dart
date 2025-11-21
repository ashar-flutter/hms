import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/documents/screens/show_data_page.dart';
import 'package:hr_flow/features/dashboard/documents/widgets/date_field.dart';
import 'package:hr_flow/features/dashboard/documents/widgets/doc_attach_box.dart';
import 'package:hr_flow/features/dashboard/documents/widgets/doc_field.dart';
import 'package:hr_flow/features/dashboard/documents/widgets/doc_type_field.dart';
import 'package:image_picker/image_picker.dart';
import '../service/document_service.dart';

class NewDocumentPage extends StatefulWidget {
  const NewDocumentPage({super.key});

  @override
  State<NewDocumentPage> createState() => _NewDocumentPageState();
}

class _NewDocumentPageState extends State<NewDocumentPage> {
  final DocumentService documentService = DocumentService();
  final TextEditingController docNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedType;
  XFile? attachedFile;
  bool _isSubmitting = false;
  final FocusNode _docNameFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  bool isPdfFile = false;

  @override
  void initState() {
    super.initState();
    _setupFocusManagement();
  }

  void _setupFocusManagement() {
    _docNameFocus.addListener(() {
      if (!_docNameFocus.hasFocus) {
        final currentText = docNameController.text.trim();
        if (currentText.isNotEmpty) {
          docNameController.text =
              currentText[0].toUpperCase() + currentText.substring(1);
        }
      }
    });
  }

  @override
  void dispose() {
    docNameController.dispose();
    dateController.dispose();
    _docNameFocus.dispose();
    _dateFocus.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();

    if (docNameController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter document name');
      return;
    }
    if (selectedType == null || selectedType!.isEmpty) {
      _showErrorSnackbar('Please select document type');
      return;
    }
    if (dateController.text.trim().isEmpty) {
      _showErrorSnackbar('Please select submission date');
      return;
    }
    if (attachedFile == null) {
      _showErrorSnackbar('Please attach a file');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await documentService.submitDocument(
        docName: docNameController.text.trim(),
        docType: selectedType!,
        expiryDate: dateController.text.trim(),
        fileName: attachedFile!.name,
        filePath: attachedFile!.path,
        isPdf: isPdfFile,

      );

      if (!mounted) return;

      showDialog(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        barrierDismissible: false,
        builder: (context) => ShowDataDialog(
          docName: docNameController.text.trim(),
          docType: selectedType!,
          expiryDate: dateController.text.trim(),
          fileName: attachedFile!.name,
        ),
      ).then((_) {
        _clearForm();
        Get.back();
      });
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar('Failed to submit document. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: "poppins", fontSize: 14),
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  void _clearForm() {
    docNameController.clear();
    dateController.clear();
    selectedType = null;
    attachedFile = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF), // white
                  Color(0xFFF2F6FA), // soft blue-gray
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: AppBar(
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              title: const Text(
                "Add New Document",
                style: TextStyle(
                  fontFamily: "bold",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Document Information"),
              const SizedBox(height: 20),

              _buildInputField(
                label: "Document Name",
                hint: "Enter document name...",
                icon: Icons.description_outlined,
                child: DocField(
                  text: "Enter document name...",
                  controller: docNameController,
                  focusNode: _docNameFocus,
                ),
              ),
              const SizedBox(height: 20),

              _buildInputField(
                label: "Document Type",
                hint: "Select document type",
                icon: Icons.category_outlined,
                child: DocTypeField(
                  hintText: "Select document type",
                  onChanged: (val) {
                    setState(() {
                      selectedType = val;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              _buildInputField(
                label: "Submission Date",
                hint: "Select submission date",
                icon: Icons.calendar_today_outlined,
                child: DateField(
                  controller: dateController,
                  focusNode: _dateFocus,
                ),
              ),
              const SizedBox(height: 25),

              _buildSectionHeader("File Attachment"),
              const SizedBox(height: 15),

              _buildAttachmentSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
        bottomSheet: _buildSaveButton(),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: "bold",
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: "bold",
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  _buildAttachmentSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: DocAttachBox(
        onFilePicked: (file) {
          setState(() {
            attachedFile = file;
            isPdfFile = false;

          });
        },
        onPdfPicked: (pdfFile) {
          if (pdfFile != null) {
            setState(() {
              attachedFile = XFile(pdfFile.path!);
              isPdfFile = true;

            });
          }
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: _isSubmitting
                ? LinearGradient(colors: [Colors.grey[400]!, Colors.grey[500]!])
                : const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isSubmitting
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _isSubmitting ? null : _onSave,
            child: _isSubmitting
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_rounded, size: 20, color: Colors.white),
                      const SizedBox(width: 10),
                      const Text(
                        "Save Document",
                        style: TextStyle(
                          fontFamily: "bold",
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
