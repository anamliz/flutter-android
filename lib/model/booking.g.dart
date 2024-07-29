// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 4;

  @override
  Booking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Booking(
      fields[0] as int,
      fields[1] as int,
      fields[2] as DateTime,
      fields[3] as DateTime,
      fields[4] as int,
      fields[5] as int,
      fields[6] as int,
      fields[7] as String,
      fields[8] as double,
      fields[9] as DateTime,
      fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.booking_id)
      ..writeByte(1)
      ..write(obj.userid)
      ..writeByte(2)
      ..write(obj.checkInDate)
      ..writeByte(3)
      ..write(obj.checkOutDate)
      ..writeByte(4)
      ..write(obj.numAdults)
      ..writeByte(5)
      ..write(obj.numChildren)
      ..writeByte(6)
      ..write(obj.numRooms)
      ..writeByte(7)
      ..write(obj.roomType)
      ..writeByte(8)
      ..write(obj.totalPrice)
      ..writeByte(9)
      ..write(obj.bookingDate)
      ..writeByte(10)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
