import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unisat_data/data/repositories/repositories.dart';
import 'package:unisat_data/global/configs.dart' as app_config;
import '../../helpers/logging.dart';

class ApiService extends GetxService {
  ApiService({required this.repository});

  late Timer timer;
  final IEntityRepository repository;
  final storage = GetStorage();

  Future<ApiService> init() async {
    logger.i('$runtimeType delays 1 sec');
    logger.i('Initializing ApiService');
    return this;
  }

  @override
  Future<void> onInit() async {
    logger.i('ApiService ready!');
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      logger.i('ApiService update data! $t');
      updateData();
    });
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    logger.i('ApiService close!');
    timer.cancel();
    super.onClose();
  }

  Future<void> updateData() async {
    logger.i('update called!');
    Result result = await repository.getEntities();
    logger.i(result.statusText);
    storage.write(app_config.Storage.dataResult, result);
  }
}
