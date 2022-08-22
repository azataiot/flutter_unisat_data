import '../../data/models/collection.dart';
import '../../data/models/data_source.dart';
import '../../data/models/record.dart';
import '../../data/repositories/repository_result.dart';

class HomeState {
  bool? isLoading;
  bool? isConnecting;
  bool? isError;
  bool? isSuccess;
  String? errorMsg;
  Result? result;
  List<DataSourceData>? dataSource;
  List<Record>? records;
  List<Collection>? collections;

  HomeState() {
    ///Initialize variables
    ///
    isLoading = true;
    isConnecting = false;
    isError = false;
    isSuccess = false;
    errorMsg = "";
    records = [];
    collections = [];
  }
}
