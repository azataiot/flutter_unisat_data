import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/collection.dart';
import '../../data/repositories/entity_repository.dart';

import 'package:unisat_data/global/configs.dart' as app_config;
import '../../helpers/logging.dart';
import '../../routes/app_routes.dart';
import 'selection_state.dart';

class SelectionController extends GetxController {
  final SelectionState state = SelectionState();
  IEntityRepository repository = Get.find();
  final storage = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    logger.d("[Azt::SelectionController] onInit called");
    logger.d("[Azt::SelectionController] getting collections");
    state.isLoading = true;
    update();
    var collections = await getCollections();
    state.isLoading = false;
    update();
    logger.d("[Azt::SelectionController] onInit collections $collections");
    if (collections != null) {
      state.collections = collections;
      state.isConnecting = false;
      logger.d(
          "[Azt::SelectionController] onInit collections length on state ${state.collections!.length}");
      update();
    } else {
      logger.w("Getting records failed!");
      state.isConnecting = false;
      state.isError = true;
      update();
    }
  }

  handleSelectSource(String source) async {
    logger.d("[Azt::HomeController] onInit handleSelectSource $source");
    await storage.write(app_config.Storage.currentSource, source);
    await storage.write(app_config.Storage.firstRun, false);
    update();
    Get.offAllNamed(AppRoutes.home);
  }

  getCollections() async {
    logger.i('get collections called!');
    dynamic collections = await repository.getCollections();
    if (collections != null) {
      List<Collection> collectionsList = List.from(collections);
      return collectionsList;
    }
    {
      logger.w("[Azt::ApiService] collections is null");
    }
  }
}
