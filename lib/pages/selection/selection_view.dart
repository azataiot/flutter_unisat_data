import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisat_data/pages/selection/selection_state.dart';

import '../../widgets/svg/azt_svg_logo.dart';
import '../home/home_view.dart';
import 'selection_controller.dart';

class SelectionPage extends GetResponsiveView<SelectionController> {
  @override
  final controller = Get.find<SelectionController>();
  final state = Get.find<SelectionController>().state;

  SelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AztSvgLogoText(
          svgAsset: 'assets/logo/logo-unisat.svg',
          spaceBetweenLogoAndText: 6.0,
          logoText: 'app_name'.tr,
        ),
      ),
      body: GetBuilder<SelectionController>(builder: (controller) {
        if (state.isError!) {
          return SelectionStatus(
              statusType: HomeStatusType.error,
              controller: controller,
              state: state);
        } else if (state.isLoading!) {
          return SelectionStatus(
              statusType: HomeStatusType.loading,
              controller: controller,
              state: state);
        } else if (state.isConnecting!) {
          return SelectionStatus(
              statusType: HomeStatusType.connecting,
              controller: controller,
              state: state);
        }
        return Center(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 18, bottom: 18),
                      child: Text("Select a data provider:"),
                    )
                  ],
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  itemCount: state.collections!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                state.collections![index].id!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                const Icon(Icons.satellite_alt,
                                    color: Colors.orangeAccent),
                                const SizedBox(width: 8),
                                Text(
                                    state.collections![index].id! == "unino"
                                        ? "UniSat Sample Data Provider"
                                        : "UniSat Data Provider",
                                    style:
                                        const TextStyle(color: Colors.black87))
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.keyboard_arrow_right,
                                  color: Colors.orange, size: 30.0),
                              onPressed: () {
                                controller.handleSelectSource(
                                    state.collections![index].id!);
                              },
                            )),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class SelectionStatus extends StatelessWidget {
  const SelectionStatus({
    Key? key,
    required this.statusType,
    required this.controller,
    required this.state,
  }) : super(key: key);

  final HomeStatusType statusType;
  final SelectionController controller;
  final SelectionState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(state.errorMsg!),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text((statusType == HomeStatusType.error)
                ? " 505 Ops ! An Error occurred while updating the data from the server."
                : (statusType == HomeStatusType.loading)
                    ? "Loading ..."
                    : " Connecting to the UniSat Data Provider..."),
          ),
          statusType == HomeStatusType.error
              ? const SizedBox.shrink()
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
