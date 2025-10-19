import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class CustomCard extends StatefulWidget {
  final String? label;
  final String? iconName;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    this.label,
    this.iconName,
    this.gradientColors,
    this.onTap,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _isPressed ? 0.94 : 1.0,
        curve: Curves.easeOut,
        child: Container(
          width: 105,
          height: 105,
          decoration: BoxDecoration(

            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE8F1FF), // very light blue top
                Color(0xFFD1E4FF), // soft sky blue middle
                Color(0xFFB8D4FF), // pleasant light blue base
              ],
            ),

            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 25,
                spreadRadius: 2,
                offset: const Offset(5, 8),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.9),
                blurRadius: 10,
                spreadRadius: -5,
                offset: const Offset(-5, -5),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.iconName != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors:
                          widget.gradientColors ??
                          [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (widget.gradientColors?[0] ??
                                    const Color(0xFF6A11CB))
                                .withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Iconify(
                    widget.iconName!,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              if (widget.label != null) ...[
                const SizedBox(height: 10),
                Text(
                  widget.label!,
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
