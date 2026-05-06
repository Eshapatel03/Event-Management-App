// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'checkin_log.dart';

class CheckInLogAdapter extends TypeAdapter<CheckInLog> {
  @override
  final int typeId = 3;

  @override
  CheckInLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return CheckInLog(
      participantId: fields[0] as String,
      participantName: fields[1] as String,
      entryTime: fields[2] as DateTime,
      source: fields[3] as String,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CheckInLog obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.participantId)
      ..writeByte(1)
      ..write(obj.participantName)
      ..writeByte(2)
      ..write(obj.entryTime)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckInLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
