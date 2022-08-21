import 'package:flutter/cupertino.dart';
import 'package:unisat_data/data/models/models.dart';
import 'package:unisat_data/data/providers/providers.dart';
import 'package:unisat_data/data/repositories/repositories.dart';
import 'package:get/get.dart';
import '../../helpers/logging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unisat_data/global/configs.dart' as app_config;

abstract class IEntityRepository {
  // repository can return null if anything wrong from the server or if we have blank fields
  Future<Result<Entity>> getEntities();
}

class EntityRepository implements IEntityRepository {
  EntityRepository({required this.provider});

  final storage = GetStorage();
  final IEntityProvider provider;

  @override
  Future<Result<Entity>> getEntities() async {
    logger.i("[Azt] IEntityRepository.getEntities called");
    String currentSource = storage.read(app_config.Storage.currentSource) ?? "";
    // maybe we do not have any data providers
    if (currentSource.isEmpty) {
      return Result(
        ok: false,
        statusText:
            "No data providers online at this moment, please try again later.",
      );
    }
    // we have data providers available
    Response response = await provider.getEntities(currentSource);
    logger.i(
        "[Azt] IEntityRepository.getEntities.getEntities called with result: $response");
    return Result(ok: true);
  }
}
