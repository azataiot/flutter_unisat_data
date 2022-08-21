enum ResultStatus {
  success,
  failed,
}

class Result<T> {
  late bool ok;
  late final String? statusText;
  final T? result;

  Result({
    required this.ok,
    this.statusText = '',
    this.result,
  });
}
