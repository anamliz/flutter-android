// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taxi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaxiAdapter extends TypeAdapter<Taxi> {
  @override
  final int typeId = 8;

  @override
  Taxi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Taxi(
      fields[0] as int,
      fields[1] as double,
      fields[2] as String,
      fields[3] as double,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      rating: fields[11] as int,
      isLiked: fields[12] as bool,
      isBookmarked: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Taxi obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.types)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.iata)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.countryCode)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.googlePlaceId)
      ..writeByte(10)
      ..write(obj.image_url)
      ..writeByte(11)
      ..write(obj.rating)
      ..writeByte(12)
      ..write(obj.isLiked)
      ..writeByte(13)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
