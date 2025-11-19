import 'package:get/get.dart';
import 'report_controller.dart';

class ReportBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportController());
  }
}