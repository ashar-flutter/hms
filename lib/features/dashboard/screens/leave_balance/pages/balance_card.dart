import 'package:flutter/material.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
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
      child: Transform.scale(
        scale: _scale,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          height: 54,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFEFECFD),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 25,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 15),
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 25,
                    color: Colors.deepPurple.shade900,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Leave Balance",
                    style: TextStyle(
                      color: Colors.deepPurple.shade900,
                      fontFamily: "bold",
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 15),
                  Text(
                    "24/24",
                    style: TextStyle(
                      color: Colors.deepPurple.shade900,
                      fontFamily: "bold",
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: Colors.deepPurple.shade900,
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
