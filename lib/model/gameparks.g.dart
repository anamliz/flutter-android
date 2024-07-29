// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameparks.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParkAdapter extends TypeAdapter<Park> {
  @override
  final int typeId = 9;

  @override
  Park read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Park(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as double,
      fields[4] as DateTime,
      fields[5] as double,
      fields[6] as String,
      rating: fields[7] as int,
      isLiked: fields[8] as bool,
      isBookmarked: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Park obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.park_id)
      ..writeByte(1)
      ..write(obj.park_name)
      ..writeByte(2)
      ..write(obj.park_location)
      ..writeByte(3)
      ..write(obj.size_in_acres)
      ..writeByte(4)
      ..write(obj.established_date)
      ..writeByte(5)
      ..write(obj.entry_fee)
      ..writeByte(6)
      ..write(obj.image_url)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.isLiked)
      ..writeByte(9)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
