import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unisat_data/global/configs.dart' as app_config;
import '../../data/repositories/repository_result.dart';
import '../../helpers/logging.dart';
import 'home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();
  final storage = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(const Duration(seconds: 2), () {
      logger.i("Home OnInit called");
      state.isLoading = false;
      state.isConnecting = true;
      update();
    });
    await Future.delayed(const Duration(seconds: 2), () async {
      var stored = await storage.read(app_config.Storage.dataResult);
      logger.i("[Azt] Home Controller onInit called with result: $stored");
      Result result = Result.fromJson(stored);
      logger.i("[Azt] Home Controller onInit called with result: $result");
      state.result = result;
      state.isConnecting = false;
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
