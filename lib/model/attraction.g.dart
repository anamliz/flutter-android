// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attraction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DestinationAdapter extends TypeAdapter<Destination> {
  @override
  final int typeId = 2;

  @override
  Destination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Destination(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as String,
      fields[4] as String,
      fields[5] as int,
      fields[6] as String,
      fields[7] as String,
      rating: fields[8] as int,
      isLiked: fields[9] as bool,
      isBookmarked: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Destination obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj._typename)
      ..writeByte(2)
      ..write(obj.ufi)
      ..writeByte(3)
      ..write(obj.country)
      ..writeByte(4)
      ..write(obj.cityName)
      ..writeByte(5)
      ..write(obj.productCount)
      ..writeByte(6)
      ..write(obj.cc1)
      ..writeByte(7)
      ..write(obj.image_url)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.isLiked)
      ..writeByte(10)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DestinationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
