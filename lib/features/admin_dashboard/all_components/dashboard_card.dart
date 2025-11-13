import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardCard extends StatefulWidget {
  final String imagePath;
  final String text;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.text,
    required this.imagePath,
    this.onTap,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
    )..addListener(() {
      setState(() {
        _scale = _controller!.value;
      });
    });
    _controller!.value = 1.0;
  }

  void _onTapDown(TapDownDetails details) {
    _controller?.reverse(from: 1.0);
  }

  void _onTapUp(TapUpDetails details) {
    _controller?.forward(from: 0.97);
  }

  void _onTapCancel() {
    _controller?.forward(from: 0.97);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 25,
                  spreadRadius: 1,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF8F8F8),
                          Color(0xFFE8E8E8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: Offset(-2, -2),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      widget.imagePath,
                      height: 45,
                      width: 45,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 12.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}