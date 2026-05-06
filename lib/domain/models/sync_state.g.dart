// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'sync_state.dart';

class SyncStateAdapter extends TypeAdapter<SyncState> {
  @override
  final int typeId = 4;

  @override
  SyncState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return SyncState(
      unsyncedCount: fields[0] as int,
      lastLocalSyncAt: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.unsyncedCount)
      ..writeByte(1)
      ..write(obj.lastLocalSyncAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
