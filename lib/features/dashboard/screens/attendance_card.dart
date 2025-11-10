import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../attendance/attendance_status_controller.dart';
import '../attendance/attendance_screen.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SecureAttendanceController(), permanent: true);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Color(0xFF5038ED),
            Color(0xFF38ED7D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Today's Status",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "bold",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "bold",
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Check In",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: "bold",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.checkInTime.value != null
                            ? controller.formatDateTime(controller.checkInTime.value)
                            : "--:--:--",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontFamily: "poppins",
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Check Out",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: "bold",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.checkOutTime.value != null
                            ? controller.formatDateTime(controller.checkOutTime.value)
                            : "--:--:--",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontFamily: "poppins",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 10),

          Obx(() {
            return controller.isCheckedIn.value
                ? Column(
              children: [
                const Text(
                  "Working Time",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "bold",
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      controller.formatDuration(controller.workDuration.value),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "bold",
                        color: Color(0xFF5038ED),
                      ),
                    ),
                  ),
                ),
              ],
            )
                : InkWell(
              onTap: () {
                Get.to(() => const AttendanceScreen());
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFFFFFFF),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Mark Attendance",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "bold",
                      color: Color(0xFF5038ED),
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}