import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class DocumentDialogBox extends StatelessWidget {
  final String fileUrl;
  final String fileName;

  const DocumentDialogBox({
    super.key,
    required this.fileUrl,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildFilePreview(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.preview_rounded,
            color: Colors.blue,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            fileName,
            style: const TextStyle(
              fontFamily: "bold",
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close_rounded, size: 20),
        ),
      ],
    );
  }

  Widget _buildFilePreview() {
    final isImage = _isImageFile(fileName);
    final isPdf = _isPdfFile(fileName);

    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isImage) _buildImagePreview(),
          if (isPdf) _buildPdfPreview(),
          if (!isImage && !isPdf) _buildGenericPreview(),
          const SizedBox(height: 16),
          Text(
            fileName,
            style: const TextStyle(
              fontFamily: "poppins",
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Column(
      children: [
        Icon(Icons.image_rounded, size: 60, color: Colors.blue[300]),
        const SizedBox(height: 8),
        const Text(
          "Image Preview",
          style: TextStyle(
            fontFamily: "bold",
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPdfPreview() {
    return Column(
      children: [
        Icon(Icons.picture_as_pdf_rounded, size: 60, color: Colors.red[300]),
        const SizedBox(height: 8),
        const Text(
          "PDF Document",
          style: TextStyle(
            fontFamily: "bold",
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGenericPreview() {
    return Column(
      children: [
        Icon(Icons.insert_drive_file_rounded, size: 60, color: Colors.grey[400]),
        const SizedBox(height: 8),
        const Text(
          "Document File",
          style: TextStyle(
            fontFamily: "bold",
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _openInBrowser,
            icon: const Icon(Icons.open_in_browser_rounded, size: 18),
            label: const Text(
              "Browse",
              style: TextStyle(fontFamily: "bold", fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _copyToClipboard,
            icon: const Icon(Icons.content_copy_rounded, size: 18),
            label: const Text(
              "Copy Link",
              style: TextStyle(fontFamily: "bold", fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  void _openInBrowser() async {
    try {
      if (await canLaunchUrl(Uri.parse(fileUrl))) {
        await launchUrl(Uri.parse(fileUrl));
      } else {
        Get.snackbar(
          "Error",
          "Cannot open file",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to open file",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: fileUrl));
    Get.snackbar(
      "Copied!",
      "File link copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  bool _isImageFile(String fileName) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    return imageExtensions.any((ext) => fileName.toLowerCase().contains(ext));
  }

  bool _isPdfFile(String fileName) {
    return fileName.toLowerCase().contains('.pdf');
  }
}