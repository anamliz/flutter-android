// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biome.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BiomeAdapter extends TypeAdapter<Biome> {
  @override
  final int typeId = 1;

  @override
  Biome read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Biome(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as double,
      fields[4] as double,
      fields[5] as double,
      fields[6] as int,
      fields[7] as String,
      isLiked: fields[8] as bool,
      isBookmarked: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Biome obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.biomeid)
      ..writeByte(1)
      ..write(obj.biomename)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.imageurl)
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
      other is BiomeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
