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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedFile = image;
      });
      if (widget.onFilePicked != null) widget.onFilePicked!(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width - 44;
    return Center(
      child: Container(
        width: boxWidth,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Upload",
              style: TextStyle(
                fontFamily: "bold",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (selectedFile != null) ...[
              const SizedBox(height: 10),
              Text(
                selectedFile!.name,
                style: const TextStyle(
                  fontFamily: "bold",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00008B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                child: const Text(
                  "Upload file",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "bold",
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
