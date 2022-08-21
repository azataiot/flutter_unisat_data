import 'package:get/get.dart';

import '../../helpers/logging.dart';
import 'home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();

  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(const Duration(seconds: 2), () {
      logger.i("Home OnInit called");
      state.isLoading = false;
      state.isConnecting = true;
      update();
    });
  }

  @override
  void onReady() {
    logger.d("[Azt] Home on ready called.");
    super.onReady();
  }

  @override
  void onClose() {
    logger.d("[Azt] Home on close called.");
    super.onClose();
  }
}
