import 'package:flutter/material.dart';

class RefreshFab extends StatefulWidget {
  final Future<void> Function() onRefresh;

  const RefreshFab({super.key, required this.onRefresh});

  @override
  State<RefreshFab> createState() => _RefreshFabState();
}

class _RefreshFabState extends State<RefreshFab>
    with SingleTickerProviderStateMixin {

  bool isLoading = false;

  Future<void> _handleTap() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      await widget.onRefresh();
    } catch (_) {}
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
            Colors.grey.shade100,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(8, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.grey.shade300.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(6, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.95),
            blurRadius: 12,
            offset: const Offset(-6, -6),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.7),
            blurRadius: 8,
            offset: const Offset(-3, -3),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: const Color(0xFF2563EB).withValues(alpha: 0.15),
          highlightColor: const Color(0xFF3B82F6).withValues(alpha: 0.08),
          child: Center(
            child: isLoading
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF1E40AF),
                ),
              ),
            )
                : Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF3B82F6),
                    const Color(0xFF2563EB),
                    const Color(0xFF1E40AF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}