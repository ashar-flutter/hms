import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/requests/request_status_screen.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/snackbar/custom_snackbar.dart';
import 'controller/status_controller.dart';
import 'controller/upload_controller.dart';
import 'helper/dotted_box.dart';
import 'helper/date_picker_helper.dart';
import 'package:intl/intl.dart';
import 'helper/request_checks.dart';
import 'model/request_model.dart';

class SubmitRequestScreen extends StatefulWidget {
  final String category;
  final String type;
  final String reason;

  const SubmitRequestScreen({
    super.key,
    required this.category,
    required this.type,
    required this.reason,
  });

  @override
  State<SubmitRequestScreen> createState() => _SubmitRequestScreenState();
}

class _SubmitRequestScreenState extends State<SubmitRequestScreen>
    with SingleTickerProviderStateMixin {
  String selectedOption = "";
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _descController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  late RequestStatusController statusController;
  late UploadController uploadController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    statusController = Get.put(RequestStatusController(), permanent: true);
    uploadController = Get.put(UploadController());
  }

  @override
  void dispose() {
    _controller.dispose();
    _descController.dispose();
    super.dispose();
  }

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
    _controller.forward(from: 0);
  }

  String formatDate(DateTime? date) {
    if (date == null) return "DD/MM/YYYY";
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: AppBar().preferredSize.height / 2),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Select days for leave",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontFamily: "poppins",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () => selectOption("one"),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: selectedOption == "one" ? 10 : 0,
                            width: selectedOption == "one" ? 10 : 0,
                            decoration: BoxDecoration(
                              color: selectedOption == "one"
                                  ? Colors.blue.shade900
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "For one day",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "bold",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => selectOption("multiple"),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: selectedOption == "multiple" ? 10 : 0,
                          width: selectedOption == "multiple" ? 10 : 0,
                          decoration: BoxDecoration(
                            color: selectedOption == "multiple"
                                ? Colors.blue.shade800
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  const Text(
                    "For multiple day’s",
                    style: TextStyle(
                      fontFamily: "bold",
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // From Date Picker
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "From Date",
                    style: TextStyle(fontFamily: "bold", color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        formatDate(fromDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "poppins",
                          color: fromDate == null
                              ? Colors.grey.shade500
                              : Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        onPressed: () async {
                          final picked = await DatePickerHelper.pickFromDate(
                            context,
                          );
                          if (picked != null) {
                            setState(() {
                              fromDate = picked;
                              if (toDate != null && toDate!.isBefore(fromDate!)) {
                                toDate = null;
                              }
                            });
                          }
                        },
                        icon: Icon(
                          Icons.calendar_month,
                          color: Colors.deepPurple.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // To Date Picker
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "To Date",
                    style: TextStyle(fontFamily: "bold", color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        formatDate(toDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "poppins",
                          color: toDate == null
                              ? Colors.grey.shade500
                              : Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        onPressed: () async {
                          final picked = await DatePickerHelper.pickToDate(
                            context,
                            fromDate,
                          );
                          if (picked != null) setState(() => toDate = picked);
                        },
                        icon: Icon(
                          Icons.calendar_month,
                          color: Colors.deepPurple.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Description
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Description",
                    style: TextStyle(fontFamily: "bold", color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
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
                  child: TextFormField(
                    controller: _descController,
                    maxLines: 5,
                    cursorColor: Colors.deepPurple.shade900,
                    decoration: InputDecoration(
                      hintText: "Write your description here...",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: "poppins",
                        color: Colors.grey.shade500,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // Attachments
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Attachments",
                    style: TextStyle(fontFamily: "bold", color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Obx(() {
                final file = uploadController.selectedFile.value;
                return GestureDetector(
                  onTap: () => uploadController.uploadFile(),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    padding: const EdgeInsets.all(20),
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey, width: 2),
                      color: Colors.white,
                    ),
                    child: DottedBorderBox(
                      file: file,
                      controller: uploadController,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 200),
            ],
          ),
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
              final file = uploadController.selectedFile.value;
              final isValid = ValidationHelper.validateForm(
                selectedOption: selectedOption,
                fromDate: fromDate,
                toDate: toDate,
                description: _descController.text.trim(),
                file: file,
              );

              if (isValid) {
                statusController.addRequest(
                  RequestModel(
                    category: widget.category,
                    type: widget.type,
                    reason: widget.reason,
                    description: _descController.text.trim(),
                    filePath: file?.path,
                    fromDate: fromDate,
                    toDate: toDate,
                  ),
                );
                Get.offAll(() => RequestStatusScreen());
                CustomSnackBar.show(
                  title: "Success",
                  message: "Request submitted successfully!",
                  backgroundColor: Colors.greenAccent.shade400,
                  textColor: Colors.black,
                  shadowColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  icon: Iconsax.tick_square,
                );
              }
            },
            child: const Text(
              "Submit Request",
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
