import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class DocAttachBox extends StatefulWidget {
  final ValueChanged<XFile?>? onFilePicked;
  final ValueChanged<PlatformFile?>? onPdfPicked;
  const DocAttachBox({super.key, this.onFilePicked, this.onPdfPicked});

  @override
  State<DocAttachBox> createState() => _DocAttachBoxState();
}

class _DocAttachBoxState extends State<DocAttachBox> {
  XFile? selectedImage;
  PlatformFile? selectedPdf;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isPicking = false;

  Future<void> _pickImage() async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
    });

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          selectedImage = image;
          selectedPdf = null;
        });
        if (widget.onFilePicked != null) {
          widget.onFilePicked!(image);
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isPicking = false;
      });
    }
  }

  Future<void> _pickPdf() async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedPdf = result.files.first;
          selectedImage = null;
        });
        if (widget.onPdfPicked != null) {
          widget.onPdfPicked!(selectedPdf);
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isPicking = false;
      });
    }
  }

  void _clearSelection() {
    setState(() {
      selectedImage = null;
      selectedPdf = null;
    });
    if (widget.onFilePicked != null) widget.onFilePicked!(null);
    if (widget.onPdfPicked != null) widget.onPdfPicked!(null);
  }

  String get _fileName {
    if (selectedImage != null) return selectedImage!.name;
    if (selectedPdf != null) return selectedPdf!.name;
    return '';
  }

  bool get _hasFile => selectedImage != null || selectedPdf != null;

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
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Icon Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getIconColor().withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getIconColor().withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(_getIcon(), size: 48, color: _getIconColor()),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              _hasFile ? "File Selected" : "Upload Document",
              style: const TextStyle(
                fontFamily: "bold",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),

            // File Info
            if (_hasFile) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getFileIcon(), size: 20, color: _getIconColor()),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _fileName,
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
              const SizedBox(height: 8),
            ] else ...[
              Text(
                "Select an image or PDF file from your device",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Buttons Row
            if (!_hasFile) _buildSelectionButtons() else _buildActionButtons(),

            // Supported Formats
            if (!_hasFile) ...[
              const SizedBox(height: 16),
              Text(
                "Supported: JPG, PNG, JPEG, PDF",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            onPressed: _isPicking ? null : _pickImage,
            icon: Icons.photo_library_rounded,
            text: "Image",
            color: const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
            onPressed: _isPicking ? null : _pickPdf,
            icon: Icons.picture_as_pdf_rounded,
            text: "PDF",
            color: const Color(0xFFDC2626),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            onPressed: _isPicking ? null : _clearSelection,
            icon: Icons.delete_outline_rounded,
            text: "Remove",
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
            onPressed: _isPicking
                ? null
                : _hasFile
                ? _pickPdf
                : _pickImage,
            icon: Icons.change_circle_rounded,
            text: "Change",
            color: const Color(0xFF059669),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: onPressed == null
                  ? [Colors.grey[400]!, Colors.grey[500]!]
                  : [color, Color.alphaBlend(color.withOpacity(0.8), color)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: onPressed == null
                ? []
                : [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: _isPicking
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "bold",
                          fontSize: 13,
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

  IconData _getIcon() {
    if (selectedPdf != null) return Icons.picture_as_pdf_rounded;
    if (selectedImage != null) return Icons.check_circle_outline;
    return Icons.cloud_upload_outlined;
  }

  IconData _getFileIcon() {
    if (selectedPdf != null) return Icons.picture_as_pdf_rounded;
    return Icons.insert_drive_file_outlined;
  }

  Color _getIconColor() {
    if (selectedPdf != null) return const Color(0xFFDC2626);
    if (selectedImage != null) return const Color(0xFF059669);
    return const Color(0xFF6B7280);
  }
}
