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
            "Add New Request",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "bold",
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
      body: Obx(
            () => Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height / 2),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Category",
                  style: TextStyle(color: Colors.black, fontFamily: "bold"),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: requestController.selectedCategory?.value == ''
                      ? null
                      : requestController.selectedCategory?.value,
                  hint: Text(
                    "Select Category",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: "poppins",
                    ),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                  ),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(20),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(fontFamily: "poppins"),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    requestController.selectedCategory?.value = value ?? '';
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Type",
                  style: TextStyle(color: Colors.black, fontFamily: "bold"),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: requestController.selectedType?.value == ''
                      ? null
                      : requestController.selectedType?.value,
                  hint: Text(
                    "Select Type",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: "poppins",
                    ),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                  ),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(20),
                  items: types.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type,
                        style: const TextStyle(fontFamily: "poppins"),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    requestController.selectedType?.value = value ?? '';
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Reason",
                  style: TextStyle(color: Colors.black, fontFamily: "bold"),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: requestController.selectedReason?.value == ''
                      ? null
                      : requestController.selectedReason?.value,
                  hint: Text(
                    "Select Reason",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: "poppins",
                    ),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                  ),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(20),
                  items: reasons.map((reason) {
                    return DropdownMenuItem(
                      value: reason,
                      child: Text(
                        reason,
                        style: const TextStyle(fontFamily: "poppins"),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    requestController.selectedReason?.value = value ?? '';
                  },
                ),
              ),
            ),
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
            child: const Text(
              "Next",
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