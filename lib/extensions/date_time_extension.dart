import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formatDateYYYYMMDDHHMM => DateFormat('yyyy-MM-dd – KK:mm a').format(this);

  int get formatDateTo24HourFormat => int.parse(DateFormat('kk').format(this));

  int get formatDateToMinuteFormat => int.parse(DateFormat('mm').format(this));
}