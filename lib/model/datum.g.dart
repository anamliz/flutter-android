// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatumAdapter extends TypeAdapter<Datum> {
  @override
  final int typeId = 3;

  @override
  Datum read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Datum(
      destId: fields[0] as String,
      searchType: fields[1] as String,
      cityName: fields[2] as String,
      nrHotels: fields[3] as int,
      region: fields[4] as String,
      country: fields[5] as String,
      imageUrl: fields[6] as String?,
      type: fields[7] as String,
      name: fields[8] as String,
      hotels: fields[9] as int,
      destType: fields[10] as String,
      appFilters: fields[11] as String?,
      metaMatches: (fields[12] as List?)?.cast<MetaMatch>(),
    );
  }

  @override
  void write(BinaryWriter writer, Datum obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.destId)
      ..writeByte(1)
      ..write(obj.searchType)
      ..writeByte(2)
      ..write(obj.cityName)
      ..writeByte(3)
      ..write(obj.nrHotels)
      ..writeByte(4)
      ..write(obj.region)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.hotels)
      ..writeByte(10)
      ..write(obj.destType)
      ..writeByte(11)
      ..write(obj.appFilters)
      ..writeByte(12)
      ..write(obj.metaMatches);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
