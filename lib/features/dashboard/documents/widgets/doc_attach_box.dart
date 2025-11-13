import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocAttachBox extends StatefulWidget {
  final ValueChanged<XFile?>? onFilePicked;
  const DocAttachBox({super.key, this.onFilePicked});

  @override
  State<DocAttachBox> createState() => _DocAttachBoxState();
}

class _DocAttachBoxState extends State<DocAttachBox> {
  XFile? selectedFile;
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  Future<void> _pickImage() async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
    });

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedFile = image;
        });
        if (widget.onFilePicked != null) {
          widget.onFilePicked!(image);
        }
      }
    } catch (e) {
      //
    } finally {
      setState(() {
        _isPicking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width - 44;
    return Center(
      child: Container(
        width: boxWidth,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 2,
                ),
              ),
              child: Icon(
                selectedFile != null ? Icons.check_circle_outline : Icons.cloud_upload_outlined,
                size: 48,
                color: selectedFile != null ? const Color(0xFF10B981) : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              selectedFile != null ? "File Selected" : "Upload Document",
              style: const TextStyle(
                fontFamily: "bold",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            if (selectedFile != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.insert_drive_file_outlined,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        selectedFile!.name,
                        style: const TextStyle(
                          fontFamily: "bold",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
            ] else ...[
              Text(
                "Select an image file from your device",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "bold",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withValues(alpha: 0.5),
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isPicking ? null : _pickImage,
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isPicking
                            ? [
                          const Color(0xFFD1D5DB),
                          const Color(0xFFD1D5DB),
                        ]
                            : [
                          const Color(0xFF3B82F6),
                          const Color(0xFF2563EB),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _isPicking
                          ? []
                          : [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: _isPicking
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selectedFile != null ? Icons.refresh : Icons.upload_file,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            selectedFile != null ? "Change File" : "Choose File",
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (selectedFile == null) ...[
              const SizedBox(height: 16),
              Text(
                "Supported: JPG, PNG, JPEG",
                style: TextStyle(
                  fontFamily: "bold",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}