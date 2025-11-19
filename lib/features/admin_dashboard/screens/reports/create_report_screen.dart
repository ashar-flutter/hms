import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/admin_dashboard/screens/reports/report_controller.dart';
import 'package:iconsax/iconsax.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final ReportController _controller = Get.find<ReportController>();
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode(); // ✅ Added focus node for keyboard management

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedType = 'meeting';

  final List<Map<String, dynamic>> _reportTypes = [
    {
      'value': 'meeting',
      'label': 'Meeting',
      'icon': Iconsax.calendar_2,
      'color': Color(0xFF2563EB),
      'bgColor': Color(0xFFEFF6FF),
    },
    {
      'value': 'holiday',
      'label': 'Holiday',
      'icon': Iconsax.sun_1,
      'color': Color(0xFF10B981),
      'bgColor': Color(0xFFECFDF5),
    },
    {
      'value': 'remote',
      'label': 'Remote',
      'icon': Iconsax.home_hashtag,
      'color': Color(0xFFF59E0B),
      'bgColor': Color(0xFFFFFBEB),
    },
    {
      'value': 'client_meeting',
      'label': 'Client',
      'icon': Iconsax.briefcase,
      'color': Color(0xFF8B5CF6),
      'bgColor': Color(0xFFF5F3FF),
    },
  ];

  Future<void> _submitReport() async {
    // ✅ Keyboard close before submission
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final success = await _controller.createNewReport(
      title: _titleController.text.trim(),
      type: _selectedType,
      message: _messageController.text.trim(),
    );

    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        'Report created successfully!',
        backgroundColor: Color(0xFF10B981),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 12,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to create report. Please try again.',
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 12,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _focusNode.dispose(); // ✅ Dispose focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ Tap outside to close keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.arrow_left_2,
                        color: Color(0xFF374151),
                        size: 20,
                      ),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Report',
                        style: TextStyle(
                          fontFamily: 'bold',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'LA Digital Agency',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Type',
                        style: TextStyle(
                          fontFamily: 'bold',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _reportTypes.length,
                          itemBuilder: (context, index) {
                            final type = _reportTypes[index];
                            final isSelected = _selectedType == type['value'];

                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedType = type['value']),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? type['color']
                                      : type['bgColor'],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? type['color']!
                                        : type['color'].withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      type['icon'],
                                      color: isSelected
                                          ? Colors.white
                                          : type['color'],
                                      size: 20,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      type['label'],
                                      style: TextStyle(
                                        fontFamily: isSelected
                                            ? 'bold'
                                            : 'Poppins',
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 11,
                                        color: isSelected
                                            ? Colors.white
                                            : type['color'],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Report Details',
                        style: TextStyle(
                          fontFamily: 'bold',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Report Title',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                            prefixIcon: Icon(
                              Iconsax.document_text,
                              color: Color(0xFF2563EB),
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xFF111827),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter report title';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Message Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _messageController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Report Message',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xFF111827),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter report message';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Submit Button
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _controller.isLoading.value
                                ? null
                                : _submitReport,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor: Color(0xFF2563EB).withOpacity(0.3),
                            ),
                            child: _controller.isLoading.value
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.send_2,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Create Report',
                                        style: TextStyle(
                                          fontFamily: 'bold',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
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
