// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsersAdapter extends TypeAdapter<Users> {
  @override
  final int typeId = 11;

  @override
  Users read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Users(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Users obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userid)
      ..writeByte(1)
      ..write(obj.userfirstName)
      ..writeByte(2)
      ..write(obj.userlastName)
      ..writeByte(3)
      ..write(obj.useremail)
      ..writeByte(4)
      ..write(obj.userphoneNumber)
      ..writeByte(5)
      ..write(obj.useruserName)
      ..writeByte(6)
      ..write(obj.userpassword)
      ..writeByte(7)
      ..write(obj.userconfirmpassword)
      ..writeByte(8)
      ..write(obj.is_logged_in);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
