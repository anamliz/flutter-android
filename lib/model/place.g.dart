// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceAdapter extends TypeAdapter<Place> {
  @override
  final int typeId = 0;

  @override
  Place read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Place(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as double,
      fields[5] as String,
      rating: fields[4] as int,
      isLiked: fields[6] as bool,
      isBookmarked: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Place obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.placeName)
      ..writeByte(2)
      ..write(obj.placeDescription)
      ..writeByte(3)
      ..write(obj.placePrice)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.placeImageUrl)
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
      other is PlaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
