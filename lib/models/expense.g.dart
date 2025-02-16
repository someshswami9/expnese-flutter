// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 1;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      amount: fields[2] as double,
      date: fields[3] as DateTime,
      title: fields[1] as String,
      category: fields[4] as Category,
      paymentMethod: fields[5] as String?,
      friendNames: (fields[6] as List?)?.cast<String>(),
      customCategory: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.paymentMethod)
      ..writeByte(6)
      ..write(obj.friendNames)
      ..writeByte(7)
      ..write(obj.customCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 0;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.bajajEmi;
      case 1:
        return Category.homeRent;
      case 2:
        return Category.electricityBill;
      case 3:
        return Category.zomat;
      case 4:
        return Category.blinkit;
      case 5:
        return Category.zepto;
      case 6:
        return Category.outsideBreakfast;
      case 7:
        return Category.lunch;
      case 8:
        return Category.restaurant;
      case 9:
        return Category.petrol;
      case 10:
        return Category.servicing;
      case 11:
        return Category.mobileRecharge;
      case 12:
        return Category.wifiRecharge;
      case 13:
        return Category.dmart;
      case 14:
        return Category.grocery;
      case 15:
        return Category.frullatto;
      case 16:
        return Category.friends;
      case 17:
        return Category.others;
      default:
        return Category.bajajEmi;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.bajajEmi:
        writer.writeByte(0);
        break;
      case Category.homeRent:
        writer.writeByte(1);
        break;
      case Category.electricityBill:
        writer.writeByte(2);
        break;
      case Category.zomat:
        writer.writeByte(3);
        break;
      case Category.blinkit:
        writer.writeByte(4);
        break;
      case Category.zepto:
        writer.writeByte(5);
        break;
      case Category.outsideBreakfast:
        writer.writeByte(6);
        break;
      case Category.lunch:
        writer.writeByte(7);
        break;
      case Category.restaurant:
        writer.writeByte(8);
        break;
      case Category.petrol:
        writer.writeByte(9);
        break;
      case Category.servicing:
        writer.writeByte(10);
        break;
      case Category.mobileRecharge:
        writer.writeByte(11);
        break;
      case Category.wifiRecharge:
        writer.writeByte(12);
        break;
      case Category.dmart:
        writer.writeByte(13);
        break;
      case Category.grocery:
        writer.writeByte(14);
        break;
      case Category.frullatto:
        writer.writeByte(15);
        break;
      case Category.friends:
        writer.writeByte(16);
        break;
      case Category.others:
        writer.writeByte(17);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
