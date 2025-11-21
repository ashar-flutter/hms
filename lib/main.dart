import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_flow/features/splash/splash_screen.dart';
import 'features/Announce/employee_announce_controller.dart';
import 'features/admin_dashboard/screens/reports/report_controller.dart';
import 'features/dashboard/documents/service/document_count_service.dart';
import 'features/dashboard/documents/service/user_document_status_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  Get.put(DocumentCountService(), permanent: true);
  Get.put(UserDocumentStatusService(), permanent: true);
  Get.put(ReportController());
  Get.put(EmployeeAnnounceController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
