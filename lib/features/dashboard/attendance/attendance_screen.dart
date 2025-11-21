import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/core/colors/gradients.dart';
import 'package:hr_flow/features/dashboard/attendance/position/position.dart';
import 'package:hr_flow/features/dashboard/attendance/service/secure_attendance_service.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../../../core/services/attendance_service.dart';
import '../../../core/snackbar/custom_snackbar.dart';
import 'attendance_status_controller.dart';
import 'controller/check_controller.dart';
import 'local_storage/attendance_controller.dart';
import 'map/my_map.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late AttendanceController _controller;
  bool isCheck = true;
  Duration _workDuration = Duration.zero;
  Timer? _workTimer;
  bool isOnBreak = false;
  Duration _breakDuration = Duration.zero;
  Timer? _breakTimer;
  DateTime? _breakStartTime;

  // 🆕 TOTAL BREAK TRACK KARNE KE LIYE
  Duration _totalBreakDuration = Duration.zero;

  final LatLng _fixedPosition = const LatLng(31.4686680, 74.3122560);
  late AnimationController controller;
  late Animation<double> _animation;
  String? _checkInDate;
  String? _checkInTime;
  String? _checkOutTime;
  LatLng? _currentPosition;
  late AttendanceService attendanceService;
  late CheckController _checkController;
  StreamSubscription<LatLng>? _positionStreamSub;
  final SecureAttendanceService _secureService = SecureAttendanceService();

  @override
  void initState() {
    super.initState();
    _controller = AttendanceController();
    _checkController = CheckController();
    attendanceService = AttendanceService(fixedPosition: _fixedPosition);
    Get.put(SecureAttendanceController(), permanent: true);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0,
      end: 12,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    _restorePreviousState();
    attendanceService.checkPermission().then((granted) {
      if (granted) {
        _positionStreamSub = attendanceService.getPositionStream().listen((
          pos,
        ) {
          if (mounted) {
            setState(() {
              _currentPosition = pos;
            });
          }
        });
      }
    });
  }

  Future<void> _restorePreviousState() async {
    await _controller.restoreState();
    if (_controller.isCheckedIn) {
      if (mounted) {
        setState(() {
          isCheck = false;
          _checkInDate = _controller.checkInDate;
          _checkInTime = _controller.checkInTimeString;
          _workDuration = _controller.elapsed;
        });
      }
      await _restoreBreakState();
      _workTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() => _workDuration += const Duration(seconds: 1));
        }
      });
    }
  }

  Future<void> _restoreBreakState() async {
    try {
      final isOnBreakStored = await _secureService.isOnBreak();
      final breakStartTimeStored = await _secureService.getBreakStartTime();
      final totalBreakStored = await _secureService
          .getTotalBreakDuration(); // 🆕 TOTAL BREAK LOAD

      if (mounted) {
        setState(() {
          _totalBreakDuration = totalBreakStored; // 🆕 TOTAL BREAK RESTORE
        });
      }

      if (isOnBreakStored && breakStartTimeStored != null) {
        if (mounted) {
          setState(() {
            isOnBreak = true;
            _breakStartTime = breakStartTimeStored;
            _breakDuration = DateTime.now().difference(breakStartTimeStored);
          });
        }

        _breakTimer?.cancel();
        _breakTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) {
            setState(() {
              _breakDuration = DateTime.now().difference(_breakStartTime!);
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            isOnBreak = false;
            _breakDuration = _totalBreakDuration; // 🆕 TOTAL BREAK SHOW
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isOnBreak = false;
          _breakDuration = _totalBreakDuration; // 🆕 TOTAL BREAK SHOW
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
    _workTimer?.cancel();
    _breakTimer?.cancel();
    _positionStreamSub?.cancel();
    super.dispose();
  }

  bool get _canCheckIn {
    if (_currentPosition == null) return false;
    return attendanceService.isWithinAllowedArea(_currentPosition!);
  }

  void _toggleCheck() {
    if (!_canCheckIn) {
      CustomSnackBar.show(
        title: "Error",
        message: "You are outside the allowed area!",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return;
    }
    if (!mounted) return;
    final secureController = Get.find<SecureAttendanceController>();
    setState(() {
      isCheck = !isCheck;
      if (!isCheck) {
        _checkInDate = DateFormat('EEE, MMM d, yyyy').format(DateTime.now());
        _checkInTime = DateFormat('hh:mm:ss a').format(DateTime.now());
        _workDuration = Duration.zero;
        _controller.checkIn();
        secureController.checkIn();
        _workTimer?.cancel();
        _workTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) {
            setState(() => _workDuration += const Duration(seconds: 1));
          }
        });
        if (_currentPosition != null) {
          _checkController.recordCheck(
            isCheckIn: true,
            workDuration: _workDuration,
            breakDuration: _breakDuration,
            currentPosition: _currentPosition!,
          );
        }
      } else {
        _workTimer?.cancel();
        _checkOutTime = DateFormat('hh:mm:ss a').format(DateTime.now());

        // 🎯 FINAL BREAK CALCULATION
        Duration finalBreakDuration;
        if (isOnBreak) {
          // Agar break chalti hue checkout kiya
          finalBreakDuration = _totalBreakDuration + _breakDuration;
        } else {
          // Agar break end karne ke baad checkout kiya
          finalBreakDuration = _totalBreakDuration;
        }

        _controller.checkOut();
        secureController.checkOut();
        _controller.saveBreakState(isOnBreak, finalBreakDuration);
        if (_currentPosition != null) {
          _checkController.recordCheck(
            isCheckIn: false,
            workDuration: _workDuration,
            breakDuration: finalBreakDuration, // 🎯 TOTAL BREAK DURATION
            currentPosition: _currentPosition!,
            existingCheckInTime: _checkInTime,
          );
        }

        // 🎯 RESET FOR NEXT DAY
        _totalBreakDuration = Duration.zero;
        _secureService.clearTotalBreak();
      }
    });
  }

  Future<void> _toggleBreak() async {
    if (!_canCheckIn) {
      CustomSnackBar.show(
        title: "Error",
        message: "You are outside the allowed area! Break cannot start.",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return;
    }
    if (!mounted) return;

    final wasOnBreak = isOnBreak;

    setState(() => isOnBreak = !isOnBreak);

    if (!wasOnBreak && isOnBreak) {
      // BREAK START
      _breakStartTime = DateTime.now();
      await _secureService.saveBreakStartTime(_breakStartTime!);
      await _secureService.saveBreakStatus(true);
      _breakTimer?.cancel();
      _breakTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            _breakDuration = DateTime.now().difference(_breakStartTime!);
          });
        }
      });

      if (_currentPosition != null && _checkInDate != null) {
        await _checkController.recordBreak(
          isOnBreak: true,
          workDuration: _workDuration,
          breakDuration: _breakDuration,
          currentPosition: _currentPosition!,
          date: _checkInDate!,
          checkInTime: _checkInTime,
          checkOutTime: _checkOutTime,
        );
      }
    } else if (wasOnBreak && !isOnBreak) {
      // BREAK END - 🎯 YAHAN FIX KIA HAI
      _breakTimer?.cancel();
      final currentBreakDuration = DateTime.now().difference(_breakStartTime!);

      // 🎯 CRITICAL FIX: TOTAL BREAK UPDATE KARO
      _totalBreakDuration += currentBreakDuration;

      // 🎯 SECURE STORAGE MEIN SAVE KARO
      await _secureService.saveTotalBreakDuration(_totalBreakDuration);

      await _secureService.saveBreakStatus(false);
      await _secureService.clearBreakData();

      if (_currentPosition != null && _checkInDate != null) {
        await _checkController.recordBreak(
          isOnBreak: false,
          workDuration: _workDuration,
          breakDuration: currentBreakDuration, // 🎯 CURRENT BREAK TIME
          currentPosition: _currentPosition!,
          date: _checkInDate!,
          checkInTime: _checkInTime,
          checkOutTime: _checkOutTime,
        );
      }
    }

    await _controller.saveBreakState(isOnBreak, _breakDuration);
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Stack(
          children: [
            SizedBox(
              height: screenHeight * 0.6,
              width: double.infinity,
              child: Custom_Map(fixedPosition: _fixedPosition),
            ),
            position(screenHeight: screenHeight, animation: _animation),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  height: screenHeight * 0.6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 25,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Today's Status",
                          style: TextStyle(
                            fontFamily: "bold",
                            fontSize: 22,
                            color: Colors.black87,
                            letterSpacing: 1,
                          ),
                        ),
                        if (_checkInDate != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            _checkInDate!,
                            style: const TextStyle(
                              fontFamily: "poppins",
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _statusBox(
                              title: "Check In",
                              time: _checkInTime,
                              active: _checkInTime != null,
                              color: Colors.green.shade800,
                            ),
                            const SizedBox(width: 20),
                            _statusBox(
                              title: "Check Out",
                              time: _checkOutTime,
                              active: _checkOutTime != null,
                              color: Colors.red.shade800,
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Text(
                          _formatDuration(_workDuration),
                          style: const TextStyle(
                            fontFamily: "poppins",
                            fontSize: 24,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.grey, blurRadius: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Working hours today",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontFamily: "bold",
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF1565C0).withValues(alpha: 0.6),
                                blurRadius: 15,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Column(
                            children: [
                              const Text(
                                "Break",
                                style: TextStyle(
                                  fontFamily: "bold",
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatDuration(_breakDuration),
                                style: const TextStyle(
                                  fontFamily: "bold",
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _toggleBreak,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF42A5F5),
                                        Color(0xFF1565C0),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isOnBreak ? "End Break" : "Start Break",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "poppins",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: isCheck
                                  ? AMGradients.checkInGradient
                                  : AMGradients.checkOutGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: _toggleCheck,
                            borderRadius: BorderRadius.circular(25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isCheck ? Iconsax.clock : Iconsax.logout_1,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isCheck ? "Check In" : "Check Out",
                                  style: const TextStyle(
                                    fontFamily: "bold",
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBox({
    required String title,
    String? time,
    required bool active,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 130,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? color : Colors.grey.shade400,
          width: 2,
        ),
        boxShadow: [
          if (active)
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 12,
              spreadRadius: 1,
            ),
        ],
        color: Colors.grey.shade100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            active ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: active ? color : Colors.grey.shade700,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: "bold",
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          if (time != null)
            Text(
              time,
              style: const TextStyle(
                fontFamily: "poppins",
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}
