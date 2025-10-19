import 'package:get/get.dart';
import '../model/request_model.dart';

class RequestStatusController extends GetxController {
  RxList<RequestModel> requests = <RequestModel>[].obs;

  void addRequest(RequestModel request) {
    requests.add(request);
  }
}
