// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'participant_model.dart';

class ParticipantModelAdapter extends TypeAdapter<ParticipantModel> {
  @override
  final int typeId = 2;

  @override
  ParticipantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return ParticipantModel(id: fields[0] as String, name: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, ParticipantModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
