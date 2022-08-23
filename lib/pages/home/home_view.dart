import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:unisat_data/pages/home/home_state.dart';
import 'package:unisat_data/widgets/svg/azt_svg_logo.dart';
import '../../data/enums/selected.dart';
import '../../data/models/record.dart';
import '../../data/tests/data.dart';
import 'home_controller.dart';
import 'package:graphic/graphic.dart';

final _monthDayFormat = DateFormat('MM-dd HH:mm:ss');

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
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Container(
            margin: const EdgeInsets.only(top: 32.0, bottom: 32.0),
            child: AztSvgLogoText(
              svgAsset: 'assets/logo/logo-unisat.svg',
              spaceBetweenLogoAndText: 6.0,
              logoText: 'app_name'.tr,
            ),
          ),
        ),
        body: PhoneBody(
          state: state,
          controller: controller,
        ),
      );
    });
  }

  @override
  Widget tablet() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Container(
            margin: const EdgeInsets.only(top: 32.0, bottom: 32.0),
            child: AztSvgLogoText(
              svgAsset: 'assets/logo/logo-unisat.svg',
              spaceBetweenLogoAndText: 6.0,
              logoText: 'app_name'.tr,
            ),
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
  Widget desktop() {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Container(
            margin: const EdgeInsets.only(top: 32.0, bottom: 32.0),
            child: AztSvgLogoText(
              svgAsset: 'assets/logo/logo-unisat.svg',
              spaceBetweenLogoAndText: 6.0,
              logoText: 'app_name'.tr,
            ),
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

class PhoneBody extends StatelessWidget {
  const PhoneBody({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  final HomeState state;
  final HomeController controller;

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
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          children: <Widget>[
            // last updated
            Text(
              state.records!.isNotEmpty
                  ? "last updated:  (${state.lastUpdated})"
                  : 'updating...',
              style: const TextStyle(fontSize: 12),
            ),
            // overview text
            ListTile(
              title:
                  Text(state.records!.isNotEmpty ? "Overview" : 'updating...'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardOverView(
                  margin: const EdgeInsets.only(right: 8.0),
                  width: Get.width / 2 - 16,
                  label: "temperature",
                  iconSvg: "assets/icons/temperature.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].temperature.toString()
                      : 'updating...',
                  unit: "°C",
                ),
                CardOverView(
                  width: Get.width / 2 - 16,
                  label: "humidity",
                  iconSvg: "assets/icons/humidity.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].humidity.toString()
                      : 'updating...',
                  unit: "%",
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                CardOverView(
                  margin: const EdgeInsets.only(right: 8.0),
                  width: Get.width / 2 - 16,
                  label: "pressure",
                  iconSvg: "assets/icons/pressure.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].pressure.toString()
                      : 'updating...',
                  unit: "kPa",
                ),
                CardOverView(
                  width: Get.width / 2 - 16,
                  label: "PM2.5",
                  iconSvg: "assets/icons/pm25.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].pm25.toString()
                      : 'updating...',
                  unit: "µg/m³",
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                CardOverView(
                  margin: const EdgeInsets.only(right: 8.0),
                  width: Get.width / 2 - 16,
                  label: "PM10",
                  iconSvg: "assets/icons/pm10.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].pm10.toString()
                      : 'updating...',
                  unit: "µg/m³",
                ),
              ],
            ),
            // charts title
            const SizedBox(height: 8.0),
            ListTile(
                title: Row(
              children: [
                Text(state.records!.isNotEmpty ? "Charts: " : 'updating...'),
                ChartTextButton(
                  title: "temperature",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.temperature,
                ),
                ChartTextButton(
                  title: "humidity",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.humidity,
                ),
                ChartTextButton(
                  title: "pressure",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.pressure,
                ),
                ChartTextButton(
                  title: "pm25",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.pm25,
                ),
                ChartTextButton(
                  title: "pm10",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.pm10,
                ),
              ],
            )),
            Row(
              children: [
                HomeChart(
                  state: state,
                  controller: controller,
                  height: (Get.width - 32) * 3 / 4,
                )
              ],
            ),
            const SizedBox(height: 16),
            PaginatedDataTable(
              columnSpacing: Get.width / 6 - 64,
              header: Text(state.records!.isNotEmpty
                  ? "Data (last 200 records)"
                  : 'updating...'),
              columns: const [
                DataColumn(label: Text("timestamp")),
                DataColumn(label: Text("temperature")),
                DataColumn(label: Text("humidity")),
                DataColumn(label: Text("pressure")),
                DataColumn(label: Text("pm2.5")),
                DataColumn(label: Text("pm10")),
              ],
              source: TableDataSource(state: state, controller: controller),
            ),
            const Footer()
          ],
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: const [
          SizedBox(height: 16),
          Center(
            child: Text(
              "UniSat All rights Reserved",
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
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
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // last updated
            Text(
              state.records!.isNotEmpty
                  ? "last updated:  (${state.lastUpdated})"
                  : 'updating...',
              style: const TextStyle(fontSize: 12),
            ),
            // overview text
            ListTile(
              title:
                  Text(state.records!.isNotEmpty ? "Overview" : 'updating...'),
            ),
            // overview cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardOverView(
                  label: "temperature",
                  iconSvg: "assets/icons/temperature.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].temperature.toString()
                      : 'updating...',
                  unit: "°C",
                ),
                CardOverView(
                  label: "humidity",
                  iconSvg: "assets/icons/humidity.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].humidity.toString()
                      : 'updating...',
                  unit: "%",
                ),
                CardOverView(
                  label: "pressure",
                  iconSvg: "assets/icons/pressure.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].pressure.toString()
                      : 'updating...',
                  unit: "kPa",
                  width: 24,
                ),
                CardOverView(
                  label: "PM2.5",
                  iconSvg: "assets/icons/pm25.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].pm25.toString()
                      : 'updating...',
                  unit: "µg/m³",
                ),
                CardOverView(
                  label: "PM10",
                  iconSvg: "assets/icons/pm10.svg",
                  data: state.records!.isNotEmpty
                      ? state.records![0].pm10.toString()
                      : 'updating...',
                  unit: "µg/m³",
                ),
              ],
            ),
            // charts title
            ListTile(
                title: Row(
              children: [
                Text(state.records!.isNotEmpty ? "Charts: " : 'updating...'),
                ChartTextButton(
                  title: "temperature",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.temperature,
                ),
                ChartTextButton(
                  title: "humidity",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.humidity,
                ),
                ChartTextButton(
                  title: "pressure",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.pressure,
                ),
                ChartTextButton(
                  title: "pm25",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.pm25,
                ),
                ChartTextButton(
                  title: "pm10",
                  state: state,
                  controller: controller,
                  type: EnumCurrentSelected.pm10,
                ),
              ],
            )),
            // charts
            Row(
              children: [
                HomeChart(state: state, controller: controller),
              ],
            ),
            const SizedBox(height: 10),
            PaginatedDataTable(
              columnSpacing: Get.width / 6 - 64,
              header: Text(state.records!.isNotEmpty
                  ? "Data (last 200 records)"
                  : 'updating...'),
              columns: const [
                DataColumn(label: Text("Timestamp")),
                DataColumn(label: Text("Temperature")),
                DataColumn(label: Text("Humidity")),
                DataColumn(label: Text("Pressure")),
                DataColumn(label: Text("PM2.5")),
                DataColumn(label: Text("PM10")),
              ],
              source: TableDataSource(state: state, controller: controller),
            ),
            const Footer()
          ],
        ),
      ),
    );
  }
}

class ChartTextButton extends StatelessWidget {
  const ChartTextButton({
    Key? key,
    required this.title,
    required this.type,
    required this.state,
    required this.controller,
  }) : super(key: key);

  final String title;
  final EnumCurrentSelected type;
  final HomeState state;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        controller.switchChart(type);
      },
      style: TextButton.styleFrom(
        primary: state.currentSelected == type ? Colors.orange : Colors.grey,
      ),
      child: FittedBox(fit: BoxFit.fitWidth, child: Text(title)),
    );
  }
}

