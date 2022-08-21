import '../../data/repositories/repository_result.dart';

class HomeState {
  bool? isLoading;
  bool? isConnecting;
  bool? isError;
  bool? isSuccess;
  String? errorMsg;
  Result? result;

  HomeState() {
    ///Initialize variables
    ///
    isLoading = true;
    isConnecting = false;
    isError = false;
    isSuccess = false;
    errorMsg = "";
  }
}
