class HomeState {
  bool? isLoading;
  bool? isConnecting;
  bool? isError;
  bool? isSuccess;
  String? errorMsg;

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
