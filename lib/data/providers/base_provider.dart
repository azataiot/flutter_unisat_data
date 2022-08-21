import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../helpers/logging.dart';

class BaseProvider extends GetConnect {
  final serverApiBaseUrl = dotenv.env['SERVER_API_BASE_URL'];
  final token = dotenv.env['TOKEN'];

  @override
  void onInit() {
    httpClient.baseUrl = serverApiBaseUrl;
    logger.i("[BaseProvider] baseUrl: $serverApiBaseUrl");

    /// request interception
    httpClient.addRequestModifier<void>((request) {
      request.headers["Authorization"] = "Basic $token";
      return request;
    });

    /// response interception
    httpClient.addResponseModifier((request, response) {
      return response;
    });
  }
}
