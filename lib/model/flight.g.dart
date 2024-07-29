// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlightAdapter extends TypeAdapter<Flight> {
  @override
  final int typeId = 7;

  @override
  Flight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flight(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as String,
      rating: fields[12] as int,
      isLiked: fields[13] as bool,
      isBookmarked: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Flight obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.flights_id)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.code)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.cityName)
      ..writeByte(7)
      ..write(obj.regionName)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.countryName)
      ..writeByte(10)
      ..write(obj.countryNameShort)
      ..writeByte(11)
      ..write(obj.photoUri)
      ..writeByte(12)
      ..write(obj.rating)
      ..writeByte(13)
      ..write(obj.isLiked)
      ..writeByte(14)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
