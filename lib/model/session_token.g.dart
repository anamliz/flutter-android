// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_token.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionTokenAdapter extends TypeAdapter<SessionToken> {
  @override
  final int typeId = 10;

  @override
  SessionToken read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionToken(
      token: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SessionToken obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
