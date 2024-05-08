// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tundra.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TundraAdapter extends TypeAdapter<Tundra> {
  @override
  final int typeId = 2;

  @override
  Tundra read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tundra(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as double,
      fields[4] as int,
      fields[5] as String,
      isLiked: fields[6] as bool,
      isBookmarked: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Tundra obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.tundraid)
      ..writeByte(1)
      ..write(obj.tundraname)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.imageurl)
      ..writeByte(6)
      ..write(obj.isLiked)
      ..writeByte(7)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TundraAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
