import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unisat_data/global/configs.dart' as app_config;
import '../../data/repositories/repository_result.dart';
import '../../data/services/api_service.dart';
import '../../helpers/logging.dart';
import 'home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();
  final storage = GetStorage();
  ApiService apiService = Get.find();

  @override
  void onInit() async {
    await apiService.updateData();
    await Future.delayed(const Duration(seconds: 2), () {
      logger.i("Home OnInit called");
      state.isLoading = false;
      state.isConnecting = true;
      update();
    });
    var stored = await storage.read(app_config.Storage.dataResult);
    logger.i("[Azt] Home Controller onInit get stored result: $stored");
    if (stored == null) {
      await Future.delayed(const Duration(seconds: 2), () async {
        // wait two seconds and retry
        stored = await storage.read(app_config.Storage.dataResult);
        logger.i(
            "[Azt] Home Controller onInit get stored result a second time: $stored");
        update();
      });
    }

    Result result = stored;
    logger.i("[Azt] Home Controller onInit called with result: $result");
    state.result = result;
    await Future.delayed(const Duration(seconds: 1), () async {
      state.isConnecting = false;
      update();
    });
    super.onInit();
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
