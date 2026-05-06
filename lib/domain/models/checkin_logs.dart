import 'package:hive/hive.dart';

part 'checkin_log.g.dart';

@HiveType(typeId: 3)
class CheckInLog {
  @HiveField(0)
  final String participantId;

  @HiveField(1)
  final String participantName;

  @HiveField(2)
  final DateTime entryTime;

  @HiveField(3)
  final String source; // qr/manual

  @HiveField(4)
  final String status; // checked_in / rejected...

  CheckInLog({
    required this.participantId,
    required this.participantName,
    required this.entryTime,
    required this.source,
    required this.status,
  });
}
