import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unisat_data/data/repositories/repositories.dart';
import '../../helpers/logging.dart';
import 'home_state.dart';

enum VarType {
  temperature,
  humidity,
  pressure,
  pm10,
  pm25,
}

class HomeController extends GetxController {
  final HomeState state = HomeState();
  final storage = GetStorage();
  IEntityRepository repository = Get.find();

  late Timer timer;

  @override
  void onInit() async {
    logger.d("[Azt::HomeController] onInit called");
    super.onInit();
    state.isLoading = true;

    // first time data update
    updateRecords();
    //
    Future.delayed(const Duration(seconds: 1), () {
      state.isLoading = false;
      state.isConnecting = true;
      update();
    });

    // setup the timer
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      logger.i('ApiService update data! $t');
      updateRecords();
    });
  }

  updateRecords() async {
    logger.i('Home Controller update records called!');
    dynamic records = await repository.getRecords();
    if (records != null) {
      // we got records and that is not null
      state.records = records;
      state.isConnecting = false;
      update();
    } else {
      logger.w("Getting records failed!");
      state.isConnecting = false;
      state.isError = true;
      update();
    }
  }

  @override
  Future<void> onClose() async {
    logger.i('HomeController close!');
    timer.cancel();
    super.onClose();
  }

  double getVarMin({required VarType varType}) {
    List<double> allVars = [];
    state.records?.forEach((record) {
      switch (varType) {
        case VarType.temperature:
          allVars.add(record.temperature ?? 0.0);
          break;
        case VarType.humidity:
          allVars.add(record.humidity ?? 0.0);
          break;
        case VarType.pressure:
          allVars.add(record.pressure ?? 0.0);
          break;
        case VarType.pm10:
          allVars.add(record.pm10 ?? 0.0);
          break;
        case VarType.pm25:
          allVars.add(record.pm25 ?? 0.0);
          break;
      }
    });
    return allVars.reduce(min);
  }

  double getVarMax({required VarType varType}) {
    List<double> allVars = [];
    state.records?.forEach((record) {
      switch (varType) {
        case VarType.temperature:
          allVars.add(record.temperature ?? 100.0);
          break;
        case VarType.humidity:
          allVars.add(record.humidity ?? 100.0);
          break;
        case VarType.pressure:
          allVars.add(record.pressure ?? 2000.0);
          break;
        case VarType.pm10:
          allVars.add(record.pm10 ?? 100.0);
          break;
        case VarType.pm25:
          allVars.add(record.pm25 ?? 100.0);
          break;
      }
    });
    return allVars.reduce(max);
  }
}

class HomeTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void onInit() {
    // TabController
    super.onInit();
    controller = TabController(vsync: this, length: 5);
    //
  }
}
