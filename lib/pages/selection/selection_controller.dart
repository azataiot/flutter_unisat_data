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
    logger.d("[Azt::SelectionController] onInit called");
    logger.d("[Azt::SelectionController] getting collections");
    var collections = await getCollections();
    logger.d("[Azt::HomeController] onInit collections $collections");
    if (collections != null) {
      state.collections = collections;
      logger.d(
          "[Azt::HomeController] onInit collections length on state ${state.collections!.length}");
      update();
    }
    update();
    super.onInit();
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
