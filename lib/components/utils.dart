import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  return formatter.format(dateTime);
}