class ChartIconButton extends StatelessWidget {
  const ChartIconButton({
    Key? key,
    required this.svgAsset,
    required this.type,
    required this.state,
    required this.controller,
  }) : super(key: key);

  final String svgAsset;
  final EnumCurrentSelected type;
  final HomeState state;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        controller.switchChart(type);
      },
      icon: SvgPicture.asset(svgAsset),
    );
  }
}

class HomeChart extends StatelessWidget {
  const HomeChart({
    Key? key,
    required this.state,
    required this.controller,
    this.width,
    this.height,
  }) : super(key: key);

  final HomeController controller;
  final HomeState state;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    Map<String, Variable<Record, dynamic>> variables = {};

    switch (state.currentSelected) {
      case EnumCurrentSelected.temperature:
        variables = {
          'datetime': Variable(
            accessor: (Record record) =>
                DateTime.fromMillisecondsSinceEpoch(record.timestamp! * 1000),
            scale: TimeScale(
              formatter: (time) => _monthDayFormat.format(time),
            ),
          ),
          'temperature': Variable(
            accessor: (Record record) => record.temperature as num,
            scale: LinearScale(
              min: (controller.getVarMin(varType: VarType.temperature) - 0.5)
                  .floor(),
              max: (controller.getVarMax(varType: VarType.temperature) + 0.5)
                  .ceil(),
            ),
          )
        };
        break;
      case EnumCurrentSelected.humidity:
        variables = {
          'datetime': Variable(
            accessor: (Record record) =>
                DateTime.fromMillisecondsSinceEpoch(record.timestamp! * 1000),
            scale: TimeScale(
              formatter: (time) => _monthDayFormat.format(time),
            ),
          ),
          'humidity': Variable(
            accessor: (Record record) => record.humidity as num,
            scale: LinearScale(
              min: (controller.getVarMin(varType: VarType.humidity) - 0.5)
                  .floor(),
              max: (controller.getVarMax(varType: VarType.humidity) + 0.5)
                  .ceil(),
            ),
          )
        };
        break;
      case EnumCurrentSelected.pressure:
        variables = {
          'datetime': Variable(
            accessor: (Record record) =>
                DateTime.fromMillisecondsSinceEpoch(record.timestamp! * 1000),
            scale: TimeScale(
              formatter: (time) => _monthDayFormat.format(time),
            ),
          ),
          'pressure': Variable(
            accessor: (Record record) => record.pressure as num,
            scale: LinearScale(
              min: (controller.getVarMin(varType: VarType.pressure) - 0.5)
                  .floor(),
              max: (controller.getVarMax(varType: VarType.pressure) + 0.5)
                  .ceil(),
            ),
          )
        };
        break;
      case EnumCurrentSelected.pm25:
        variables = {
          'datetime': Variable(
            accessor: (Record record) =>
                DateTime.fromMillisecondsSinceEpoch(record.timestamp! * 1000),
            scale: TimeScale(
              formatter: (time) => _monthDayFormat.format(time),
            ),
          ),
          'pm25': Variable(
            accessor: (Record record) => record.pm25 as num,
            scale: LinearScale(
              min: (controller.getVarMin(varType: VarType.pm25) - 0.5).floor(),
              max: (controller.getVarMax(varType: VarType.pm25) + 0.5).ceil(),
            ),
          )
        };
        break;
      case EnumCurrentSelected.pm10:
        variables = {
          'datetime': Variable(
            accessor: (Record record) =>
                DateTime.fromMillisecondsSinceEpoch(record.timestamp! * 1000),
            scale: TimeScale(
              formatter: (time) => _monthDayFormat.format(time),
            ),
          ),
          'pm10': Variable(
            accessor: (Record record) => record.pm10 as num,
            scale: LinearScale(
              min: (controller.getVarMin(varType: VarType.pm10) - 0.5).floor(),
              max: (controller.getVarMax(varType: VarType.pm10) + 0.5).ceil(),
            ),
          )
        };
        break;
      case null:
        break;
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: width ?? Get.width - 32,
      height: height ?? (Get.width - 32) * 2 / 5,
      child: Chart(
        data: state.records!,
        variables: variables,
        elements: [
          LineElement(
            color: ColorAttr(
              value: Colors.orange,
            ),
            shape: ShapeAttr(value: BasicLineShape(dash: [5, 2])),
            selected: {
              'touchMove': {1}
            },
          )
        ],
        coord: RectCoord(color: Colors.transparent),
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
        selections: {
          'touchMove': PointSelection(
            on: {
              GestureType.scaleUpdate,
              GestureType.tapDown,
              GestureType.longPressMoveUpdate
            },
            dim: Dim.x,
          )
        },
        tooltip: TooltipGuide(
          followPointer: [false, true],
          align: Alignment.topLeft,
          offset: const Offset(-20, -20),
        ),
      ),
    );
  }
}

