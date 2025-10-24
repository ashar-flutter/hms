import 'package:flutter/material.dart';
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
    return Positioned(
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
    );
  }
}
