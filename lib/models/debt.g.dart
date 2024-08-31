// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtAdapter extends TypeAdapter<Debt> {
  @override
  final int typeId = 0;

  @override
  Debt read(BinaryReader reader) {
    return Debt(
      name: reader.read() as String,
      amount: reader.read() as double,
      interestRate: reader.read() as double,
      minimumPayment: reader.read() as double,
      dueDate: reader.read() as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Debt obj) {
    writer.write(obj.name);
    writer.write(obj.amount);
    writer.write(obj.interestRate);
    writer.write(obj.minimumPayment);
    writer.write(obj.dueDate);
  }
}
