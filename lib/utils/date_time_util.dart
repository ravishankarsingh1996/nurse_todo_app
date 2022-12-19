import 'package:intl/intl.dart';

class DateTimeUtils {
  String formatDate(DateTime date, {String format = 'yyyy-MM-dd – kk:mm'}) {
    return DateFormat(format).format(date);
  }
}
