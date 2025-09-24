// Package imports:
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const String dateTimeFormatPattern = 'dd/MM/yyyy';
const String isoFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
const String D_MMM_Y = 'd MMM y';
const String DD_MM = 'dd MM';
const String H_M = 'H:m';
const String H_M_A = 'h:mm a';
const String D_MMM_Y_HM = 'd MMM y, h:mm a';

const String M_S = 'mm:ss';

extension DateTimeExtension on DateTime {
  String format({
    String pattern = dateTimeFormatPattern,
    String? locale,
  }) {
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale);
    }
    return DateFormat(pattern, locale).format(this);
  }
}

String getFormatedDate(DateTime date, String format) {
  return DateFormat(format).format(date.toLocal());
}

DateTime getCurrentDate() {
  return DateTime.now().toUtc();
}

String getIsoDate(DateTime date) {
  return DateFormat(isoFormat).format(date);
}

DateTime getIsoToDate(String isoDate) {
  return DateTime.parse(isoDate).toUtc();
}

DateTime getStartOfTheDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  return DateTime(dateTime.year, dateTime.month, dateTime.day).toUtc();
}
