import 'package:flutter/material.dart';

class PayBar extends StatelessWidget {
  final bool isPerformanceSelected;
  final Function(bool) onTabChanged;

  const PayBar({
    super.key,
    required this.isPerformanceSelected,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(true),
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: isPerformanceSelected ? Color(0xFF5038ED) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Payslips",
                  style: TextStyle(
                    color: isPerformanceSelected ? Colors.white : Colors.black,
                    fontFamily: "bold",
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(false),
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: isPerformanceSelected ? Colors.white : Color(0xFF5038ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Current Salary",
                  style: TextStyle(
                    color: isPerformanceSelected ? Colors.black : Colors.white,
                    fontFamily: "bold",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
