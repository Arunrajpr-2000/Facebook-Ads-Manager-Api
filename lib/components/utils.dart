import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  return formatter.format(dateTime);
}

snackBarWidget(BuildContext context, String content) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(content)));
}

String prettifyDouble(double d) =>
    d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');

String getPrice(String value) {
  final rupees = NumberFormat("#,##,##,##,###", "en_IN");
  final valueDouble = double.parse(value);
  String price = double.parse(value).toString();
  if (valueDouble >= 10000000) {
    return price = '${prettifyDouble(valueDouble / 10000000)}Cr';
  } else if (valueDouble >= 100000) {
    return price = '${prettifyDouble(valueDouble / 100000)}L';
  } else {
    return rupees.format(double.parse(price)).toString();
  }
}

String formatPhoneNumber(String phoneNumber) {
  final buffer = StringBuffer();
  final regex = RegExp(r'.{5}'); // Matches every 5 characters
  for (final match in regex.allMatches(phoneNumber)) {
    buffer.write('${match.group(0)!} ');
  }
  return buffer.toString().trim();
}

launchAdUrl(String url) async {
  final Uri parsedUrl = Uri.parse(url);
  if (!await launchUrl(parsedUrl)) {
    throw Exception('Could not launch $parsedUrl');
  }
}
