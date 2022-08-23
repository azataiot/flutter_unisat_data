import 'package:logger/logger.dart';

final logger = Logger(
  // TODO: remove this in production
  filter: null,
  printer: PrefixPrinter(
    PrettyPrinter(colors: false),
  ),
);
