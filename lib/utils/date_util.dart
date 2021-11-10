import 'package:intl/intl.dart';

class DateUtil {
  static String getDateId(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
  }
}
