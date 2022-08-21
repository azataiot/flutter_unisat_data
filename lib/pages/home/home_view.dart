import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:unisat_data/pages/home/home_state.dart';
import 'package:unisat_data/widgets/svg/azt_svg_logo.dart';
import 'home_controller.dart';

class HomePage extends GetResponsiveView {
  @override
  final controller = Get.find<HomeController>();
  final state = Get.find<HomeController>().state;

  HomePage({Key? key}) : super(key: key);

  @override
  Widget phone() {
    return HomeScaffold(
      state: state,
      controller: controller,
      body: const Center(),
    );
  }

  @override
  Widget tablet() {
    return HomeScaffold(
      state: state,
      controller: controller,
      body: const Center(),
    );
  }

  @override
  Widget desktop() {
    return HomeScaffold(
      state: state,
      controller: controller,
      body: const Center(),
    );
  }
}

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({
    Key? key,
    required this.state,
    required this.controller,
    required this.body,
  }) : super(key: key);

  final HomeState state;
  final HomeController controller;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: AztSvgLogoText(
          svgAsset: 'assets/logo/logo-unisat.svg',
          spaceBetweenLogoAndText: 6.0,
          logoText: 'app_name'.tr,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<HomeController>(builder: (controller) {
          if (state.isLoading!) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 44),
                  Text("Loading settings...".tr),
                ],
              ),
            );
          } else if (state.isConnecting!) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 44),
                  Text("Connecting UniSat Data Providers...".tr),
                ],
              ),
            );
          } else if (state.isError!) {
            return Center(
              child: Text("Can not connect to the server.".tr),
            );
          } else {
            // everything is ok, data already loaded.
            return body;
          }
        }),
      ),
    );
  }
}
