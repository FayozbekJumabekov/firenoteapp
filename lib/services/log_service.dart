import 'package:firenoteapp/services/auth_services.dart';
import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void d(String message) {
    if (AuthenticationService.logger) _logger.d(message);
  }

  static void i(String message) {
    if (AuthenticationService.logger) _logger.i(message);
  }

  static void e(String message) {
    if (AuthenticationService.logger) _logger.e(message);
  }

  static void w(String message) {
    if (AuthenticationService.logger) _logger.w(message);
  }
}