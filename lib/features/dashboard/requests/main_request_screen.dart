import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/requests/add_request_screen.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/snackbar/custom_snackbar.dart';

class MainRequestScreen extends StatefulWidget {
  const MainRequestScreen({super.key});

  @override
  State<MainRequestScreen> createState() => _MainRequestScreenState();
}

class _MainRequestScreenState extends State<MainRequestScreen> {
  bool _isChecked = false;
  bool _showInitialSnackbar = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showInitialSnackbar) {
        _showInitialSnackbar = false;
        _showTopSnackbar(
          "Please read leave policy and check terms",
          Colors.blue.shade800,
          Icons.info_outline,
        );
      }
    });
  }

  void _showTopSnackbar(String message, Color backgroundColor, IconData icon) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
        borderRadius: 12,
        icon: Icon(icon, color: Colors.white, size: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        messageText: Text(
          message,
          style: TextStyle(
            fontFamily: "poppins",
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _handleAddRequest() {
    if (!_isChecked) {
      CustomSnackBar.show(
        title: "Error",
        message: "Please read and accept the leave policy to proceed",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return;
    }
    Get.to(AddRequestScreen());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(size: 18, Icons.arrow_back),
            ),
            centerTitle: true,
            title: const Text(
              "Apply",
              style: TextStyle(
                fontFamily: "bold",
                fontSize: 15,
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
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "LA Digital Agency - Leave Policy",
                      style: TextStyle(
                        fontFamily: "bold",
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "At LA Digital Agency, we believe in maintaining a healthy work-life balance while ensuring smooth project delivery. Our leave policy is designed to provide flexibility while maintaining professional standards.\n\n"
                          "📋 Standard Leave Entitlements:\n"
                          "• Weekly Limit: 1 leave per week to ensure consistent workflow\n"
                          "• Monthly Quota: Maximum 3 leaves per month for planned time off\n"
                          "• Annual Allocation: Total 36 leaves per year for comprehensive coverage\n"
                          "• Weekend Policy: Sunday is already designated as weekly off\n"
                          "• Emergency Leaves: Additional emergency leave option available for genuine cases\n\n"
                          "💼 Professional Guidelines:\n"
                          "• Leaves should be applied in advance for proper planning\n"
                          "• Emergency leaves require proper documentation\n"
                          "• Team coordination is essential during leave periods\n"
                          "• Project deadlines must be considered while planning leaves\n\n"
                          "We trust our team members to use leaves responsibly while maintaining their professional commitments to LA Digital Agency.",
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                          activeColor: Color(0xFF6A11CB),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "I have read and understood the LA Digital Agency leave policy and agree to follow these guidelines",
                            style: TextStyle(
                              fontFamily: "poppins",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppBar().preferredSize.height),
                  ],
                ),
              ),
              SizedBox(height: AppBar().preferredSize.height),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 25,
                spreadRadius: 4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 55,
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
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
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
                onPressed: _handleAddRequest,
                child: const Text(
                  "Add Request",
                  style: TextStyle(
                    fontFamily: "bold",
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}