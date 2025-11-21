import 'package:flutter/material.dart';
import 'package:get/get.dart';

class position extends StatelessWidget {
  const position({
    super.key,
    required this.screenHeight,
    required Animation<double> animation,
  }) : _animation = animation;

  final double screenHeight;
  final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🆕 BACK BUTTON - Top Left Corner
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87,
                size: 20,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),

        // Original Location Pin (Same as before)
        Positioned(
          top: screenHeight * 0.25 - 30,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_animation.value),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amberAccent.withValues(alpha: 0.15),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.26),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF8B0000),
                        size: 40,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
