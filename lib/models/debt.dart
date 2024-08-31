import 'package:hive/hive.dart';

part 'debt.g.dart';

@HiveType(typeId: 0)
class Debt {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  double interestRate;

  @HiveField(3)
  double minimumPayment;

  @HiveField(4)
  DateTime dueDate;

  Debt({
    required this.name,
    required this.amount,
    required this.interestRate,
    required this.minimumPayment,
    required this.dueDate,
  });
}
