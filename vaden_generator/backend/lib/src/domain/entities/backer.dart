import 'package:vaden/vaden.dart';

@DTO()
class Backer {
  final bool isBacker;
  final bool isPaidThisMonth;
  final int thisMonthPaidValue;

  Backer({
    required this.isBacker,
    this.isPaidThisMonth = false,
    this.thisMonthPaidValue = 0,
  });
}
