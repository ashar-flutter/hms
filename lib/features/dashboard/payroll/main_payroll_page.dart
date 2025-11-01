import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/dashboard/payroll/widgets/pay_bar.dart';

class MainPayrollPage extends StatefulWidget {
  const MainPayrollPage({super.key});

  @override
  State<MainPayrollPage> createState() => _MainPayrollPageState();
}

class _MainPayrollPageState extends State<MainPayrollPage> {
  bool isPerformanceSelected = true;

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
            "Payroll & Payslip",
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 16,
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
      body: Column(
        children: [
          SizedBox(height: AppBar().preferredSize.height/2,),
          PayBar(
            isPerformanceSelected: isPerformanceSelected,
            onTabChanged: (val) {
              setState(() {
                isPerformanceSelected = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
