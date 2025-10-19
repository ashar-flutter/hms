import 'package:flutter/material.dart';

class LeaveCard extends StatelessWidget {
  final String label;
  final String count;
  final IconData icon;
  final List<Color> gradient;

  const LeaveCard(BuildContext context, {
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final containerWidth = (width - 64) / 3;

    return Container(
      width: containerWidth,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 28,
                  fontFamily: "bold",
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style:  TextStyle(
                  color: Colors.white,
                  fontFamily: "poppins"
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

