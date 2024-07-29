// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccommodationAdapter extends TypeAdapter<Accommodation> {
  @override
  final int typeId = 1;

  @override
  Accommodation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Accommodation(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as double,
      fields[10] as double,
      fields[11] as String,
      fields[12] as String,
      fields[13] as int,
      fields[14] as int,
      fields[15] as String,
      fields[16] as int,
      //rating: fields[17] as int,
     // isLiked: fields[18] as bool,
      //isBookmarked: fields[19] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Accommodation obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.destId)
      ..writeByte(1)
      ..write(obj.searchType)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.cityName)
      ..writeByte(4)
      ..write(obj.lc)
      ..writeByte(5)
      ..write(obj.label)
      ..writeByte(6)
      ..write(obj.destType)
      ..writeByte(7)
      ..write(obj.roundtrip)
      ..writeByte(8)
      ..write(obj.cc1)
      ..writeByte(9)
      ..write(obj.longitude)
      ..writeByte(10)
      ..write(obj.latitude)
      ..writeByte(11)
      ..write(obj.country)
      ..writeByte(12)
      ..write(obj.region)
      ..writeByte(13)
      ..write(obj.hotels)
      ..writeByte(14)
      ..write(obj.nrHotels)
      ..writeByte(15)
      ..write(obj.name)
      ..writeByte(16)
      ..write(obj.cityUfi)
      ..writeByte(17)
      ..write(obj.rating)
      ..writeByte(18)
      ..write(obj.isLiked)
      ..writeByte(19)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccommodationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