class CardOverView extends StatelessWidget {
  const CardOverView(
      {Key? key,
      required this.label,
      required this.iconSvg,
      required this.data,
      required this.unit,
      this.width,
      this.height,
      this.margin})
      : super(key: key);

  final String label;
  final String iconSvg;
  final String data;
  final String unit;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width / 5 - 32,
      child: Card(
        margin: margin ?? EdgeInsets.zero,
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
              const SizedBox(height: 16),
              SvgPicture.asset(
                iconSvg,
                width: width ?? 32,
                height: height ?? 32,
              ),
              const SizedBox(height: 16),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "$data  $unit",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
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
        title: AztSvgLogoText(
          svgAsset: 'assets/logo/logo-unisat.svg',
          spaceBetweenLogoAndText: 6.0,
          logoText: 'app_name'.tr,
        ),
      ),
      body: body,
    );
  }
}

//
class TableDataSource extends DataTableSource {
  TableDataSource({
    required this.controller,
    required this.state,
  }) : super();

  final HomeState state;
  final HomeController controller;

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(
        DateFormat.yMd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(
            state.records![index].timestamp! * 1000)),
      )),
      DataCell(
        Text(state.records![index].temperature.toString()),
      ),
      DataCell(
        Text(state.records![index].humidity.toString()),
      ),
      DataCell(
        Text(state.records![index].pressure.toString()),
      ),
      DataCell(
        Text(state.records![index].pm25.toString()),
      ),
      DataCell(
        Text(state.records![index].pm10.toString()),
      )
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => state.records!.length;

  @override
  int get selectedRowCount => 0;
}
