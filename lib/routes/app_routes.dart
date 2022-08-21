import 'package:get/get.dart';

import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';

abstract class AppPages {
  static final pages = [
    /// HomePage
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}

abstract class AppRoutes {
  // All application routes will be defined inside this class.

  /// language selection
  static const language = "/language";

  /// Home Page
  static const home = "/home";

  /// Search
  static const search = "/search";
}
