import 'package:intl/intl.dart';

String getDayNow() {
  final now = DateTime.now();
  final formatter = DateFormat('MMM d, yyyy');
  final formattedDate = formatter.format(now);
  return formattedDate; // Output: Mar 10, 2024
}

String getMounthNow() {
  var now = DateTime.now();
  var formatter = DateFormat('MMM, yyyy');
  String formattedDate = formatter.format(now);

  return formattedDate;
}
