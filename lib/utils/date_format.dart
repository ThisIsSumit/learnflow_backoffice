import 'package:intl/intl.dart';

extension FormatDateTime on DateTime {
  String get formatEn => DateFormat.MMM("en_US").format(this);
}
