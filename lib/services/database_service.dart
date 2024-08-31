import 'package:hive_flutter/hive_flutter.dart';
import '../models/debt.dart';

class DatabaseService {
  final Box<Debt> debtBox = Hive.box<Debt>('debts');

  void addDebt(Debt debt) {
    debtBox.add(debt);
  }

  List<Debt> getDebts() {
    return debtBox.values.toList();
  }

  void updateDebt(int index, Debt debt) {
    debtBox.putAt(index, debt);
  }

  void deleteDebt(int index) {
    debtBox.deleteAt(index);
  }
}
