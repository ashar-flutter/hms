import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  final Color color;
  final VoidCallback? isPress;
  final VoidCallback? onTap;
  final String title;
  final Icon icon;
  const DashboardCard({
    super.key,
    required this.color,
    this.isPress,
    this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTap: widget.isPress,
      onTapUp: (_) {
        setState(() => isPressed = false);
        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedScale(
        scale: isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 100,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.color,
                ),
                child: Center(child: widget.icon),
              ),
              Text(
                widget.title,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Color(0xFF10B981);
// const Color(0xFF1E3A8A)