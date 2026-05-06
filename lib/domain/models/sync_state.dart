import 'package:hive/hive.dart';

part 'sync_state.g.dart';

@HiveType(typeId: 4)
class SyncState {
  @HiveField(0)
  int unsyncedCount;

  @HiveField(1)
  DateTime? lastLocalSyncAt;

  SyncState({this.unsyncedCount = 0, this.lastLocalSyncAt});
}
