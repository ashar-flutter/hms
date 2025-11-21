import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hr_flow/features/dashboard/requests/submit_request_screen.dart';
import '../../../../core/snackbar/custom_snackbar.dart';
import 'controller/request_controller.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  State<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final RequestController requestController = Get.put(RequestController());
  final List<String> categories = ["Leave Request"];
  final List<String> types = [
    "Sick Leave",
    "Casual Leave",
    "Annual Leave",
    "Emergency Leave",
  ];
  final List<String> reasons = [
    "Medical Issue",
    "Family Function",
    "Personal Work",
    "Travel",
    "Other",
  ];

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
              color: Colors.white,
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
                "Add Leave Request",
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
        body: Obx(
              () => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Leave Request Information"),
                const SizedBox(height: 25),

                _buildInputField(
                  label: "Category",
                  hint: "Select category",
                  icon: Icons.category_outlined,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: requestController.selectedCategory?.value == ''
                            ? null
                            : requestController.selectedCategory?.value,
                        hint: Text(
                          "Select Category",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black54,
                        ),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins"
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          requestController.selectedCategory?.value = value ?? '';
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _buildInputField(
                  label: "Type",
                  hint: "Select type",
                  icon: Icons.format_list_bulleted_outlined,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: requestController.selectedType?.value == ''
                            ? null
                            : requestController.selectedType?.value,
                        hint: Text(
                          "Select Type",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black54,
                        ),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        items: types.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins"
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          requestController.selectedType?.value = value ?? '';
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _buildInputField(
                  label: "Reason",
                  hint: "Select reason",
                  icon: Icons.help_center_rounded,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: requestController.selectedReason?.value == ''
                            ? null
                            : requestController.selectedReason?.value,
                        hint: Text(
                          "Select Reason",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black54,
                        ),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        items: reasons.map((reason) {
                          return DropdownMenuItem(
                            value: reason,
                            child: Text(
                              reason,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins"
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          requestController.selectedReason?.value = value ?? '';
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
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
                onPressed: () {
                  if (requestController.selectedCategory?.value == '' ||
                      requestController.selectedCategory?.value == null) {
                    CustomSnackBar.show(
                      title: "Error",
                      message: "Please select category",
                      backgroundColor: Colors.redAccent.shade400,
                      textColor: Colors.black,
                      shadowColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      icon: Iconsax.close_square,
                    );
                    return;
                  }
                  if (requestController.selectedType?.value == '' ||
                      requestController.selectedType?.value == null) {
                    CustomSnackBar.show(
                      title: "Error",
                      message: "Please select type",
                      backgroundColor: Colors.redAccent.shade400,
                      textColor: Colors.black,
                      shadowColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      icon: Iconsax.close_square,
                    );
                    return;
                  }
                  if (requestController.selectedReason?.value == '' ||
                      requestController.selectedReason?.value == null) {
                    CustomSnackBar.show(
                      title: "Error",
                      message: "Please select reason",
                      backgroundColor: Colors.redAccent.shade400,
                      textColor: Colors.black,
                      shadowColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      icon: Iconsax.close_square,
                    );
                    return;
                  }
                  Get.to(
                        () => SubmitRequestScreen(
                      category: requestController.selectedCategory!.value,
                      type: requestController.selectedType!.value,
                      reason: requestController.selectedReason!.value,
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                    const SizedBox(width: 10),
                    const Text(
                      "Next",
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
        ),
      ),
    );
  }
}