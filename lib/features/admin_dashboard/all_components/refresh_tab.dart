import 'package:flutter/material.dart';

class RefreshFab extends StatefulWidget {
  final Future<void> Function() onRefresh;

  const RefreshFab({super.key, required this.onRefresh});

  @override
  State<RefreshFab> createState() => _RefreshFabState();
}

class _RefreshFabState extends State<RefreshFab> {
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
    return FloatingActionButton(
      onPressed: _handleTap,
      backgroundColor: Colors.white,
      elevation: 4,
      highlightElevation: 8,
      shape: const CircleBorder(),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: isLoading
            ? Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.green,
            ),
          ),
        )
            : Icon(
          Icons.refresh,
          color: Colors.grey.shade700,
          size: 24,
        ),
      ),
    );
  }
}