import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:unisat_data/pages/home/home_state.dart';
import 'package:unisat_data/widgets/svg/azt_svg_logo.dart';
import '../../data/models/record.dart';
import 'home_controller.dart';
import 'package:graphic/graphic.dart';

final _monthDayFormat = DateFormat('MM-dd');

enum HomeStatusType {
  loading,
  connecting,
  error,
}

class HomePage extends GetResponsiveView<HomeController>
    implements PreferredSizeWidget {
  @override
  final controller = Get.find<HomeController>();
  final tabController = Get.find<HomeTabController>();
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
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 32.0, bottom: 32.0),
            child: AztSvgLogoText(
              svgAsset: 'assets/logo/logo-unisat.svg',
              spaceBetweenLogoAndText: 6.0,
              logoText: 'app_name'.tr,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            controller: tabController.controller,
            tabs: [
              Tab(
                height: 128,
                child: CardOverView(
                  label: "temperature",
                  iconSvg: "assets/icons/temperature.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].temperature.toString()
                      : 'updating...',
                  unit: "°C",
                ),
              ),
              Tab(
                height: 128,
                child: CardOverView(
                  label: "humidity",
                  iconSvg: "assets/icons/humidity.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].humidity.toString()
                      : 'updating...',
                  unit: "%",
                ),
              ),
              Tab(
                height: 128,
                child: CardOverView(
                  label: "pressure",
                  iconSvg: "assets/icons/pressure.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].pressure.toString()
                      : 'updating...',
                  unit: "kPa",
                  width: 24,
                ),
              ),
              Tab(
                height: 128,
                child: CardOverView(
                  label: "PM2.5",
                  iconSvg: "assets/icons/pm25.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].pm25.toString()
                      : 'updating...',
                  unit: "µg/m³",
                ),
              ),
              Tab(
                height: 128,
                child: CardOverView(
                  label: "PM10",
                  iconSvg: "assets/icons/pm10.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].pm10.toString()
                      : 'updating...',
                  unit: "µg/m³",
                ),
              ),
            ],
          ),
        ),
        body: DesktopBody(
          controller: controller,
          state: state,
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(200);
}

class DesktopBody extends StatelessWidget {
  DesktopBody({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  final HomeState state;
  final HomeController controller;
  final tabController = Get.find<HomeTabController>();

  @override
  Widget build(BuildContext context) {
    if (state.isError!) {
      return HomeStatus(
          statusType: HomeStatusType.error,
          controller: controller,
          state: state);
    } else if (state.isLoading!) {
      return HomeStatus(
          statusType: HomeStatusType.loading,
          controller: controller,
          state: state);
    } else if (state.isConnecting!) {
      return HomeStatus(
          statusType: HomeStatusType.connecting,
          controller: controller,
          state: state);
    }
    return TabBarView(
      controller: tabController.controller,
      children: [
        // temperature
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: 350,
          height: 300,
          child: Chart(
            data: state.records!,
            variables: {
              'datetime': Variable(
                accessor: (Record record) =>
                    DateTime.fromMillisecondsSinceEpoch(
                        record.timestamp! * 1000),
                scale: TimeScale(
                  formatter: (time) => _monthDayFormat.format(time),
                ),
              ),
              'temperature': Variable(
                accessor: (Record record) => record.temperature as num,
                scale: LinearScale(
                    min: controller.getVarMin(varType: VarType.temperature) - 1,
                    max:
                        controller.getVarMax(varType: VarType.temperature) + 1),
              ),
            },
            elements: [
              LineElement(
                shape: ShapeAttr(value: BasicLineShape(dash: [5, 2])),
                color: ColorAttr(value: Defaults.colors10[3].withAlpha(100)),
                selected: {
                  'touchMove': {1}
                },
              )
            ],
            coord: RectCoord(
              horizontalRangeUpdater: Defaults.horizontalRangeSignal,
              verticalRangeUpdater: Defaults.verticalRangeSignal,
            ),
            axes: [
              Defaults.horizontalAxis,
              Defaults.verticalAxis,
            ],
          ),
        ),
        // humidity body
        const CardOverView(
          label: "Temperature",
          iconSvg: "assets/icons/temperature.svg",
          data: "37.4",
          unit: "kg",
        ),
        // pressure body
        const CardOverView(
          label: "Temperature",
          iconSvg: "assets/icons/temperature.svg",
          data: "37.4",
          unit: "kg",
        ),
        // pm2.5 body
        const CardOverView(
          label: "Temperature",
          iconSvg: "assets/icons/temperature.svg",
          data: "37.4",
          unit: "kg",
        ),
        // pm10 body
        const CardOverView(
          label: "Temperature",
          iconSvg: "assets/icons/temperature.svg",
          data: "37.4",
          unit: "kg",
        ),
      ],
    );
  }
}

class CardOverView extends StatelessWidget {
  const CardOverView({
    Key? key,
    required this.label,
    required this.iconSvg,
    required this.data,
    required this.unit,
    this.width,
    this.height,
  }) : super(key: key);

  final String label;
  final String iconSvg;
  final String data;
  final String unit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 5 - 32,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0.4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Center(
            child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Text(label),
              const SizedBox(height: 8),
              SvgPicture.asset(
                iconSvg,
                width: width ?? 32,
                height: height ?? 32,
              ),
              const SizedBox(height: 8),
              Text(
                "$data  $unit",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class HomeStatus extends StatelessWidget {
  const HomeStatus({
    Key? key,
    required this.statusType,
    required this.controller,
    required this.state,
  }) : super(key: key);

  final HomeStatusType statusType;
  final HomeController controller;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
      body: body,
    );
  }
}
