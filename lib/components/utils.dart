import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  return formatter.format(dateTime);
}

snackBarWidget(BuildContext context, String content) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(content)));
}
